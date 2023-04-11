//
//  ServiceConfiguration.swift
//  MVPExample
//
//  Created by Cristian Chertes on 24.11.2022.
//  Copyright © 2022 Cristian Chertes. All rights reserved.
//

import Foundation

protocol ServiceConfigurationProtocol {
    var apiKey: String? { get }
    var baseURL: String { get }
    var imagesURL: String { get }
}

class ServiceConfiguration: ServiceConfigurationProtocol {
    let apiKey: String? = Bundle.main.infoDictionary?["API_KEY"] as? String
    let baseURL: String = "https://api.themoviedb.org/3/movie/"
    let imagesURL: String = "https://image.tmdb.org/t/p/original/"
}
