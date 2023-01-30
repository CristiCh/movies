//
//  MoviesViewModel+DataSource.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
//

import Foundation
import UIKit

struct MoviesSection {
    enum SectionIdentifier {
        case main
    }
    
    let identifier: SectionIdentifier
    let cells: [BaseMovieCellViewModel]
}

class MoviesViewModelDataSource: UICollectionViewDiffableDataSource<MoviesSection.SectionIdentifier, BaseMovieCellViewModel> {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, cellViewModel in
            let cellID = cellViewModel.cellIdentifier
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                                for: indexPath) as? BaseMovieCollectionCell else {
                assertionFailure("wrong cell type")
                return UICollectionViewCell()
            }
            cell.viewModel = cellViewModel
            return cell
        }
    }
}
