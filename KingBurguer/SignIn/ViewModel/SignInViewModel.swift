//
//  SignInViewModel.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 03/05/24.
//

import Foundation

protocol SignInViewModelDelegate {
    func viewModelDidChanged(state: SignInState)
}

class SignInViewModel {
    var email = ""
    var password = ""
    
    var delegate: SignInViewModelDelegate?
    var coordinator: SignInCoordinator?
    
    private let interactor: SignInInteractor

    init(interactor: SignInInteractor) {
        self.interactor = interactor
    }
   
    var state: SignInState = .none {
        didSet {
            delegate?.viewModelDidChanged(state: state)
        }
    }
    
//    func send() {
//        state = .loading
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.state = .goToHome
//        }
//    }
    
    func goToSignUp() {
        coordinator?.signUp()
    }
    
    func goToHome() {
        coordinator?.home()
    }
    
    func login(userName: String, password: String) {
        state = .loading
        let request = SignInRequest(username: userName, password: password)
        
        interactor.login(request: request) { response, error in
            DispatchQueue.main.async {
                if let errorMessage = error {
                    self.state = .error(errorMessage)
                } else {
                    print(response)
                    self.state = .goToHome
                }
            }
        }
    }
}
