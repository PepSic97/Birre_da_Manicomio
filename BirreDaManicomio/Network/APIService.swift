//
//  APIService.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import Foundation

final class APIService {
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "https://www.birredamanicomio.com/wp-json/wc/v3"
    private let key    = "ck_4b36a2556eaa6314f4f69ad0336b8e8db9f5a06e"
    private let secret = "cs_25d0092992d9f9c3d37a19566dbb8a2701e15b53"
    
    private var authHeader: String {
        let loginString = "\(key):\(secret)"
        let loginData = loginString.data(using: .utf8)!
        return "Basic \(loginData.base64EncodedString())"
    }
    
    
    func fetchProducts(categoryID: Int? = nil,
                       perPage: Int = 12,
                       completion: @escaping (Result<[Product], Error>) -> Void) {
        
        var components = URLComponents(string: "\(baseURL)/products")!
        components.queryItems = [
            URLQueryItem(name: "status", value: "publish"),
            URLQueryItem(name: "orderby", value: "date"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        if let cat = categoryID {
            components.queryItems?.append(URLQueryItem(name: "category", value: "\(cat)"))
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.success([]))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        let urlStr = "\(baseURL)/products/categories?consumer_key=\(key)&consumer_secret=\(secret)&per_page=50"
        
        guard let url = URL(string: urlStr) else {
            completion(.success([]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.success([]))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([Category].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
