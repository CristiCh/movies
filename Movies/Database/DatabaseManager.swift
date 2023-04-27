//
//  DatabaseManager.swift
//  Movies
//
//  Created by Cristian Chertes on 20.04.2023.
//

import RealmSwift

class DatabaseManager {
    private var database: Realm?
    private var databaseName: String = "Movies.realm"
    private var schemaVersion: UInt64 = 1
    
    init() {
        var configuration = Realm.Configuration()
        configuration.fileURL = configuration.fileURL?.deletingLastPathComponent().appendingPathComponent(databaseName)
        configuration.readOnly = false
        configuration.schemaVersion = schemaVersion
        configuration.objectTypes = [MovieDB.self]
        self.database = try? Realm(configuration: configuration)
    }
    
    func get<T: Object>(type: T.Type) -> Results<T>? {
        database?.objects(type)
    }
    
    func get<T: Object>(type: T.Type, query: ((Query<T>) -> Query<Bool>)) -> Results<T>? {
        database?.objects(type).where(query)
    }
    
    func save<S: Sequence>(objects: S) where S.Iterator.Element: Object {
        try? database?.write({
            database?.add(objects, update: .modified)
        })
    }
    
    func delete<T: Object>(type: T.Type) {
        try? database?.write({
            let results = database?.objects(type)
            if let results = results {
                database?.delete(results)
            }
        })
    }
    
    func delete<T: Object>(query: ((Query<T>) -> Query<Bool>)) {
        try? database?.write({
            let results = database?.objects(T.self).where(query)
            if let results = results {
                database?.delete(results)
            }
        })
    }
}
