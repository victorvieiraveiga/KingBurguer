//
//  ProductDetailCoordinator.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

import UIKit

class ProductDetailCoordinator {
    
    private let navigationController: UINavigationController
    private let id: Int
    
    var parentCoordinator: FeedCoordinator?
    
    init(_ navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.id = id
    }
    
    func start() {
        let interactor = ProductDetailInteractor()
        
        let viewModel = ProductDetailViewModel(interactor: interactor)
        viewModel.coordinator = self
        
        let vc = ProductDetailViewController()
        vc.id = id
        vc.viewModel = viewModel
        
        navigationController.pushViewController(vc, animated: true)
    }
    
//    func login() {
//        navigationController.popViewController(animated: true)
//    }
    
}
