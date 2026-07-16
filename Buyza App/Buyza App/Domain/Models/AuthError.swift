//
//  AuthError.swift
//  Buyza App
//
//  Created by depo on 27/06/2026.
//
import Foundation
import FirebaseAuth 

enum AuthError: LocalizedError {
    case invalidEmail
    case firebaseError(String)
    case shopifyError(String)
    case emailNotVerified
    case userCanceled
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "Please enter a valid email address."
        case .firebaseError(let msg): return msg
        case .shopifyError(let msg): return msg
        case .emailNotVerified: return "Please check your email and verify your account before logging in."
        case .userCanceled: return "Authentication was canceled."
        }
    }
    
    static func map(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        if nsError.domain == AuthErrorDomain, let errorCode = AuthErrorCode.Code(rawValue: nsError.code) {
            switch errorCode {
            case .wrongPassword:
                return .firebaseError("Incorrect password. Please try again.")
            case .userNotFound:
                return .firebaseError("No account found with this email.")
            case .invalidEmail:
                return .firebaseError("The email address is badly formatted.")
                
            case .emailAlreadyInUse:
                return .firebaseError("This email is already linked to an account.")
            case .weakPassword:
                return .firebaseError("Your password must be at least 6 characters long.")
                
            default:
                return .firebaseError(error.localizedDescription)
            }
        }
        
        return .firebaseError(error.localizedDescription)
    }
}
