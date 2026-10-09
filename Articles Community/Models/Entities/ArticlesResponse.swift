//
//  ArticlesResponse.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import Foundation

struct ArticlesResponse: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable {
    let source: ArticleSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct ArticleSource: Codable {
    let id: String?
    let name: String?
}