//
//  MovieFlowCoordinator.swift
//  Movies
//
//  Created by Cristian Chertes on 12.01.2023.
//

import UIKit

class MovieFlowCoordinator: GeneralFlowCoordinator {
    private var viewModel: MovieViewModelProtocol
    private var movieID: String
    private let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController!, movieID: String) {
        self.viewModel = MovieViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()), serviceConfiguration: ServiceConfiguration())
        self.movieID = movieID
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let movieViewController = Storyboard.movies.loadViewController(MovieViewController.self)
        movieViewController.viewModel = viewModel
        movieViewController.loadMovieData(movieID: movieID)
        movieViewController.modalPresentationStyle = .fullScreen
        navigationController.present(movieViewController, animated: true)
    }
}
