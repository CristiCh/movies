//
//  UICollectionViewCell+Utils.swift
//  Movies
//
//  Created by Cristian Chertes on 15.12.2022.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func register(to collectionView: UICollectionView) {
        let nibFile = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibFile, forCellWithReuseIdentifier: identifier)
    }
}
