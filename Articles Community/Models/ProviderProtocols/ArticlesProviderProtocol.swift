//
//  ArticlesProviderProtocol.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import Foundation

protocol ArticlesProviderProtocol {

    func fetchArticles(
        completion: @escaping (Result<ArticlesResponse, APIError>) -> Void
    )
}