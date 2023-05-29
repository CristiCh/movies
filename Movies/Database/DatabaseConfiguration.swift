//
//  DatabaseConfiguration.swift
//  Movies
//
//  Created by Cristian Chertes on 04.05.2023.
//

import Foundation

enum WriteType {
    case Disk
    case Memory
}

struct DatabaseConfiguration {
    var writeType: WriteType = .Disk
    var databaseName: String = "Movies.realm"
    var schemaVersion: UInt64 = 2
}
