//
//  MovieCellViewModel.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 Cristian Chertes. All rights reserved.
//

import Foundation
import Combine

protocol MovieCellViewModelProtocol {
    var movie: Movie { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
}

class MoviesCellViewModel: BaseMovieCellViewModel, MovieCellViewModelProtocol {
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var title: String {
        movie.title
    }
    var posterPath: String? {
        movie.posterPath
    }
    
    internal let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(id: UUID().uuidString)
    }
    
    override var cellIdentifier: String {
        return MovieCollectionCell.identifier
    }
    
    required init(id: String) {
        fatalError("init(id:) has not been implemented")
    }
}
