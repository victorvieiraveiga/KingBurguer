//
//  FeedRemoteDataSource.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class FeedRemoteDataSource {
    
    static let shared = FeedRemoteDataSource()
    
    func fetch(accessToken: String, completion: @escaping (FeedResponse?, String?) -> Void) {
        WebServiceApi.shared.call(path: .feed, body: Optional<FeedRequest>.none, method: .get, accessToken: accessToken) { result in
            switch result {
                case .success(let data):
                    guard let data = data else { return }
                    let response = try? JSONDecoder().decode(FeedResponse.self, from: data)
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
    
    func fetchHighlight(accessToken: String, completion: @escaping (HighlightResponse?, String?) -> Void) {
        WebServiceApi.shared.call(path: .highlight, body: Optional<FeedRequest>.none, method: .get, accessToken: accessToken) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                let response = try? JSONDecoder().decode(HighlightResponse.self, from: data)
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


