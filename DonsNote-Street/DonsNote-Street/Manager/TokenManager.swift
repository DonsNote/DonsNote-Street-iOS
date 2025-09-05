//
//  TokenManager.swift
//  DonsNote-Street
//
//  Created by Don on 9/5/25.
//

import Foundation

class TokenManager {
    
    static let shared = TokenManager()
    private let keyChainService = "DonsNote.StreetApp"
    
    private init() {}
    
    // MARK: - Save Tokens
    func saveTokens(_ tokenData: TokenData) throws {
        try saveAccessToken(tokenData.accessToken)
        try saveRefreshToken(tokenData.refreshToken)
    }
    
    private func saveAccessToken(_ token: String) throws {
        try KeyChain(account: "ServerToken", service: keyChainService).saveItem(token)
    }
    
    private func saveRefreshToken(_ token: String) throws {
        try KeyChain(account: "RefreshToken", service: keyChainService).saveItem(token)
    }
    
    // MARK: - Get Tokens
    var accessToken: String? {
        do {
            return try KeyChain(account: "ServerToken", service: keyChainService).readItem()
        } catch {
            return nil
        }
    }
    
    var refreshToken: String? {
        do {
            return try KeyChain(account: "RefreshToken", service: keyChainService).readItem()
        } catch {
            return nil
        }
    }
    
    // MARK: - Delete Tokens
    func clearTokens() {
        deleteAccessToken()
        deleteRefreshToken()
    }
    
    private func deleteAccessToken() {
        do {
            try KeyChain(account: "ServerToken", service: keyChainService).deleteItem()
        } catch {
            print("Failed to delete access token: \(error)")
        }
    }
    
    private func deleteRefreshToken() {
        do {
            try KeyChain(account: "RefreshToken", service: keyChainService).deleteItem()
        } catch {
            print("Failed to delete refresh token: \(error)")
        }
    }
    
    // MARK: - Token Validation
    var hasValidTokens: Bool {
        return accessToken != nil && refreshToken != nil
    }
    
    // MARK: - Login State Management
    func setLoginState(_ isLoggedIn: Bool) {
        UserDefaults.standard.set(isLoggedIn, forKey: "isLogin")
    }
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: "isLogin")
    }
    
    // MARK: - Logout
    func logout() {
        clearTokens()
        setLoginState(false)
    }
}