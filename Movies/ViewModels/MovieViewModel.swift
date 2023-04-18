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
    @Published var movie: Movie? = nil
    @Published var isLoading: Bool = false
    
    init(moviesService: MoviesServiceProtocol, serviceConfiguration: ServiceConfigurationProtocol) {
        self.moviesService = moviesService
        self.serviceConfig = serviceConfiguration
    }
    
    func loadMovieData(movieID: String) {
        self.movieID = movieID
        isLoading = true
        Task {
            let movieData = await moviesService.fetchMovie(movieId: movieID)
            if let result = try? movieData.result.get() {
                await setMovieData(movie: Movie.transform(movie: result, configuration: serviceConfig))
            } else {
                await setMovieData(movie: nil)
            }
        }
    }
    
    private func setMovieData(movie: Movie?) async {
        await MainActor.run {
            self.movie = movie
            self.isLoading = false
        }
    }
}
