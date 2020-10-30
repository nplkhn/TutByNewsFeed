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
              let textElements = try? doc.select("div#article_body>p"),
              let text = try? textElements.text() else { return }
        var text1 = ""
        textElements.forEach { element in
            text1 += try! element.text()
            text1 += "\n"
        }
        completion?(text1)
        
        
//        completion?("check html parser")
    }
}
