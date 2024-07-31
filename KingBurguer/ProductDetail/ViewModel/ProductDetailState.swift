//
//  ProductDetailState.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

enum ProductDetailState {
    case loading
    case success(ProductResponse)
    case error(String)
}
