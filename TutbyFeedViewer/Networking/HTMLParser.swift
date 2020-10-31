//
//  HTMLParser.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/30/20.
//

import Foundation
import SwiftSoup

class HTMLParser {
    func parse(data: Data, completion: ((String) -> Void)?) {
        guard let htmlString = String(data: data, encoding: .utf8) else { return }
        
        let document: Document? = try? SwiftSoup.parse(htmlString)
        
        guard let doc = document,
              let textElements = try? doc.select("div#article_body>p") else { return }
        var text = ""
        textElements.forEach { element in
            text += try! element.text()
            text += "\n\n"
        }
        completion?(text)
        
        
//        completion?("check html parser")
    }
}
