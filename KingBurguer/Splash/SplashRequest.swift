//
//  SplashRequest.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

struct SplashRequest: Encodable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
