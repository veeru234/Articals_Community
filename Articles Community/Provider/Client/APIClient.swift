//
//  APIClient.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//

import Foundation
import Alamofire

final class APIClient {

    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        showLoader: Bool = false,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {

        guard URL(string: endpoint.url) != nil else {
            completion(.failure(.invalidURL))
            return
        }

        let method = Alamofire.HTTPMethod(rawValue: endpoint.method.rawValue)

        if showLoader { LoaderManager.shared.show() }

        AF.request(
            endpoint.url,
            method: method,
            parameters: endpoint.parameters,
            encoding: endpoint.method == .GET ? URLEncoding.default : JSONEncoding.default,
            headers: endpoint.headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in

            if showLoader { LoaderManager.shared.hide() }   // always first

            switch response.result {

            case .success(let value):
                completion(.success(value))

            case .failure(let error):
                let statusCode = response.response?.statusCode

                if statusCode == 401 {
                    completion(.failure(.unauthorized))
                } else if let statusCode, statusCode >= 500 {
                    completion(.failure(.serverError(statusCode)))
                } else {
                    completion(.failure(.requestFailed(error)))
                }
            }
        }
    }
}
