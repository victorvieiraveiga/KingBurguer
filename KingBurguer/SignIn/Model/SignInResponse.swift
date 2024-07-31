//
//  SignInResponse.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 29/07/24.
//

import Foundation

struct SignInResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresSeconds: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresSeconds = "expires_seconds"
        case tokenType = "token_type"
    }
}
