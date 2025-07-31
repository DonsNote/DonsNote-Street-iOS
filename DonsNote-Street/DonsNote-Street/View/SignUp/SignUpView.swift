//
//  SignUpView.swift
//  DonsNote-Street
//
//  Created by Don on 7/31/25.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("회원가입").font(.largeTitle).bold()
            
            IdField(viewModel: viewModel)
            EmailField(viewModel: viewModel)
            PasswordField(viewModel: viewModel)
            ConfirmPasswordField(viewModel: viewModel)
            
            Button("Next") {
                
            }
            .disabled(!viewModel.isFormValid)
            .foregroundColor(viewModel.isFormValid ? .white : .gray)
            .padding()
            .background(viewModel.isFormValid ? Color.blue : Color.gray)
            .cornerRadius(10)
        }
        .padding(20)
    }
}

#Preview {
    SignUpView()
}

extension SignUpView {
    
    struct IdField: View {
        
        @ObservedObject var viewModel: SignUpViewModel
        
        var body: some View {
            TextField("ID", text: $viewModel.userId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    struct EmailField: View {
        
        @ObservedObject var viewModel: SignUpViewModel
        
        var body: some View {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    struct PasswordField: View {
        
        @ObservedObject var viewModel: SignUpViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Group {
                        if viewModel.isPasswordVisible {
                            TextField("Password", text: $viewModel.password)
                        }
                        
                        else {
                            SecureField("Password", text: $viewModel.password)
                        }
                    }
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewModel.isPasswordVisible.toggle()
                    }) {
                        HStack {
                            Image(systemName: viewModel.isPasswordVisible ? "eye" : "eye.slash")
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                }
                
                if let error = viewModel.passwordError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
    }
    
    struct ConfirmPasswordField: View {
        
        @ObservedObject var viewModel: SignUpViewModel
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    if viewModel.isPasswordVisible {
                        TextField("Check Password", text: $viewModel.confirmPassword)
                    }
                    else {
                        SecureField("Check Password", text: $viewModel.confirmPassword)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let error = viewModel.confirmPasswordError {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
        }
    }
}
