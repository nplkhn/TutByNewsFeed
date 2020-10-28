//
//  News+CoreDataProperties.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/28/20.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var title: String?
    @NSManaged public var link: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var pubdate: Date?
    @NSManaged public var imageLink: String?

}

extension News : Identifiable {

}
