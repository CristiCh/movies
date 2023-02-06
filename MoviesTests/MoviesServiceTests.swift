//
//  MoviesServiceTests.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 06.02.2023.
//

import XCTest
import Mocker
@testable import Movies

final class MoviesServiceTests: XCTestCase {
    func testFetchPopularMoviesOK() {
        let moviesService = MoviesService(configuration: MockServiceConfiguration(), protocolClass: [MockingURLProtocol.self])
        MockerMock.mockMoviesList()
        let expectation = XCTestExpectation(description: "popularMovies")
        Task {
            let movies = await moviesService.fetchPopularMovies(page: 1)
            let result = try! movies.result.get()
            XCTAssertEqual(result.results.count, 20)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
