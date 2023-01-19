//
//  MovieTableViewCell.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
//

import UIKit
import Combine

class MovieTableViewCell: BaseMovieCell {
    @IBOutlet weak var movieImageView: UIImageView!
    private var cancellables = Set<AnyCancellable>()
    override var viewModel: BaseMovieCellViewModel! {
        didSet {
            setupUI()
            bindViewModel()
        }
    }
    var movieCellViewModel: MovieCellViewModelProtocol! {
        viewModel as? MovieCellViewModelProtocol
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

private extension MovieTableViewCell {
    func setupUI() {
//        movieImageView.image = movieCellViewModel.movie.posterPath
    }
    
    func bindViewModel() {
//        movieCellViewModel.
    }
}
