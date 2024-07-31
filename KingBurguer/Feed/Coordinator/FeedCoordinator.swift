//
//  FeedCoordinator.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation
import UIKit

class FeedCoordinator {
    private let navigationController: UINavigationController
    
    var parentCoordinator: HomeCoordinator?
    
    init(_ navigatioController: UINavigationController) {
        self.navigationController = navigatioController
    }
    
    func start() {
        let interactor = FeedInteractor()
        
        let viewModel = FeedViewModel(interactor: interactor)
        viewModel.coordinator = self
        
        
        let signUp = FeedViewController()
        signUp.viewModel = viewModel
        
        navigationController.pushViewController(signUp, animated: true)
    }
    
    func goToProductDetail(id: Int) {
        let coordinator = ProductDetailCoordinator(navigationController, id: id)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
