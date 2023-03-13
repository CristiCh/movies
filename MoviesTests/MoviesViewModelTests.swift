//
//  MoviesViewModelTests.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 27.02.2023.
//

import XCTest
import Mocker
import Alamofire
import Combine
@testable import Movies

final class MoviesViewModelTests: XCTestCase {
    var moviesViewModel: MoviesViewModel!
    var mockMovieService: MockMovieService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockMovieService = MockMovieService()
        moviesViewModel = MoviesViewModel(moviesService: mockMovieService, serviceConfiguration: MockServiceConfiguration(), flowCoordinatorFactory: MockFlowCoordinatorFactory())
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        moviesViewModel = nil
        mockMovieService = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testGetMovies() {
        let expectation = XCTestExpectation(description: "testGetMovies")
        let apiObject1 = ApiMovie(id: 123, title: "Title1", overview: "Overview1", posterPath: "PosterPath1")
        let apiObject2 = ApiMovie(id: 100, title: "Title2", overview: "Overview2", posterPath: "PosterPath2")
        let paginator = MoviesPaginator(page: 1, totalPages: 1, totalResults: 2, results: [apiObject1, apiObject2])
        mockMovieService.popularMovies = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .success(paginator))
        XCTAssertEqual(moviesViewModel.lastDownloadedPage, 0)
        moviesViewModel.dataSource.dropFirst().sink { moviesCellViewModel in
            XCTAssertEqual(moviesCellViewModel.count, 2)
            XCTAssertNotNil(moviesCellViewModel)
            XCTAssertEqual(moviesCellViewModel[0].movie.id, "123")
            XCTAssertEqual(moviesCellViewModel[0].movie.title, "Title1")
            XCTAssertEqual(moviesCellViewModel[0].movie.overView, "Overview1")
            XCTAssertEqual(moviesCellViewModel[0].movie.posterPath, "https://image.tmdb.org/t/p/original/PosterPath1")
            XCTAssertEqual(self.mockMovieService.fetchPopularMovieCounter, 1)
            XCTAssertEqual(self.moviesViewModel.lastDownloadedPage, 1)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        Task {
            await moviesViewModel.getMovies()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetMoviesError() {
        let expectation = XCTestExpectation(description: "testGetMovies")
        mockMovieService.popularMovies = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .failure(ConfigError(code: 501, message: "DataRequset is nil")))
        XCTAssertEqual(moviesViewModel.lastDownloadedPage, 0)
        moviesViewModel.dataSource.dropFirst().sink { moviesCellViewModel in
            XCTAssertEqual(moviesCellViewModel.count, 0)
            XCTAssertEqual(self.mockMovieService.fetchPopularMovieCounter, 1)
            XCTAssertEqual(self.moviesViewModel.lastDownloadedPage, 1)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        Task {
            await moviesViewModel.getMovies()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFistPageOkSecondPageWrong() {
        let expectation = XCTestExpectation(description: "testGetMovies")
        let apiObject1 = ApiMovie(id: 123, title: "Title1", overview: "Overview1", posterPath: "PosterPath1")
        let apiObject2 = ApiMovie(id: 100, title: "Title2", overview: "Overview2", posterPath: "PosterPath2")
        let paginator = MoviesPaginator(page: 1, totalPages: 1, totalResults: 2, results: [apiObject1, apiObject2])
        mockMovieService.popularMovies = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .success(paginator))
        XCTAssertEqual(moviesViewModel.lastDownloadedPage, 0)
        moviesViewModel.dataSource.collect(5).sink { moviesCellViewModel in
            let firstMovieCellViewModel = moviesCellViewModel[1]
            XCTAssertEqual(firstMovieCellViewModel.count, 2)
            XCTAssertNotNil(firstMovieCellViewModel)
            XCTAssertEqual(firstMovieCellViewModel[0].movie.id, "123")
            XCTAssertEqual(firstMovieCellViewModel[0].movie.title, "Title1")
            XCTAssertEqual(firstMovieCellViewModel[0].movie.overView, "Overview1")
            XCTAssertEqual(firstMovieCellViewModel[0].movie.posterPath, "https://image.tmdb.org/t/p/original/PosterPath1")
            
            let secondMovieCellViewModel = moviesCellViewModel[2]
            XCTAssertEqual(secondMovieCellViewModel.count, 2)
            XCTAssertNotNil(secondMovieCellViewModel)
            XCTAssertEqual(secondMovieCellViewModel[0].movie.id, "123")
            XCTAssertEqual(secondMovieCellViewModel[0].movie.title, "Title1")
            XCTAssertEqual(secondMovieCellViewModel[0].movie.overView, "Overview1")
            XCTAssertEqual(secondMovieCellViewModel[0].movie.posterPath, "https://image.tmdb.org/t/p/original/PosterPath1")
            
            let thirdMovieCellViewModel = moviesCellViewModel[4]
            XCTAssertEqual(thirdMovieCellViewModel.count, 4)
            XCTAssertNotNil(thirdMovieCellViewModel)
            XCTAssertEqual(thirdMovieCellViewModel[0].movie.id, "123")
            XCTAssertEqual(thirdMovieCellViewModel[0].movie.title, "Title1")
            XCTAssertEqual(thirdMovieCellViewModel[0].movie.overView, "Overview1")
            XCTAssertEqual(thirdMovieCellViewModel[0].movie.posterPath, "https://image.tmdb.org/t/p/original/PosterPath1")
            
            expectation.fulfill()
        }.store(in: &cancellables)
        
        Task {
            await moviesViewModel.getMovies()
            
            mockMovieService.popularMovies = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .failure(ConfigError(code: 501, message: "DataRequset is nil")))
            
            XCTAssertEqual(self.mockMovieService.fetchPopularMovieCounter, 1)
            XCTAssertEqual(self.moviesViewModel.lastDownloadedPage, 1)
            
            await moviesViewModel.getMovies()
            
            XCTAssertEqual(self.mockMovieService.fetchPopularMovieCounter, 2)
            XCTAssertEqual(self.moviesViewModel.lastDownloadedPage, 1)
            
            let apiObject3 = ApiMovie(id: 124, title: "Title3", overview: "Overview3", posterPath: "PosterPath3")
            let apiObject4 = ApiMovie(id: 101, title: "Title4", overview: "Overview4", posterPath: "PosterPath4")
            let paginator2 = MoviesPaginator(page: 1, totalPages: 1, totalResults: 2, results: [apiObject3, apiObject4])
            mockMovieService.popularMovies = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .success(paginator2))
            
            await moviesViewModel.getMovies()
            
            XCTAssertEqual(self.mockMovieService.fetchPopularMovieCounter, 3)
            XCTAssertEqual(self.moviesViewModel.lastDownloadedPage, 2)
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
}
