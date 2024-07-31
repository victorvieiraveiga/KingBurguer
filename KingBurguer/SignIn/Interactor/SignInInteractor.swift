//
//  SignInInteractor.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class SignInInteractor {
    
    private let remote: SignInRemoteDataSource = SignInRemoteDataSource.shared
    private let local: LocalDataSource = .shared
    func login(request: SignInRequest, completion: @escaping(SignInResponse?, String?) -> Void) {
        remote.login(request: request) { response, error in
            if let r = response {
                let userAuth = UserAuth(accessToken: r.accessToken,
                                        refreshToken: r.refreshToken,
                                        expiresSeconds: Int(Date().timeIntervalSince1970 + Double(r.expiresSeconds)),
                                        tokenType: r.tokenType)
                
                self.local.insertUserAuth(userAuth: userAuth)
            }
            
            completion(response, error)
        }
    }
}
