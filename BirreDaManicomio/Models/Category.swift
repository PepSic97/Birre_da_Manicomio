//
//  Category.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: Int
    let name: String
    let slug: String?
}
