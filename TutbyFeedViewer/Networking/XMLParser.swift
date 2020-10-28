//
//  XMLParser.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/27/20.
//

import Foundation
import CoreData


class NewsFeedParser: NSObject {
    
    private var news: [News] = []
    
    private var currentElement: String
    private var currentTitle: String {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentLink: String {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubdate: String {
        didSet {
            currentPubdate = currentPubdate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parser: XMLParser!
    
    private var completion: (([News]) -> Void)?
    
    private let newsManager = NewsManager.sharedManager
    
    override init() {
        currentTitle = ""
        currentLink = ""
        currentDescription = ""
        currentPubdate = ""
        currentElement = ""
        super.init()
    }
    
    func parseFeed(data: Data, completion: (([News]) -> Void)?) {
        self.completion = completion
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func deleteHtmlFrom(string: String) -> String {
        do {
            let regex:NSRegularExpression  = try NSRegularExpression(  pattern: "<.*?>", options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, string.count)
            let htmlLessString:String = regex.stringByReplacingMatches(in: string, options: NSRegularExpression.MatchingOptions(), range:range , withTemplate: "")
            return htmlLessString
        } catch {
            print(error.localizedDescription)
        }
        return string
    }
    
}

extension NewsFeedParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubdate = ""
        }
        if currentElement == "media:content" {
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        case "pubdate":
            currentPubdate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE, d MMM yyyy HH:mm:ss Z"
            let pubdate = formatter.date(from: currentPubdate)

            let currentNews = News(entity: newsManager.entity, insertInto: nil)
            currentNews.title = currentTitle
            currentNews.link = currentLink
            currentNews.newsDescription = deleteHtmlFrom(string: currentDescription)
            currentNews.pubdate = pubdate
            news.append(currentNews)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion?(news)
    }
}
