//
//  SignUpResponse.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 27/07/24.
//

import Foundation

struct SignUpResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let password: String
    let document: String
    let birthday: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case password
        case document
        case birthday
    }
}
