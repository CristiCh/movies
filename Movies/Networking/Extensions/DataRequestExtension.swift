//
//  DataRequestExtension.swift
//  Movies
//
//  Created by Cristian Chertes on 30.01.2023.
//

import Foundation
import Alamofire

extension DataRequest {
    static func getDataResponseError<T: Codable>(error: Error, response: DataResponse<T, AFError>? = nil) -> DataResponse<T, Error> {
        return DataResponse(request: response?.request, response: response?.response, data: nil, metrics: nil, serializationDuration: 0, result: .failure(error))
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
                        continuation.resume(returning: DataResponse(request: response.request, response: response.response, data: nil, metrics: nil, serializationDuration: 0, result: .success(value)))
                    } else {
                        continuation.resume(returning: DataRequest.getDataResponseError(error: ConfigError(code: 502, message: "Malformed JSON")))
                    }
                } else {
                    continuation.resume(returning: DataRequest.getDataResponseError(error: response.error!, response: response))
                }
            }
        })
    }
}
