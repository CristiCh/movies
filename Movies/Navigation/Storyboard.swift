//
//  Storyboard.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 Cristian Chertes. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case movies = "Main"
}

extension Storyboard {
    func loadViewController<T>(_: T.Type) -> T {
        if let viewController = current.instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            return viewController
        }
        fatalError("ViewController name is different then Storyboard identifier")
    }
}

extension Storyboard {
    var current: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
}
