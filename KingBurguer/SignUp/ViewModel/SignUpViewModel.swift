//
//  SignUpViewModel.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 10/05/24.
//

import Foundation

protocol SignUpViewModelDelegate {
    func viewModelDidChanged(state: SignUpState)
}

class SignUpViewModel {
    var name = "Victor"
    var email = "hahaha@jjjj.com"
    var document = "12345678910"
    var password = "12345678"
    var birthday = "2019-08-24"
    
    var delegate: SignUpViewModelDelegate?
    var coordinator: SignUpCoordinator?
   
    var state: SignUpState = .none {
        didSet {
            delegate?.viewModelDidChanged(state: state)
        }
    }
    
    private let interactor: SignUpInteractor
    init(interactor: SignUpInteractor) {
        self.interactor = interactor
    }
    
    func send() {
        state = .loading
        
        let dtString = DateFormatter()
        dtString.locale = Locale(identifier: "en_US_POSIX")
        dtString.dateFormat = "dd/MM/yyyy"
        
        let date = dtString.date(from: birthday) ?? Date()
        
        let dtDate = DateFormatter()
        dtDate.locale = Locale(identifier: "en_US_POSIX")
        dtDate.dateFormat = "yyyy-MM-dd"
        let birthdayFormated = dtDate.string(from: date)
       
        let documentFormated = document.digits
        
        let request = SignUpRequest(name: name, email: email, password: password, document: documentFormated, birthday: birthdayFormated)
        
        SignUpRemoteDataSource.shared.createUser(request: SignUpRequest(
            name: name,
            email: email,
            password: password,
            document: documentFormated,
            birthday: birthdayFormated)) { created, error in
                
                DispatchQueue.main.async{
                    if let errorMessage = error {
                        self.state = .error(errorMessage)
                    } else if let created = created {
                        self.state = .goToLogin
                    }
                }
            }
    }
    
    func goToLogin() {
        coordinator?.login()
    }
}

