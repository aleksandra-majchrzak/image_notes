//
//  Note+CoreDataProperties.swift
//  ImageNotes
//
//  Created by Mohru on 12/30/16.
//  Copyright © 2016 Mohru. All rights reserved.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note");
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var date: String?
    @NSManaged public var image: NSData?

}
