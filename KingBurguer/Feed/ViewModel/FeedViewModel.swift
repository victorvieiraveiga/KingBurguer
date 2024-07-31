//
//  FeedViewModel.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

protocol FeedViewModelDelegate {
    func viewModelDidChanged(state: FeedState)
}

class FeedViewModel {
    
    var delegate: FeedViewModelDelegate?
    var coordinator: FeedCoordinator?
    
    var state: FeedState = .loading {
        didSet {
            delegate?.viewModelDidChanged(state: state)
        }
    }
    
    private let interactor: FeedInteractor
    
    init(interactor: FeedInteractor) {
        self.interactor = interactor
    }
    
    func fetch() {
        interactor.fetch() { response, error in
            DispatchQueue.main.async {
                if let errorMessage = error {
                    self.state = .error(errorMessage)
                } else if let response = response {
                    self.state = .success(response)
                }
            }
        }
    }
    
    func fetchHighlight() {
        interactor.fetchHighlight() { response, error in
            DispatchQueue.main.async {
                if let errorMessage = error {
                    self.state = .error(errorMessage)
                } else if let response = response {
                    self.state = .successHighlight(response)
                }
            }
        }
    }
    
    func goToProductDetail(productId: Int) {
        coordinator?.goToProductDetail(id: productId)
    }
    
//    func goToSignUp() {
//        coordinator?.signUp()
//    }
//
//    func goToHome() {
//        coordinator?.home()
//    }
    
}
