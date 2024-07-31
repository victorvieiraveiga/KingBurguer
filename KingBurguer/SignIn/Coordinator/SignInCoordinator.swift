//
//  SignInCoordinator.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 03/05/24.
//

import Foundation
import UIKit

class SignInCoordinator {
    
    private let window: UIWindow?
    private let navigationController: UINavigationController
    
    init(window: UIWindow?) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let interactor = SignInInteractor()
        let viewModel = SignInViewModel(interactor: interactor)
        viewModel.coordinator = self
        
        let signInVC = SignInViewController()
        signInVC.viewModel = viewModel
    
        navigationController.pushViewController(signInVC, animated: true)
        
        window?.rootViewController = navigationController
    }
    
    func signUp() {
        let signUpCoordinator = SignUpCoordinator(navigatioController: navigationController)
        signUpCoordinator.coordinator = self
        
        signUpCoordinator.start()
    }
    
    func home() {
        let homeCoordinator = HomeCoordinator(window: window)
        homeCoordinator.start()
    }
}
