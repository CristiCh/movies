//
//  MovieCollectionCell.swift
//  Movies
//
//  Created by Cristian Chertes on 15.12.2022.
//

import UIKit
import Kingfisher

class MovieCollectionCell: BaseMovieCollectionCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    override var viewModel: BaseMovieCellViewModel! {
        didSet {
            setupLayout()
        }
    }
    
    var movieViewModel: MoviesCellViewModel! {
        viewModel as? MoviesCellViewModel
    }
    
    private func setupLayout() {
        self.widthConstraint.constant = 220.0
        imageView.layer.masksToBounds = true
        
        if let movieImageString = movieViewModel.posterPath, let movieImageURL = URL(string: movieImageString)  {
            imageView.kf.setImage(with: Source.network(ImageResource(downloadURL: movieImageURL))) { [weak self] result in
            }
        }
        titleLabel.text = movieViewModel.movie.title
    }
}
