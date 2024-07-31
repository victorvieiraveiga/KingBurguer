//
//  SplashRemoteDataSource.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class SplashRemoteDataSource {
    static let shared = SplashRemoteDataSource()
    
    func login(request: SplashRequest, accessToken: String, completion: @escaping (SignInResponse?, Bool) -> Void) {
        WebServiceApi.shared.call(path: .refreshToken, body: request, method: .put, accessToken: accessToken) { result in
            switch result {
                case .success(let data):
                    guard let data = data else { return }
                    let response = try? JSONDecoder().decode(SignInResponse.self, from: data)
                    completion(response, false)
                    break
                    
                case .failure(let error, let data):
                    print("ERROR: \(error)")
                    
                    completion(nil, true)
                    break
            }
        }
    }
}
