//
//  Carousel.swift
//  Movies
//
//  Created by Cristian Chertes on 25.05.2023.
//

import RealmSwift

class CarouselDB: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var movies: List<MovieDB>
    
    convenience init(id: String, movies: [MovieDB]) {
        self.init()
        self.id = id
        self.movies = List()
        
        for movie in movies {
            self.movies.append(movie)
        }
    }
}
