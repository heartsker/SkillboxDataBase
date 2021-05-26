//
//  ToDoListItem+CoreDataProperties.swift
//  
//
//  Created by Daniel Pustotin on 26.05.2021.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var text: String?

}
