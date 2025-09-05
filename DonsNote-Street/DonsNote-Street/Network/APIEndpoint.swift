//
//  APIEndpoint.swift
//  DonsNote-Street
//
//  Created by Don on 9/5/25.
//

import Foundation

enum APIEndpoint {
    case localSignUp(LocalSignUpRequest)
    case appleLogin(AppleLoginRequest)
    case googleLogin(GoogleLoginRequest)
    
    var path: String {
        switch self {
        case .localSignUp:
            return "/auth/signup"
        case .appleLogin:
            return "/auth/apple"
        case .googleLogin:
            return "/auth/google"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .localSignUp, .appleLogin, .googleLogin:
            return .POST
        }
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: ApiInfo.baseUrl + path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        switch self {
        case .localSignUp(let signUpRequest):
            request.httpBody = try JSONEncoder().encode(signUpRequest)
        case .appleLogin(let appleRequest):
            request.httpBody = try JSONEncoder().encode(appleRequest)
        case .googleLogin(let googleRequest):
            request.httpBody = try JSONEncoder().encode(googleRequest)
        }
        
        return request
    }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

// MARK: - Request Models
struct LocalSignUpRequest: Codable {
    let name: String
    let email: String
    let password: String
    let info: String?
    let userImgURL: String?
}

struct AppleLoginRequest: Codable {
    let provider: String
    let uid: String
    let authCode: String
}

struct GoogleLoginRequest: Codable {
    let provider: String
    let accessToken: String
}