//
//  SignUpState.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 10/05/24.
//

import Foundation

enum SignUpState {
    case none
    case loading
    case goToLogin
    case error(String)
}
