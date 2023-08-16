//
//  FlowCoordinatorFactory.swift
//  Movies
//
//  Created by Cristian Chertes on 30.01.2023.
//

import Foundation

class FlowCoordinatorFactory {
    init() {}
    
    func create(type: ScreenType) -> GeneralFlowCoordinatorProtocol {
        switch type {
        case let .home(window, scene):
            return MoviesFlowCoordinator(window: window, scene: scene)
        case let .movieDetail(movieID, navigationController):
            return MovieFlowCoordinator(navigationController: navigationController, movieID: movieID)
        case let .login(window, scene):
            return LoginFlowCoordinator(window: window, scene: scene)
        }
    }
}
