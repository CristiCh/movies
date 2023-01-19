//
//  GeneralFlowCoordinator.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
//

import UIKit

protocol GeneralFlowCoordinatorProtocol {
    func start()
}

enum ScreenType {
    case home(window: UIWindow)
    case movieDetail(movieID: String, navigationController: UINavigationController)
}

class FlowCoordinatorFactory {
    init() {}
    
    func create(type: ScreenType) -> GeneralFlowCoordinatorProtocol {
        switch type {
        case let .home(window):
            return MoviesFlowCoordinator(window: window)
        case let .movieDetail(movieID, navigationController):
            return MovieFlowCoordinator(navigationController: navigationController, movieID: movieID)
        }
    }
}

class GeneralFlowCoordinator: GeneralFlowCoordinatorProtocol {
    internal init() {}
    
    func start() {
        assert(false, "Override")
    }
}
