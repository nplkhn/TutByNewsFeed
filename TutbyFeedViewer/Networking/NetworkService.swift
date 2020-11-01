//
//  NetworkService.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/27/20.
//

import Foundation

class NetworkService {
    
    private var xmlParser = NewsFeedParser()
    private var htmlParser = HTMLParser()
    private var tasks: [String:[URLSessionDataTask]] = [:]
    
    
    func requestFeed(completion: @escaping ([News]?, Error?) -> Void) {
        guard let url = URL(string: "https://news.tut.by/rss/index.rss") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            
            self.xmlParser.parse(data: data) { (news) in
                completion(news, nil)
            }
        }.resume()
    }
    
    func requestImage(from urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let imageData = data else { return }
            
            completion(imageData, nil)
        }
        self.tasks[urlString]?.append(task)
        task.resume()
    }
    
    func requestNews(from urlString: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let newsData = data else { return }
            self.htmlParser.parse(data: newsData) { newsText in
                completion(newsText, nil)
            }
        }.resume()
    }
    
    
    func cancellTask(for urlString: String) {
        if let tasks = tasks[urlString] {
            tasks.forEach { task in
                task.cancel()
            }
        }
    }
    
    private(set) static var shared: NetworkService = {
        let networkService = NetworkService()
        return networkService
    }()
    
}
