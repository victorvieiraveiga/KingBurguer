//
//  SignUpInteractor.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 29/07/24.
//

import Foundation

class SignUpInteractor {
    
    private let remote: SignUpRemoteDataSource = SignUpRemoteDataSource.shared
    func createUser(request: SignUpRequest, completion: @escaping(Bool?, String?) -> Void) {
        remote.createUser(request: request, completion: completion)
    }
}
