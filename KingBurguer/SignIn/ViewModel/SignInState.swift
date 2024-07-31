//
//  SignInState.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 23/04/24.
//

import Foundation

enum SignInState {
    case none
    case loading
    case goToHome
    case error(String)
}
