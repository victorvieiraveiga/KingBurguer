//
//  SignUpResponseError.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 27/07/24.
//

import Foundation

struct SignUpResponseError: Decodable {
    let detail: String
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
}
