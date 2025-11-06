//
//  APIService.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import Foundation
import SwiftSoup

final class APIService {
    static let shared = APIService()
    private init() {}
    private let baseURL = "https://www.birredamanicomio.com/wp-json/wc/v3"
    private let key    = "ck_4b36a2556eaa6314f4f69ad0336b8e8db9f5a06e"
    private let secret = "cs_25d0092992d9f9c3d37a19566dbb8a2701e15b53"
    
    private var authParams: [URLQueryItem] {
        [
            .init(name: "consumer_key", value: key),
            .init(name: "consumer_secret", value: secret)
        ]
    }
    
    // MARK: - PRODUCTS
    func fetchProducts(categoryID: Int? = nil,
                       perPage: Int = 12,
                       completion: @escaping (Result<[Product], Error>) -> Void) {
        
        var url = URLComponents(string: "\(baseURL)/products")!
        var items = authParams
        items.append(contentsOf: [
            .init(name: "status", value: "publish"),
            .init(name: "orderby", value: "date"),
            .init(name: "order", value: "desc"),
            .init(name: "per_page", value: "\(perPage)")
        ])
        if let cid = categoryID {
            items.append(.init(name: "category", value: "\(cid)"))
        }
        url.queryItems = items
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, err in
            if let err = err {
                DispatchQueue.main.async { completion(.failure(err)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.success([])) }
                return
            }
            
            do {
                // 🔹 Prima proviamo array diretto
                if let array = try? JSONDecoder().decode([Product].self, from: data) {
                    DispatchQueue.main.async { completion(.success(array)) }
                    return
                }
                
                // 🔹 Poi proviamo dizionario contenente array (es. {"products": [...]})
                if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let arrData = try? JSONSerialization.data(withJSONObject: dict["products"] ?? []) {
                    let decoded = try JSONDecoder().decode([Product].self, from: arrData)
                    DispatchQueue.main.async { completion(.success(decoded)) }
                    return
                }
                
                DispatchQueue.main.async { completion(.success([])) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            
        }.resume()
    }
    
    // MARK: - CATEGORIES
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        var url = URLComponents(string: "\(baseURL)/products/categories")!
        url.queryItems = authParams + [.init(name: "per_page", value: "100")]
        
        URLSession.shared.dataTask(with: url.url!) { data, _, err in
            if let err = err {
                DispatchQueue.main.async { completion(.failure(err)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.success([])) }
                return
            }
            
            do {
                if let array = try? JSONDecoder().decode([Category].self, from: data) {
                    DispatchQueue.main.async { completion(.success(array)) }
                    return
                }
                
                if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let arrData = try? JSONSerialization.data(withJSONObject: dict["categories"] ?? []) {
                    let decoded = try JSONDecoder().decode([Category].self, from: arrData)
                    DispatchQueue.main.async { completion(.success(decoded)) }
                    return
                }
                
                DispatchQueue.main.async { completion(.success([])) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            
        }.resume()
    }
}
