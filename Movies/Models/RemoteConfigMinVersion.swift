//
//  RemoteConfigMinVersion.swift
//  Movies
//
//  Created by Cristian Chertes on 03.07.2023.
//

import Foundation

struct RemoteConfigMinVersion: Codable {
    let version: String
    let build: Int
    let appStoreURL: String
}
