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
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var movie: CurrentValueSubject<Movie?, Never> { get }
}

class MovieViewModel: MovieViewModelProtocol {
    private var movieID: String?
    private let moviesService: MoviesServiceProtocol
    private let serviceConfig: ServiceConfigurationProtocol
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var movie = CurrentValueSubject<Movie?, Never>(nil)
    
    init(moviesService: MoviesServiceProtocol, serviceConfiguration: ServiceConfigurationProtocol) {
        self.moviesService = moviesService
        self.serviceConfig = serviceConfiguration
    }
    
    func loadMovieData(movieID: String) {
        self.movieID = movieID
        isLoading.send(true)
        Task {
            let movieData = await moviesService.fetchMovie(movieId: movieID)
            if let result = try? movieData.result.get() {
                movie.send(Movie.transform(movie: result, configuration: serviceConfig))
            } else {
                movie.send(nil)
            }
            isLoading.send(false)
        }
    }
}
