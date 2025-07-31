//
//  LoginMethodSelectionView.swift
//  DonsNote-Street
//
//  Created by Don on 7/31/25.
//

import SwiftUI

struct LoginMethodSelectionView: View {
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

                Button(action: {
                    // TODO: Apple 로그인 로직
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Continue with Apple")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

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
