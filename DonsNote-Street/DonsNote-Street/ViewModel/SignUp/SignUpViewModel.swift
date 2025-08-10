//
//  SignUpViewModel.swift
//  DonsNote-Street
//
//  Created by Don on 7/31/25.
//

import Foundation
import Combine
import Alamofire

class SignUpViewModel: ObservableObject {
    
    @Published var userId: String = "" { didSet { updateFormValidity() }}
    @Published var email: String = "" { didSet { updateFormValidity() }}
    @Published var password: String = "" { didSet { validatePassword(); validateConfirmPassword() }}
    @Published var confirmPassword: String = "" { didSet { validateConfirmPassword() }}
    
    @Published var isPasswordVisible: Bool = false
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil
    @Published var isFormValid: Bool = false
    
    @Published var showingErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private func updateFormValidity() {
        isFormValid = passwordError == nil && confirmPasswordError == nil && !self.userId.isEmpty &&
        !self.email.isEmpty && !self.password.isEmpty && !confirmPassword.isEmpty
    }
    
    func validatePassword() {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*.,?]).{8,}$"#
        let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        
        passwordError = isValid ? nil : "비밀번호는 8자 이상, 숫자, 대문자, 특수문자를 포함해야합니다."
        updateFormValidity()
    }
    
    func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = nil
        }
        
        else if password != confirmPassword {
            confirmPasswordError = "비밀번호가 일치하지 않습니다."
        }
        
        else {
            confirmPasswordError = nil
        }
        updateFormValidity()
    }
    
    func validateAll() -> Bool {
        validatePassword()
        validateConfirmPassword()
        return isFormValid
    }
    
    func signUp() {
        let parameters: [String: Any] = [
            "provider" : "local",
            "userId" : userId,
            "email" : email,
            "password" : password
        ]
        
        AF.request(ApiInfo.baseUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
                        print("SignUp Success")
                    }
                    
                    catch {
                        self.errorMessage = "회원 가입 중 문제가 발생하였습니다. 다시 시도해주세요."
                        self.showingErrorAlert = true
                        print("KeyChain Error: \(error)")
                    }
                    
                case.failure(let error):
                    self.errorMessage = "회원 가입에 실패했습니다. 다시 시도해주세요."
                    self.showingErrorAlert = true
                    print("SignUp Error: \(error)")
                }
            }
    }
}
