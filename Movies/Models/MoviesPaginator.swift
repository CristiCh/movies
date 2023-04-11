//
//  MoviesPaginator.swift
//  MVPExample
//
//  Created by Cristian Chertes on 01.12.2022.
//  Copyright © 2022 Cristian Chertes. All rights reserved.
//

import Foundation

struct MoviesPaginator<T: Codable>: Codable {
    var page: Int
    var totalPages: Int
    var totalResults: Int
    var results: [T]
    
    private enum CodingKeys : String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}
