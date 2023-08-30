//
//  Keychain.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import Foundation
import Security

final class Keychain: NSObject {
    
    public class func saveToken(data: String) {
        guard let serviceIdentifier = UserDefaults.standard.read(key: .userIdentifier) as? String else {
            return
        }
        self.save(service: serviceIdentifier, forKey: "tokenKey", data: data)
    }
    
    public class func loadToken() -> String? {
        guard let serviceIdentifier = UserDefaults.standard.read(key: .userIdentifier) as? String else {
            return nil
        }
        let data = self.load(service: serviceIdentifier, forKey: "tokenKey")
        return data
    }
    
    public class func deleteToken() {
        guard let serviceIdentifier = UserDefaults.standard.read(key: .userIdentifier) as? String,
              let token = Keychain.loadToken() else {
            return
        }
       
        self.delete(service: serviceIdentifier, forKey: "tokenKey", data: token)
    }
    
    public class func saveRefreshToken(data: String) {
        self.save(service: "refreshToken", forKey: "tokenKey", data: data)
    }
    
    public class func loadRefreshToken() -> String? {
        let data = self.load(service: "refreshToken", forKey: "tokenKey")
        return data
    }
  
}

private extension Keychain {
    class func save(service: String, forKey: String, data: String) {
        let dataFromString: Data = data.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: forKey,
                                    kSecValueData as String: dataFromString]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    class func load(service: String, forKey: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: forKey,
                                    kSecReturnData as String: kCFBooleanTrue!,
                                    kSecMatchLimit as String: kSecMatchLimitOne as String]
        
        var retrievedData: NSData?
        var dataTypeRef: AnyObject?
        var contentsOfKeychain: String?
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            retrievedData = dataTypeRef as? NSData
            contentsOfKeychain = String(data: retrievedData! as Data, encoding: String.Encoding.utf8)
        } else {
            print("No Data From Keychain")
            contentsOfKeychain = nil
        }
        
        return contentsOfKeychain
    }
    
    class func delete(service: String, forKey: String, data: String) {
        let dataFromString: Data = data.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: forKey,
                                    kSecValueData as String: dataFromString]
        
        SecItemDelete(query as CFDictionary)
    }
}

