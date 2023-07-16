//
//  UserManager.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import Foundation
import Combine

final class UserManager {
    
    static let shared = UserManager()
    
    private var isLogin: Bool {
        UserDefaults.standard.read(key: .isLogin) as? Bool ?? false
    }
    
    func updateLoginState(_ isLogin: Bool) {
        UserDefaults.standard.write(key: .isLogin, value: isLogin)
    }
    
    func getLoginState() -> Bool {
        return UserDefaults.standard.read(key: .isLogin) as? Bool ?? false
    }
   
}
