//
//  SceneDelegate.swift
//  Movies
//
//  Created by Cristian Chertes on 12.12.2022.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let flowCoordinator = FlowCoordinatorFactory().create(type: .home(window: window, scene: scene)) as! MoviesFlowCoordinator
        flowCoordinator.start()
        window = flowCoordinator.window
        window?.makeKeyAndVisible()
    }
}
