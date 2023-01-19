//
//  MoviesPaginator.swift
//  MVPExample
//
//  Created by Cristian Chertes on 01.12.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
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
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        page = try values.decode(Int.self, forKey: .page)
//        totalPages = try values.decode(Int.self, forKey: .totalPages)
//        totalResults = try values.decode(Int.self, forKey: .totalResults)
//        results = try values.decode(T.self, forKey: .results) as! [T]
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(page, forKey: .page)
//        try container.encode(totalPages, forKey: .totalPages)
//        try container.encode(totalResults, forKey: .totalResults)
//    }
}
