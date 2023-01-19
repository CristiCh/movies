//
//  MoviesService.swift
//  MVPExample
//
//  Created by Cristian Chertes on 24.11.2022.
//  Copyright © 2022 Cristis. All rights reserved.
//

import Foundation
import Alamofire

struct ApiRestError: Error {
  let error: Error
  let serverError: ServerError?
}

struct ServerError: Codable, Error {
    var status: String
    var message: String
}

struct ConfigError: Error {
    var code: Int
    var message: String
}

protocol MoviesServiceProtocol {
    func fetchPopularMovies(page: Int) async -> DataResponse<MoviesPaginator<ApiMovie>, Error>
    func fetchMovie(movieId: String) async -> DataResponse<ApiMovie, Error>
}

class MoviesService {
    private let baseURL: String
    private let apiKey: String?
    private let configuration: ServiceConfiguration
    
    init(configuration: ServiceConfiguration) {
        self.configuration = configuration
        self.baseURL = configuration.baseURL
        self.apiKey = configuration.apiKey
    }
}

extension MoviesService: MoviesServiceProtocol {
    func fetchPopularMovies(page: Int) async -> DataResponse<MoviesPaginator<ApiMovie>, Error> {
        guard let apiKey = apiKey,
            let url = URL(string: "\(baseURL)popular?page=\(page)&api_key=\(apiKey)") else {
            return DataRequest.getDataResponseError(error: ConfigError(code: 500, message: "Wrong URL"))
        }
        return await AF.request(url, method: .get).processResponse(type: MoviesPaginator<ApiMovie>.self)
    }
    
    func fetchMovie(movieId: String) async -> DataResponse<ApiMovie, Error> {
        guard let apiKey = apiKey,
            let url = URL(string: "\(baseURL)\(movieId)?api_key=\(apiKey)") else {
                 return DataRequest.getDataResponseError(error: ConfigError(code: 500, message: "Wrong URL"))
        }
        
        return await AF.request(url, method: .get).processResponse(type: ApiMovie.self)
    }
}

extension DataRequest {
    static func getDataResponseError<T: Codable>(error: Error) -> DataResponse<T, Error> {
        return DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .failure(error))
    }

    func processResponse<T: Codable>(type: T.Type) async -> DataResponse<T, Error> {
        return await withCheckedContinuation({ [weak self] continuation in
            guard let self = self else {
                continuation.resume(returning: DataRequest.getDataResponseError(error: ConfigError(code: 501, message: "DataRequset is nil")))
                return
            }
            self.responseDecodable(of: type) { response in
                if response.error == nil {
                    if let value = response.value {
                        continuation.resume(returning: DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: .success(value)))
                    } else {
                        continuation.resume(returning: DataRequest.getDataResponseError(error: ConfigError(code: 502, message: "Malformed JSON")))
                    }
                } else {
                    continuation.resume(returning: DataRequest.getDataResponseError(error: response.error!))
                }
            }
        })
    }
}
