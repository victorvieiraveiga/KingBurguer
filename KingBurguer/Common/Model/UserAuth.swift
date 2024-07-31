//
//  UserAuth.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

struct UserAuth: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresSeconds: Int
    let tokenType: String
}
