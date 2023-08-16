//
//  UIWindowExtension.swift
//  Movies
//
//  Created by Cristian Chertes on 31.07.2023.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        UIApplication.shared.windows.first() { $0.isKeyWindow }
    }
    
    static func getTopMostViewController() -> UIViewController? {
        var topMostViewController = self.key?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
}
