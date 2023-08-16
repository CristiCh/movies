//
//  LoginFlowCoordinator.swift
//  Movies
//
//  Created by Cristian Chertes on 20.07.2023.
//

import UIKit
import SwiftUI

class LoginFlowCoordinator: GeneralFlowCoordinator {
    private var viewModel: LoginViewModel
    var window: UIWindow?
    private let scene: UIScene?
    
    required init(window: UIWindow?, scene: UIScene?) {
        self.viewModel = LoginViewModel()
        self.window = window
        self.scene = scene
        super.init()
    }
    
    override func start() {
        let contentView = LoginView(viewModel: self.viewModel)
        if let widowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: widowScene)
            window.rootViewController = UIHostingController(rootView: contentView)

            self.window = window
        }
    }
}
