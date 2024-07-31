//
//  ProductDetailInteractor.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class ProductDetailInteractor {
    
    private let remote: ProductDetailRemoteDataSource = .shared
    private let local: LocalDataSource = .shared
    
    func fetch(id: Int, completion: @escaping (ProductResponse?, String?) -> Void) {
        let userAuth = local.getUserAuth()
        guard let accessToken = userAuth?.accessToken else {
            completion(nil, "Access token not found!")
            return
        }
        
        return remote.fetch(id: id, accessToken: accessToken, completion: completion)
    }
    
}
