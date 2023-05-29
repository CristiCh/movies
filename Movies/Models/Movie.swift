//
//  Movie.swift
//  MVPExample
//
//  Created by Cristian Chertes on 24.11.2022.
//  Copyright © 2022 Cristis. All rights reserved.
//

import Foundation

struct Movie: Identifiable {
    var id: String
    var imdbId: String?
    var title: String
    var overView: String
    var posterPath: String?
    
    static func transform(movie: ApiMovie, configuration: ServiceConfigurationProtocol) -> Movie? {
        var image: String? = nil
        if let posterPath = movie.posterPath {
            image = "\(configuration.imagesURL)\(posterPath)"
        }
        
        return Movie(id: "\(movie.id)", title: movie.title, overView: movie.overview, posterPath: image)
    }
    
    static func transform(movie: MovieDB) -> Movie? {
        Movie(id: "\(movie.id)", imdbId: nil, title: movie.title, overView: movie.overView, posterPath: movie.posterPath)
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
