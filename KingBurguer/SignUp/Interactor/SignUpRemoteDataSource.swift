//
//  SignUpRemoteDataSource.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 29/07/24.
//

import Foundation

class SignUpRemoteDataSource {
    static let shared = SignUpRemoteDataSource()
    
    func createUser(request: SignUpRequest, completion: @escaping(Bool?, String?) -> Void) {
        WebServiceApi.shared.call(path: .createUser, body: request, method: .post) { result in
            switch result {
            case .failure(let error, let data):
                guard let data = data else { return }
                    switch error {
                    case .unauthorized:
                        let response = try? JSONDecoder().decode(ResponseUnauthorized.self, from: data)
                        completion(nil, response?.detail.message)
                        break
                    case .badRequest:
                        let response = try? JSONDecoder().decode(SignUpResponseError.self, from: data)
                        completion(nil, response?.detail)
                        break
                    case .notFound:
                        let response = try? JSONDecoder().decode(SignUpResponseError.self, from: data)
                        completion(nil, response?.detail)
                        break
                    default:
                        break
                    }
            
            case .success(let data):
                guard let data = data  else { return }
                let response = try? JSONDecoder().decode(SignUpResponse.self, from: data)
                completion(true, nil)
                break
            }
        }
    }
}
