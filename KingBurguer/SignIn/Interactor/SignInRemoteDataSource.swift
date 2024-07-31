//
//  SignInRemoteDataSource.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class SignInRemoteDataSource {
    static let shared = SignInRemoteDataSource()
    
    func login(request: SignInRequest, completion: @escaping(SignInResponse?, String?) -> Void) {
        WebServiceApi.shared.call(path: .login, body: request, method: .post) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                guard let response = try? JSONDecoder().decode(SignInResponse.self, from: data) else { return }
                completion(response, nil)
                break
                
            case .failure(let error, let data):
                guard let data = data else { return }
                switch error {
                case .unauthorized:
                    let response = try? JSONDecoder().decode(ResponseUnauthorized.self, from: data)
                    completion(nil, response?.detail.message)
                    break
                    
                default:
                    let response = try? JSONDecoder().decode(SignUpResponseError.self, from: data)
                    completion(nil, response?.detail)
                    break
                }
            }
        }
    }
}
