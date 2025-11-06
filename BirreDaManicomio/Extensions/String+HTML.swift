//
//  String+HTML.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    func htmlToString() -> String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        return (try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ).string) ?? self
    }
}

