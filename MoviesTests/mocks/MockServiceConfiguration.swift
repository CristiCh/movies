//
//  MockServiceConfiguration.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 06.02.2023.
//

import Foundation

@testable import Movies

class MockServiceConfiguration: ServiceConfigurationProtocol {
    let apiKey: String? = "apiKey"
    let baseURL: String = "https://api.mock/"
    let imagesURL: String = "https://image.tmdb.org/t/p/original/"
    let logLevel: NetworkLogger.LogLevel = .none
}
