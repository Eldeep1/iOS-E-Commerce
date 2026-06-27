//
//  ApiError.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

enum ApiError:Error{
    case invalidPath
    case decoding
}


extension ApiError{
    var localizedDescription:String{
        switch self{
        case .invalidPath:
            return "Invalid Path"
        case .decoding:
            return "Error in decoding"
        }
    }
}
