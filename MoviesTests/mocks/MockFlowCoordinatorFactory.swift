//
//  MockFlowCoordinatorFactory.swift
//  MoviesTests
//
//  Created by Cristian Chertes on 27.02.2023.
//

import Foundation
@testable import Movies

class MockGeneralFlowCoordinatorProtocol: GeneralFlowCoordinatorProtocol {
    func start() {}
}

class MockFlowCoordinatorFactory: FlowCoordinatorFactory {
    override func create(type: ScreenType) -> GeneralFlowCoordinatorProtocol {
        return MockGeneralFlowCoordinatorProtocol()
    }
}
