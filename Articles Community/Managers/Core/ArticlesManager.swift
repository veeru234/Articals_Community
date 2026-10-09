//
//  ArticlesManager.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import Foundation

final class ArticlesManager {

    private let provider: ArticlesProviderProtocol

    init(provider: ArticlesProviderProtocol = ArticlesProvider()) {
        self.provider = provider
    }

    func fetchArticles(
        showLoader: Bool = true,
        completion: @escaping (Result<[Article], APIError>) -> Void
    ) {

        if showLoader { LoaderManager.shared.show() }

        provider.fetchArticles { result in

            if showLoader { LoaderManager.shared.hide() }   // always first

            switch result {

            case .success(let response):
                completion(.success(response.articles ?? []))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
