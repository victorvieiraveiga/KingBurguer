//
//  HomeViewModel.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 10/05/24.
//

import Foundation

protocol HomeViewModelDelegate {
    func viewModelDidChanged(state: SignInState)
}

class HomeViewModel {
    
    var delegate: HomeViewModelDelegate?
    var coordinator: HomeCoordinator?

}
