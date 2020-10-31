//
//  NewsManager.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/27/20.
//

import Foundation
import UIKit
import CoreData

class NewsManager {
    public var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    public var entity: NSEntityDescription!
    public var cache: NSCache<NSNumber, NSData>!
    
    private(set) static var sharedManager: NewsManager = {
        let newsManager = NewsManager()
        newsManager.entity = NSEntityDescription.entity(forEntityName: "News", in: newsManager.context)
        newsManager.cache = NSCache<NSNumber, NSData>()
        return newsManager
    }()
    
    func cacheImageData(_ image: Data, for url: String) {
        self.cache.setObject(image as NSData, forKey: url.hash as NSNumber)
    }
    
    func getImage(for url: String) -> UIImage? {
        if let imageData = self.cache.object(forKey: url.hash as NSNumber), let image = UIImage(data: imageData as Data) {
            return image
        }
        return nil
    }
    
    func findFavourites(in news: [News]) {
        news.forEach { news in
            if self.context.insertedObjects.contains(news) {
                news.isSaved = true
            }
        }
    }
    
    private func saveChanges() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addToSaved(_ news: News) {
        context.insert(news)
        saveChanges()
    }
    
    func removeFromSaved(_ news: News) {
        if context.insertedObjects.contains(news) {
            context.delete(news)
        }
        saveChanges()
    }
}
