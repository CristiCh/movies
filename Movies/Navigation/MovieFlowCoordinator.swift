//
//  MovieFlowCoordinator.swift
//  Movies
//
//  Created by Cristian Chertes on 12.01.2023.
//

import UIKit
import SwiftUI

class MovieFlowCoordinator: GeneralFlowCoordinator {
    private var viewModel: MovieViewModelProtocol
    private var movieID: String
    private let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController!, movieID: String) {
        self.viewModel = MovieViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()), serviceConfiguration: ServiceConfiguration(), databaseManager: DatabaseManager(configuration: DatabaseConfiguration()))
        self.movieID = movieID
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let movieView = UIHostingController(rootView: MovieView(viewModel: self.viewModel as! MovieViewModel, movieID: movieID))
        movieView.modalPresentationStyle = .fullScreen
        navigationController.present(movieView, animated: true)
    }
}
