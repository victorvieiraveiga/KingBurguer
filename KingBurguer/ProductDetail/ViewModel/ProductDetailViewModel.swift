//
//  ProductDetailViewModel.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

protocol ProductDetailViewModelDelegate {
    func viewModelDidChanged(state: ProductDetailState)
}

class ProductDetailViewModel {
    
    var delegate: ProductDetailViewModelDelegate?
    var coordinator: ProductDetailCoordinator?
    
    var state: ProductDetailState = .loading {
        didSet {
            delegate?.viewModelDidChanged(state: state)
        }
    }
    
    private let interactor: ProductDetailInteractor
    
    init(interactor: ProductDetailInteractor) {
        self.interactor = interactor
    }
    
    func fetch(id: Int) {
        self.state = .loading
        interactor.fetch(id: id) { response, error in
            DispatchQueue.main.async {
                if let errorMessage = error {
                    self.state = .error(errorMessage)
                } else if let response = response {
                    self.state = .success(response)
                }
            }
        }
    }
    
//    func goToProductDetail(id: Int) {
//        coordinator?.goToProductDetail(id: id)
//    }
    
}
