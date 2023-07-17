//
//  CodableExtension.swift
//  Movies
//
//  Created by Cristian Chertes on 03.07.2023.
//

import Foundation

extension Decodable {
    static func build<T: Codable>(data: String?, type: T.Type) -> T? {
        guard let data = data, let data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        
        return decodeData(data:data,type:type)
    }
    
    static func decodeData<T: Codable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
