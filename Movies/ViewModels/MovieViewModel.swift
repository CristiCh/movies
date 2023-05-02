//
//  MovieViewModel.swift
//  Movies
//
//  Created by Cristian Chertes on 26.12.2022.
//

import Foundation
import Combine

protocol MovieViewModelProtocol {
    func loadMovieData(movieID: String)
    var isLoading: Bool { get }
    var movie: Movie? { get }
}

class MovieViewModel: MovieViewModelProtocol, ObservableObject {
    private var movieID: String?
    private let moviesService: MoviesServiceProtocol
    private let serviceConfig: ServiceConfigurationProtocol
    private let databaseManager: DatabaseManager
    private var cancellables: Set<AnyCancellable> = []
    @Published var movie: Movie? = nil
    @Published var isLoading: Bool = false
    
    init(moviesService: MoviesServiceProtocol, serviceConfiguration: ServiceConfigurationProtocol, databaseManager: DatabaseManager) {
        self.moviesService = moviesService
        self.serviceConfig = serviceConfiguration
        self.databaseManager = databaseManager
    }
    
    func loadMovieData(movieID: String) {
        self.movieID = movieID
        loadFromDatabase()
        isLoading = true
        Task {
            let movieData = await moviesService.fetchMovie(movieId: movieID)
            if let result = try? movieData.result.get() {
                DispatchQueue.main.async {
                    if let movieDB = MovieDB.transform(movie:result, configuration: self.serviceConfig) {
                        self.databaseManager.save(objects: [movieDB])
                    }
                }
            }
        }
    }
    
    private func loadFromDatabase() {
        DispatchQueue.main.async {
            self.databaseManager.get(type: MovieDB.self, query: {
                $0.id.equals(self.movieID ?? "")
            })?
                .collectionPublisher
                .subscribe(on: DispatchQueue(label: "BackgroundQueue"))
                .freeze()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { results in
                    Task {
                        if results.count == 1, let movieDB = results.first {
                            let movie = Movie.transform(movie: movieDB.freeze())
                            await self.setMovieData(movie: movie)
                        } else {
                            await self.setMovieData(movie: nil)
                        }
                    }
                }).store(in: &self.cancellables)
        }
    }
    
    private func setMovieData(movie: Movie?) async {
        await MainActor.run {
            self.movie = movie
            self.isLoading = false
        }
    }
}
