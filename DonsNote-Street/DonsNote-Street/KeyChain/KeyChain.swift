//
//  KeyChain.swift
//  DonsNote-Street
//
//  Created by Don on 8/1/25.
//

import Foundation

struct KeyChain {
    
    enum KeyChainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandleError
    }
    
    private(set) var account: String
    let service: String
    let accessGroup: String?
    
    init(account: String, service: String, accessGroup: String? = nil) {
        
        self.account = account
        self.service = service
        self.accessGroup = accessGroup
    }
    
    private static func KeyChainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }
    
    func readItem() throws -> String {
        
        var query = KeyChain.KeyChainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeyChainError.noPassword }
        guard status == noErr else { throw KeyChainError.unhandleError }
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeyChainError.unexpectedPasswordData
        }
        return password
    }
    
    func saveItem(_ password: String) throws {
        
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            try _ = readItem()
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeyChain.KeyChainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeyChainError.unhandleError }
        }
        
        catch KeyChainError.noPassword {
            
            var newItem = KeyChain.KeyChainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeyChainError.unhandleError }
        }
    }
    
    func deleteItem() throws {
        
        let query = KeyChain.KeyChainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeyChainError.unhandleError }
    }
    
    /* Items */
    
    // Server Token & Refresh Token
    static var ServerToken: String {
        do {
            let storedToken = try KeyChain(account: "ServerToken", service: "Donsnote.StreetApp").readItem()
            return storedToken
        }
        
        catch {
            return ("Server Token not found")
        }
    }
    
    static var RefreshToken: String {
        do {
            let storedToken = try KeyChain(account: "RefreshToken", service: "Donsnote.StreetApp").readItem()
            return storedToken
        }
        
        catch {
            return ("Refresh Token not found")
        }
    }
    
    static func deleteServerToken() {
        do {
            try KeyChain(account: "ServerToken", service: "Donsnote.StreetApp").deleteItem()
        }
        catch {
            print("Unable to delete Server Token")
        }
    }
    
    static func deleteRefreshToken() {
        do {
            try KeyChain(account: "RefreshToken", service: "Donsnote.StreetApp").deleteItem()
        }
        catch {
            print("Unable to delete Refresh Token")
        }
    }

    
}
