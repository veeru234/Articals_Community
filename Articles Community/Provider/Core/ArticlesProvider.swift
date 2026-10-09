//
//  ArticlesProvider.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import Foundation
import Alamofire

final class ArticlesProvider:
    ArticlesProviderProtocol {

    private let apiClient: APIClient

    init(
        apiClient: APIClient = .shared
    ) {
        self.apiClient = apiClient
    }

    func fetchArticles(
        completion: @escaping (
            Result<ArticlesResponse, APIError>
        ) -> Void
    ) {

        let endpoint = APIEndpoint(
            path: AppConstants.API.articles,
            method: .GET
        )

        apiClient.request(
            endpoint: endpoint,
            responseType: ArticlesResponse.self,
            completion: completion
        )
    }
}