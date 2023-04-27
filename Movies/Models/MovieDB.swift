//
//  MovieDB.swift
//  Movies
//
//  Created by Cristian Chertes on 20.04.2023.
//

import RealmSwift

class MovieDB: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imdbId: String?
    @Persisted var title: String
    @Persisted var overView: String
    @Persisted var posterPath: String?
    
    convenience init(id: String, imdbId: String?, title: String, overView: String, posterPath: String?) {
        self.init()
        self.id = id
        self.imdbId = imdbId
        self.title = title
        self.overView = overView
        self.posterPath = posterPath
    }
    
    static func transform(movie: ApiMovie, configuration: ServiceConfigurationProtocol) -> MovieDB? {
        MovieDB(id: "\(movie.id)", imdbId: nil, title: movie.title, overView: movie.overview, posterPath: "\(configuration.imagesURL)\(movie.posterPath)")
    }
}

