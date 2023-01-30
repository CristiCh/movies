//
//  GeneralFlowCoordinator.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 saadeloulladi. All rights reserved.
//

import UIKit

protocol GeneralFlowCoordinatorProtocol {
    func start()
}

class GeneralFlowCoordinator: GeneralFlowCoordinatorProtocol {
    internal init() {}
    
    func start() {
        assert(false, "Override")
    }
}
