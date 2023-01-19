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
        Movie(id: "\(movie.id)", title: movie.title, overView: movie.overview, posterPath: "\(configuration.imagesURL)\(movie.posterPath)")
    }
}
