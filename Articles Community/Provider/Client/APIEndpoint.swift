//
//  HTTPMethod.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import Foundation
import Alamofire

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

struct APIEndpoint {

    let path: String
    let method: HTTPMethod
    let parameters: Parameters?
    let headers: HTTPHeaders?

    init(
        path: String,
        method: HTTPMethod = .GET,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }

    var url: String {
        return AppConstants.baseURL + path
    }
}
