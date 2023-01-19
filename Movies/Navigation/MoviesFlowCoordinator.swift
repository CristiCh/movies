//
//  MoviesFlowCoordinator.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
//

import UIKit
import Combine

class MoviesFlowCoordinator: GeneralFlowCoordinator {
    private var viewModel: MoviesViewModelProtocol
    private let window: UIWindow
    private var cancellables = Set<AnyCancellable>()
    
    required init(window: UIWindow) {
        self.viewModel = MoviesViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()),
                                         serviceConfiguration: ServiceConfiguration(),
                                         flowCoordinatorFactory: FlowCoordinatorFactory())
        self.window = window
        super.init()
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as? MoviesViewController else {
            return
        }
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        window.rootViewController?.present(viewController, animated: true)
//        window.makeKeyAndVisible()
    }
}
