//
//  ServerError.swift
//  Movies
//
//  Created by Cristian Chertes on 30.01.2023.
//

import Foundation

struct ServerError: Codable, Error {
    var status: String
    var message: String
}
