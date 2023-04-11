//
//  BaseMovieCellViewModel.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 Cristian Chertes. All rights reserved.
//

import Foundation

class BaseMovieCellViewModel: Identifiable {
    var id: String
    var cellIdentifier: String {
        assertionFailure("subclass must declare a cellIdentifier")
        return ""
    }

    required init(id: String) {
        self.id = id
    }
}

extension BaseMovieCellViewModel: Hashable {
    static func == (lhs: BaseMovieCellViewModel, rhs: BaseMovieCellViewModel) -> Bool {
        lhs.id ==  rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
