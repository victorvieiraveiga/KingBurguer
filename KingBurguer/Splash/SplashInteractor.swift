//
//  SplashInteractor.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class SplashInteractor {
    private let remote: SplashRemoteDataSource = .shared
    private let local: LocalDataSource = .shared
    
    func login(request: SplashRequest, completion: @escaping (SignInResponse?, Bool) -> Void) {
        let userAuth = local.getUserAuth()
        guard let accessToken = userAuth?.accessToken else {
            completion(nil, true)
            return
        }
        
        print(request)
        print(accessToken)
        remote.login(request: request, accessToken: accessToken) { response, error in
            
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
