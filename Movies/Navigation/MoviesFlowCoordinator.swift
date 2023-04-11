//
//  MoviesFlowCoordinator.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 Cristian Chertes. All rights reserved.
//

import UIKit
import SwiftUI

class MoviesFlowCoordinator: GeneralFlowCoordinator {
    private var viewModel: MoviesViewModelProtocol
    var window: UIWindow?
    private let scene: UIScene?
    
    required init(window: UIWindow?, scene: UIScene?) {
        self.viewModel = MoviesViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()),
                                         serviceConfiguration: ServiceConfiguration(),
                                         flowCoordinatorFactory: FlowCoordinatorFactory())
        self.window = window
        self.scene = scene
        super.init()
    }
    
    override func start() {
        let contentView = MoviesView(viewModel: MoviesViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()),
                                                                serviceConfiguration: ServiceConfiguration(),
                                                                flowCoordinatorFactory: FlowCoordinatorFactory()))
        if let widowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: widowScene)
            window.rootViewController = UIHostingController(rootView: contentView)

            self.window = window
//            self.window?.makeKeyAndVisible()
        }
//        let viewController = Storyboard.movies.loadViewController(MoviesViewController.self)
//        viewController.viewModel = viewModel
//        viewController.modalPresentationStyle = .fullScreen
//        window.rootViewController?.present(viewController, animated: true)
//        let moviesView = UIHostingController(rootView: MoviesView(viewModel: self.viewModel as! MoviesViewModel))
//        moviesView.modalPresentationStyle = .fullScreen
//        window.rootViewController?.present(moviesView, animated: true)
    }
}
