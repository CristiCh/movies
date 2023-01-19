//
//  SplashScreen.swift
//  Movies
//
//  Created by Cristian Chertes on 16.01.2023.
//

import UIKit

class SplashScreen: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let window = UIWindow(frame: UIScreen.main.bounds)
        FlowCoordinatorFactory().create(type: .home(window: window)).start()
    }
}
