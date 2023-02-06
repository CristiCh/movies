//
//  MoviesService.swift
//  MVPExample
//
//  Created by Cristian Chertes on 24.11.2022.
//  Copyright © 2022 Cristis. All rights reserved.
//

import Foundation
import Alamofire

protocol MoviesServiceProtocol {
    func fetchPopularMovies(page: Int) async -> DataResponse<MoviesPaginator<ApiMovie>, Error>
    func fetchMovie(movieId: String) async -> DataResponse<ApiMovie, Error>
}

class MoviesService {
    private var baseURL: String {
        get {
            configuration.baseURL
        }
    }
    private var apiKey: String? {
        get {
            configuration.apiKey
        }
    }
    private let configuration: ServiceConfigurationProtocol
    private let sessionManager: Session
    
    init(configuration: ServiceConfigurationProtocol, protocolClass: [AnyClass]? = nil) {
        let config = URLSessionConfiguration.af.default
        config.protocolClasses = protocolClass ?? [] + (config.protocolClasses ?? [] )
        sessionManager = Session(configuration: config)
        self.configuration = configuration
    }
}

extension MoviesService: MoviesServiceProtocol {
    func fetchPopularMovies(page: Int) async -> DataResponse<MoviesPaginator<ApiMovie>, Error> {
        guard let apiKey = apiKey,
            let url = URL(string: "\(baseURL)popular?page=\(page)&api_key=\(apiKey)") else {
            return DataRequest.getDataResponseError(error: ConfigError(code: 500, message: "Wrong URL"))
        }
        return await sessionManager.request(url, method: .get).processResponse(type: MoviesPaginator<ApiMovie>.self)
    }
    
    func fetchMovie(movieId: String) async -> DataResponse<ApiMovie, Error> {
        guard let apiKey = apiKey,
            let url = URL(string: "\(baseURL)\(movieId)?api_key=\(apiKey)") else {
                 return DataRequest.getDataResponseError(error: ConfigError(code: 500, message: "Wrong URL"))
        }
        
        return await sessionManager.request(url, method: .get).processResponse(type: ApiMovie.self)
    }
}
