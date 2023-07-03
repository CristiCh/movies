//
//  MovieViewModel.swift
//  Movies
//
//  Created by Cristian Chertes on 26.12.2022.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics

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
    @Published var dataSource: [MoviesCellViewModel] = []
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool = false
    
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
        
        Task {
            let relatedMovies = await moviesService.fetchRelatedMovies(movieId: movieID, page: 1)
            
            if let result = try? relatedMovies.result.get() {
                let moviesDB = result.results.compactMap { apiMovie in
                    MovieDB.transform(movie:apiMovie, configuration:serviceConfig)
                }
                let carouselDB = CarouselDB(id: "movie_\(movieID)", movies: moviesDB)
                
                DispatchQueue.main.async {
                    self.databaseManager.save(objects: [carouselDB])
                }
            } else {
                dataSource.append(contentsOf: [])
            }
        }
        loadFavorite(movieID: movieID)
        Analytics.logEvent("Movie_detail", parameters: ["MovieID": "\(movieID)"])
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
        
        DispatchQueue.main.async {
            self.databaseManager.get(type: CarouselDB.self, query: {
                $0.id.equals("movie_\(self.movieID ?? "")")
            })?
                .collectionPublisher
                .subscribe(on: DispatchQueue(label: "BackgroundQueue"))
                .freeze()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { results in
                    Task {
                        if results.count == 1, let carouselDB = results.first {
                            var cells = [MoviesCellViewModel]()
                            
                            let movieVM: [MoviesCellViewModel] = carouselDB.movies.compactMap({ movieDB in
                                Movie.transform(movie: movieDB.freeze())
                            }).compactMap({ movie in
                                MoviesCellViewModel(movie: movie)
                            })
                            cells.append(contentsOf: movieVM)
                            self.dataSource = cells
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
    
    func saveFavorite(movie: Movie?) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid, let movie = movie else {
            print("Missing userID")
            return
        }
        try? db.collection("users").document(userId).collection("favorites").document(movie.id).setData(from: movie) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.isFavorite = true
                print("Document added with ID: \(movie.id)")
            }
        }
    }
    
    func deleteFavorite(movieID: String?) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid, let movieID = movieID else {
            print("Missing userID")
            return
        }
        
        db.collection("users").document(userId).collection("favorites").document(movieID).delete { err in
            if let err = err {
                print("Error deleting document: \(err)")
            } else {
                self.isFavorite = false
                print("Document deleted with ID: \(movieID)")
            }
        }
    }
    
    func loadFavorite(movieID: String) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Missing userID")
            return
        }
        
        db.collection("users").document(userId).collection("favorites").document(movieID).getDocument { document, err in
            if let document = document, document.exists {
                self.isFavorite = true
                print("Document with ID \(movieID) exists")
            } else {
                self.isFavorite = false
                print("Document does not exist")
            }
        }
    }
}
