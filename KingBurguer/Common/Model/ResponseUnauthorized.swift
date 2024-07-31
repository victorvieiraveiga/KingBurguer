//
//  ResponseUnauthorized.swift.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 29/07/24.
//

import Foundation

struct ResponseUnauthorized: Decodable {
    
    let detail: ResponseDetail
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
    
}

struct ResponseDetail: Decodable {
    
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}
