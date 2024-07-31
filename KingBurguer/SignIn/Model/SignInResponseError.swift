//
//  SigInResponseError.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 29/07/24.
//

import Foundation

struct SignInResponseError: Decodable {
    let detail: String
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
}


struct SigInResponseDetail: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}
