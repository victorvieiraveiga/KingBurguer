//
//  Mask.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 25/07/24.
//

import Foundation
import UIKit

class Mask {
    private let mask: String
    var oldString = ""
    
    init(mask: String) {
        self.mask = mask
    }
    
    private func repalceChars(value: String) -> String {
        value.replacingOccurrences(of: ".", with: "")
        .replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: "/", with: "")
        .replacingOccurrences(of: " ", with: "")
    }
    
    func process(value: String) -> String? {
        if value.count > mask.count {
            return String(value.dropLast())
        }
        let str = repalceChars(value: value)
        
        let isDeleting = str <= oldString
        
        if value.count == mask.count {
            return nil
        }
        
        oldString = str
        
        var result = ""
        var i = 0
        for char in mask {
            if char != "#" {
                if isDeleting {
                    continue
                }
                result = result + String(char)
            } else {
                let character = str.charAtIndex(index: i)
                guard let c = character else { break }
                
                result = result + String(c)
                i = i + 1
            }
        }
        return result
    }
}
