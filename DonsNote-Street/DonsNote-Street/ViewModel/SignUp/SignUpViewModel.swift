//
//  SignUpViewModel.swift
//  DonsNote-Street
//
//  Created by Don on 7/31/25.
//

import Foundation
import Combine

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
    
    @MainActor
    func signUp() async {
        guard validateAll() else { return }
        
        let signUpRequest = LocalSignUpRequest(
            name: userId,
            email: email,
            password: password,
            info: nil,
            userImgURL: nil
        )
        
        do {
            let tokenData = try await NetworkService.shared.request(
                .localSignUp(signUpRequest),
                responseType: TokenData.self
            )
            
            try TokenManager.shared.saveTokens(tokenData)
            TokenManager.shared.setLoginState(true)
            
            print("SignUp Success")
            
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            errorMessage = networkError.localizedDescription
        } else {
            errorMessage = "회원 가입 중 문제가 발생하였습니다. 다시 시도해주세요."
        }
        showingErrorAlert = true
        print("SignUp Error: \(error)")
    }
            }
    }
}
