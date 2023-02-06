//
//  MockerMock.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 06.02.2023.
//

import Foundation
import Mocker

class MockerMock {
    static func mockMoviesList() {
        let url = URL(string: "https://api.mock/popular?page=1&api_key=apiKey")!
        let mock = Mock(url: url, dataType: Mock.DataType.json, statusCode: 200, data: [.get : MockData.getMoviesJSON()])
        Mocker.register(mock)
    }
}
