//
//  ProductDetailRemoteDataSource.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class ProductDetailRemoteDataSource {
    
    static let shared = ProductDetailRemoteDataSource()
    
    func fetch(id: Int, accessToken: String, completion: @escaping (ProductResponse?, String?) -> Void) {
        let path = String(format: WebServiceApi.Endpoint.productDetail.rawValue, id)
        
        WebServiceApi.shared.call(path: path, method: .get, accessToken: accessToken) { result in
            switch result {
                case .success(let data):
                    guard let data = data else { return }
                    let response = try? JSONDecoder().decode(ProductResponse.self, from: data)
                    completion(response, nil)
                    break
                    
                case .failure(let error, let data):
                    print("ERROR: \(error)")
                    
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
                    
                    break
            }
        }
    }
    
}
