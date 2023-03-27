//
//  ScreenType.swift
//  Movies
//
//  Created by Cristian Chertes on 30.01.2023.
//

import UIKit

enum ScreenType {
    case home(window: UIWindow?, scene: UIScene?)
    case movieDetail(movieID: String, navigationController: UINavigationController)
}
