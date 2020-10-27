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
    
    private(set) static var sharedManager: NewsManager = {
        let newsManager = NewsManager()
        
        newsManager.entity = NSEntityDescription.entity(forEntityName: "News", in: newsManager.context)
        return newsManager
    }()
}
