//
//  SignUpViewModel.swift
//  DonsNote-Street
//
//  Created by Don on 7/31/25.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    
    @Published var authData = AuthModel()
    @Published var userId: String = "" { didSet { authData.userId = userId; updateFormValidity() }}
    @Published var email: String = "" { didSet { authData.email = email; updateFormValidity() }}
    @Published var password: String = "" { didSet { validatePassword(); validateConfirmPassword() }}
    @Published var confirmPassword: String = "" { didSet { validateConfirmPassword() }}
    
    @Published var isPasswordVisible: Bool = false
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil
    @Published var isFormValid: Bool = false
    
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
}
