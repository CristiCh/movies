//
//  ApiMovie.swift
//  MVPExample
//
//  Created by Cristian Chertes on 24.11.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
//

import Foundation

struct ApiMovie: Codable {
    var id: Int64
    var title: String
    var overview: String
    var posterPath: String
    var language: String?
    
    private enum CodingKeys : String, CodingKey {
        case id
        case title = "original_title"
        case overview
        case posterPath = "poster_path"
        case language = "original_language"
    }
}
