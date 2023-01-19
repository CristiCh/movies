//
//  MovieFlowCoordinator.swift
//  Movies
//
//  Created by Cristian Chertes on 12.01.2023.
//

import UIKit
import Combine

class MovieFlowCoordinator: GeneralFlowCoordinator {
    private var viewModel: MovieViewModelProtocol
    private var movieID: String
    private var cancellables = Set<AnyCancellable>()
    private let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController!, movieID: String) {
        self.viewModel = MovieViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()), serviceConfiguration: ServiceConfiguration())
        self.movieID = movieID
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let movieViewController = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController else {
            return
        }
        movieViewController.viewModel = viewModel
        movieViewController.loadMovieData(movieID: movieID)
        movieViewController.modalPresentationStyle = .fullScreen
        navigationController.present(movieViewController, animated: true)
    }
}
