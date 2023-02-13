//
//  MoviesServiceTests.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 06.02.2023.
//

import XCTest
import Mocker
import Alamofire
@testable import Movies

final class MoviesServiceTests: XCTestCase {
    var moviesService: MoviesService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        moviesService = MoviesService(configuration: MockServiceConfiguration(), protocolClass: [MockingURLProtocol.self])
    }

    override func tearDownWithError() throws {
        moviesService = nil
        try super.tearDownWithError()
    }
    
    func testFetchPopularMoviesOK() {
        MockerMock.mockMoviesList()
        let expectation = XCTestExpectation(description: "popularMovies")
        Task {
            let movies = await moviesService.fetchPopularMovies(page: 1)
            let result = try! movies.result.get()
            XCTAssertEqual(result.results.count, 20)
            
            let firstItem = result.results.first as! ApiMovie
            XCTAssertEqual(firstItem.id, 505642)
            XCTAssertEqual(firstItem.language, "en")
            XCTAssertEqual(movies.request?.method, HTTPMethod.get)
            XCTAssertEqual(movies.response?.statusCode, 200)
            XCTAssertEqual(firstItem.title, "Black Panther: Wakanda Forever")
            XCTAssertEqual(firstItem.posterPath, "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg")
            XCTAssertEqual(firstItem.overview, "Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death.  As the Wakandans strive to embrace their next chapter, the heroes must band together with the help of War Dog Nakia and Everett Ross and forge a new path for the kingdom of Wakanda.")
            
            let lastItem = result.results.last as! ApiMovie
            XCTAssertEqual(lastItem.id, 899579)
            XCTAssertNil(lastItem.language)
            XCTAssertEqual(lastItem.title, "There's Something Wrong with the Children")
            XCTAssertEqual(lastItem.posterPath, "/e49Sr3Lxfk2psYhv1SzQjs7MeGo.jpg")
            XCTAssertEqual(lastItem.overview, "Margaret and Ben take a weekend trip with longtime friends Ellie and Thomas and their two young children. Eventually, Ben begins to suspect something supernatural is occurring when the kids behave strangely after disappearing into the woods overnight.")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchPopularMoviesWrong() {
        MockerMock.mockMoviesListWrong()
        let expectation = XCTestExpectation(description: "popularMovies")
        Task {
            let movies = await moviesService.fetchPopularMovies(page: 1)
            XCTAssertEqual(movies.response?.statusCode, 500)
            XCTAssertEqual(movies.request?.method, HTTPMethod.get)
            var exception: Error? = nil
            do {
                let result = try movies.result.get()
            } catch let error {
                exception = error
            }
            XCTAssertNotNil(exception)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMovieDetailsOK() {
        MockerMock.mockMovieDetails()
        let expectation = XCTestExpectation(description: "movieDetails")
        Task {
            let movies = await moviesService.fetchMovie(movieId: "123")
            let result = try! movies.result.get()
            let firstItem = result as! ApiMovie
            XCTAssertEqual(firstItem.id, 505642)
            XCTAssertEqual(firstItem.language, "en")
            XCTAssertEqual(movies.request?.method, HTTPMethod.get)
            XCTAssertEqual(movies.response?.statusCode, 200)
            XCTAssertEqual(firstItem.title, "Black Panther: Wakanda Forever")
            XCTAssertEqual(firstItem.posterPath, "/sv1xJUazXeYqALzczSZ3O6nkH75.jpg")
            XCTAssertEqual(firstItem.overview, "Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death.  As the Wakandans strive to embrace their next chapter, the heroes must band together with the help of War Dog Nakia and Everett Ross and forge a new path for the kingdom of Wakanda.")
                        
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMovieDetailsWrong() {
        MockerMock.mockMovieDetailsWrong()
        let expectation = XCTestExpectation(description: "movieDetails")
        Task {
            let movies = await moviesService.fetchMovie(movieId: "123")
            XCTAssertEqual(movies.response?.statusCode, 500)
            XCTAssertEqual(movies.request?.method, HTTPMethod.get)
            var exception: Error? = nil
            do {
                let result = try movies.result.get()
            } catch let error {
                exception = error
            }
            XCTAssertNotNil(exception)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
