//
//  LocalDataSource.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

class LocalDataSource {
    
    static let shared = LocalDataSource()
    
    func insertUserAuth(userAuth: UserAuth) {
        let value = try? PropertyListEncoder().encode(userAuth)
        UserDefaults.standard.set(value, forKey: "user_key")
    }
    
    func getUserAuth() -> UserAuth? {
        if let data = UserDefaults.standard.value(forKey: "user_key") as? Data {
            let user = try? PropertyListDecoder().decode(UserAuth.self, from: data)
            return user
        }
        return nil
    }
    
}
