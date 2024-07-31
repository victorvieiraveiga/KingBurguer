//
//  Doubles.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

extension Double {
    
    func toCurrency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        
        return formatter.string(from: self as NSNumber)
    }
}
