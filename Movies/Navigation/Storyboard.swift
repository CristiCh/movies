//
//  Storyboard.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case movies = "Main"
    case movie = "Movie"
}

extension Storyboard {
    func loadViewController<T>(_: T.Type) -> T {
        if let viewController = current.instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            return viewController
        }
        fatalError("ViewController name is different then Storyboard identifier")
    }
}

private extension Storyboard {
    var current: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
}
