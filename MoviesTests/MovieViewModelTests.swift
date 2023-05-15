//
//  MovieViewModelTests.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 20.02.2023.
//

import XCTest
import Mocker
import Alamofire
import Combine
@testable import Movies

final class MovieViewModelTests: XCTestCase {
    var movieViewModel: MovieViewModel!
    var mockMovieService: MockMovieService!
    var databaseName: String {
        get {
            "\(Double.random(in: 0.0...100.0))_\(Date().timeIntervalSince1970)).realm"
        }
    }
    var databaseConfiguration: DatabaseConfiguration!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockMovieService = MockMovieService()
        databaseConfiguration = DatabaseConfiguration(writeType: WriteType.Memory, databaseName: databaseName)
        movieViewModel = MovieViewModel(moviesService: mockMovieService, serviceConfiguration: MockServiceConfiguration(), databaseManager: DatabaseManager(configuration: databaseConfiguration))
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        movieViewModel = nil
        mockMovieService = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testLoadMovieData() {
        let expectation = XCTestExpectation(description: "loadMovieData")
        let apiObject = ApiMovie(id: 123, title: "Title", overview: "Overview", posterPath: "PosterPath")
        mockMovieService.movie = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .success(apiObject))
        XCTAssertEqual(mockMovieService.fetchMovieCounter, 0)
        movieViewModel.$movie.dropFirst().sink { movie in
            XCTAssertNotNil(movie)
            XCTAssertEqual(movie?.id, "123")
            XCTAssertEqual(movie?.title, "Title")
            XCTAssertEqual(movie?.overView, "Overview")
            XCTAssertEqual(movie?.posterPath, "https://image.tmdb.org/t/p/original/PosterPath")
            XCTAssertEqual(self.mockMovieService.fetchMovieCounter, 1)
            XCTAssertEqual(self.mockMovieService.fetchMovieID, "123")
            expectation.fulfill()
        }.store(in: &cancellables)
        movieViewModel.loadMovieData(movieID: "123")

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadMovieDataWrong() {
        let expectation = XCTestExpectation(description: "loadMovieDataWrong")
        mockMovieService.movie = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .failure(ConfigError(code: 501, message: "DataRequset is nil")))
        XCTAssertEqual(mockMovieService.fetchMovieCounter, 0)
        movieViewModel.$movie.dropFirst().sink { movie in
            XCTAssertNil(movie)
            XCTAssertEqual(self.mockMovieService.fetchMovieCounter, 1)
            XCTAssertEqual(self.mockMovieService.fetchMovieID, "123")
            expectation.fulfill()
        }.store(in: &cancellables)
        movieViewModel.loadMovieData(movieID: "123")

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testIsLoading() {
        let expectation = XCTestExpectation(description: "isLoading")
        let apiObject = ApiMovie(id: 123, title: "Title", overview: "Overview", posterPath: "PosterPath")
        mockMovieService.movie = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .success(apiObject))
        XCTAssertEqual(mockMovieService.fetchMovieCounter, 0)
        XCTAssertEqual(movieViewModel.isLoading, false)
        movieViewModel.$isLoading.collect(3).sink { isLoading in
            XCTAssertEqual(isLoading[0], false)
            XCTAssertEqual(isLoading[1], true)
            XCTAssertEqual(isLoading[2], false)
            expectation.fulfill()
        }.store(in: &cancellables)
        movieViewModel.loadMovieData(movieID: "123")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testIsLoadingWrong() {
        let expectation = XCTestExpectation(description: "isLoadingWrong")
        mockMovieService.movie = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .failure(ConfigError(code: 501, message: "DataRequset is nil")))
        XCTAssertEqual(mockMovieService.fetchMovieCounter, 0)
        XCTAssertEqual(movieViewModel.isLoading, false)
        movieViewModel.$isLoading.collect(3).sink { isLoading in
            XCTAssertEqual(isLoading[0], false)
            XCTAssertEqual(isLoading[1], true)
            XCTAssertEqual(isLoading[2], false)
            expectation.fulfill()
        }.store(in: &cancellables)
        movieViewModel.loadMovieData(movieID: "123")

        wait(for: [expectation], timeout: 1.0)
    }
}
