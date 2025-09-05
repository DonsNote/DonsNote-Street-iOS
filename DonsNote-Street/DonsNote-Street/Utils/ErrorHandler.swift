//
//  ErrorHandler.swift
//  DonsNote-Street
//
//  Created by Don on 9/5/25.
//

import Foundation
import SwiftUI

enum AppError: LocalizedError {
    case networkError(NetworkError)
    case authenticationError(String)
    case validationError(String)
    case keyChainError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let networkError):
            return networkError.localizedDescription
        case .authenticationError(let message):
            return message
        case .validationError(let message):
            return message
        case .keyChainError(let message):
            return "보안 저장소 오류: \(message)"
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "인터넷 연결을 확인하고 다시 시도해주세요."
        case .authenticationError:
            return "로그인 정보를 확인하고 다시 시도해주세요."
        case .validationError:
            return "입력 정보를 확인해주세요."
        case .keyChainError:
            return "앱을 재시작하고 다시 시도해주세요."
        case .unknownError:
            return "문제가 지속되면 고객센터에 문의해주세요."
        }
    }
}

class ErrorHandler: ObservableObject {
    @Published var currentError: AppError?
    @Published var showError = false
    
    func handle(_ error: Error) {
        DispatchQueue.main.async {
            if let appError = error as? AppError {
                self.currentError = appError
            } else if let networkError = error as? NetworkError {
                self.currentError = .networkError(networkError)
            } else {
                self.currentError = .unknownError
            }
            self.showError = true
        }
    }
    
    func clearError() {
        currentError = nil
        showError = false
    }
}