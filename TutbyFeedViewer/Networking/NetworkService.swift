//
//  NetworkService.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/27/20.
//

import Foundation

class NetworkService {
    
    private var parser = NewsFeedParser()
    
    func request(url urlString: String, completion: @escaping ([News]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            
            self.parser.parseFeed(data: data) { (news) in
                completion(news, nil)
            }
        }.resume()
    }
    
    func requestImage(from urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let imageData = data else { return }
            
            completion(imageData, nil)
        }.resume()
    }
    
    private(set) static var shared: NetworkService = {
        let networkService = NetworkService()
        
        return networkService
    }()
    
}
