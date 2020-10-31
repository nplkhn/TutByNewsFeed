//
//  News+CoreDataClass.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/27/20.
//
//

import Foundation
import CoreData

@objc(News)
public class News: NSManagedObject {
    
    var isSaved: Bool?
    var newsText: String?
    
    static func ==(lhs: News, rhs: News) -> Bool {
        return lhs.title == rhs.title
    }

}
