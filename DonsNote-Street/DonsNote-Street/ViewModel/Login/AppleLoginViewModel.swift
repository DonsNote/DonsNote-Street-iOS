//
//  AppleLogin.swift
//  DonsNote-Street
//
//  Created by Don on 8/2/25.
//

import Foundation
import AuthenticationServices


class AppleLoginViewModel: NSObject, ObservableObject {
    
    func handleAppleRequest (_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAppleCompletion (_ result: Result<ASAuthorization, Error>) -> Void {
        switch result {
        case .success(let authResults):
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                  let codeData = appleIDCredential.authorizationCode,
                  let authCode = String(data: codeData, encoding: .utf8)
            else {
                print("AuthorizationCode Error")
                return
            }
            
            let uid = appleIDCredential.user
            let appleRequest = AppleLoginRequest(
                provider: "apple",
                uid: uid,
                authCode: authCode
            )
            
            Task { @MainActor in
                do {
                    let tokenData = try await NetworkService.shared.request(
                        .appleLogin(appleRequest),
                        responseType: TokenData.self
                    )
                    
                    try TokenManager.shared.saveTokens(tokenData)
                    TokenManager.shared.setLoginState(true)
                    
                    print("Apple Login Success")
                    
                } catch {
                    print("Apple Login Error: \(error)")
                }
            }
            
        case .failure(let error):
            print("Apple Login Error with AppleServer: \(error)")
        }
    }
}