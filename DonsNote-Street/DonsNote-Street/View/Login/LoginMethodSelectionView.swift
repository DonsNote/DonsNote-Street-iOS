//
//  LoginMethodSelectionView.swift
//  DonsNote-Street
//
//  Created by Don on 7/31/25.
//

import SwiftUI
import AuthenticationServices

struct LoginMethodSelectionView: View {
    
    @StateObject private var appleViewModel = AppleLoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                Text("Welcome to Street-Art!")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: SignUpView()) {
                    Text("Sign up with StreetArt")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                SignInWithAppleButton(
                    onRequest: appleViewModel.handleAppleRequest,
                    onCompletion: appleViewModel.handleAppleCompletion
                )
                .frame(height: 45)
                
                Button(action: {
                    // TODO: Google 로그인 로직
                }) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Continue with Google")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginMethodSelectionView()
}
