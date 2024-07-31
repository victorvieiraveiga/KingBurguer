//
//  FeedInteractor.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class FeedInteractor {
    private let remote: FeedRemoteDataSource = .shared
    private let local: LocalDataSource = .shared
    
    func fetch(completion: @escaping (FeedResponse?, String?) -> Void) {
        let userAuth = local.getUserAuth()
        guard let accessToken = userAuth?.accessToken else {
            completion(nil, "Access token not found!")
            return
        }
        
        return remote.fetch(accessToken: accessToken, completion: completion)
    }
    
    func fetchHighlight(completion: @escaping (HighlightResponse?, String?) -> Void) {
        let userAuth = local.getUserAuth()
        guard let accessToken = userAuth?.accessToken else {
            completion(nil, "Access token not found!")
            return
        }
        
        return remote.fetchHighlight(accessToken: accessToken, completion: completion)
    }
}
