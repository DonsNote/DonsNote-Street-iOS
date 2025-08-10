//
//  AppleLogin.swift
//  DonsNote-Street
//
//  Created by Don on 8/2/25.
//

import Foundation
import Alamofire
import AuthenticationServices


class AppleLoginViewModel: NSObject, ObservableObject {
    
    func handleAppleRequest (_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAppleCompletion (_ result: Result<ASAuthorization, Error>) -> Void {
        switch result {
        case .success(let authResults):
            guard let appleIDCredential  = authResults.credential as? ASAuthorizationAppleIDCredential,
                  let codeData = appleIDCredential.authorizationCode,
                  let authCode = String(data: codeData, encoding: .utf8)
            else {
                print("AuthorizationCode Error")
                return
            }
            let uid = appleIDCredential.user
            
            let parameters: [String: String] = [
                "provider" : "apple",
                "uid" : uid,
                "authCode" : authCode
            ]
            
            AF.request("\(ApiInfo.baseUrl)/auth/", method: .post, parameters: parameters)
                .validate()
                .responseDecodable(of: TokenData.self) { response in
                    switch response.result {
                    case .success(let tokenData):
                        do {
                            try KeyChain(account: "ServerToken", service: "DonsNote.StreetApp").saveItem(tokenData.accessToken)
                            try KeyChain(account: "RefreshToken", service: "DonsNote.StreetApp").saveItem(tokenData.refreshToken)
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(true, forKey: "isLogin")
                            }
                            print("Apple Login Success")
                        }
                        catch {
                            print("Apple Login App Server Error with KeyChain \(error)")
                        }
                    case .failure(let error):
                        print("Apple Login App Server Error \(error)")
                    }
                }
            
        case .failure(let error):
            print("Apple Login Error with AppleServer : \(error)")
        }
    }
}
