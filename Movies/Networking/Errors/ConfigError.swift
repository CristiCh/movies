//
//  ConfigError.swift
//  Movies
//
//  Created by Cristian Chertes on 30.01.2023.
//

import Foundation

struct ConfigError: Error {
    var code: Int
    var message: String
}
