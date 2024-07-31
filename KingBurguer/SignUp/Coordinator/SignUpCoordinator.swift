//
//  SignUpCoordinator.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 03/05/24.
//

import Foundation
import UIKit

class SignUpCoordinator {
    private let navigationController: UINavigationController
    
    var coordinator: SignInCoordinator?
    
    init(navigatioController: UINavigationController) {
        self.navigationController = navigatioController
    }
    
    func start() {
        let interactor = SignUpInteractor()
        let viewModel = SignUpViewModel(interactor: interactor)
        viewModel.coordinator = self
        
        
        let signUp = SignUpViewController()
        signUp.viewModel = viewModel
        
        navigationController.pushViewController(signUp, animated: true)
    }
    
    func login() {
        navigationController.popViewController(animated: true)
    }
}
