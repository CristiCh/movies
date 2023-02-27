//
//  MockMovieService.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 20.02.2023.
//

import Foundation
import Alamofire
@testable import Movies

class MockMovieService: MoviesServiceProtocol {
    var popularMovies: DataResponse<MoviesPaginator<ApiMovie>, Error>!
    var movie: DataResponse<ApiMovie, Error>!
    var fetchMovieCounter: Int = 0
    var fetchPopularMovieCounter: Int = 0
    var fetchMovieID: String? = nil
    
    func fetchPopularMovies(page: Int) async -> DataResponse<MoviesPaginator<ApiMovie>, Error> {
        fetchPopularMovieCounter += 1
        return popularMovies
    }
    
    func fetchMovie(movieId: String) async -> DataResponse<ApiMovie, Error> {
        fetchMovieCounter += 1
        fetchMovieID = movieId
        return movie
    }
}
