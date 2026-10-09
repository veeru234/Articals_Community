//
//  APIError.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import Foundation
import Alamofire

enum APIError: Error {

    case invalidURL
    case noInternet
    case unauthorized
    case serverError(Int)
    case decodingError
    case sslPinningFailed
    case requestFailed(AFError)
    case unknown

    var message: String {

        switch self {

        case .invalidURL:
            return "Invalid URL."

        case .noInternet:
            return "Please check your internet connection."

        case .unauthorized:
            return "Your session has expired."

        case .serverError(let code):
            return "Server error: \(code)"

        case .decodingError:
            return "Unable to process server response."

        case .sslPinningFailed:
            return "Secure connection failed."

        case .requestFailed(let error):
            return error.localizedDescription

        case .unknown:
            return "Something went wrong."
        }
    }
}
