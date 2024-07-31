//
//  SignUpRequest.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 27/07/24.
//

import Foundation

struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let password: String
    let document: String
    let birthday: String
}
