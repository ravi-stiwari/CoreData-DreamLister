//
//  Image+CoreDataProperties.swift
//  DreamLister
//
//  Created by Ravi Tiwari on 3/12/17.
//  Copyright © 2017 SelfStudy. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var item: Item?
    @NSManaged public var store: NSSet?

}

// MARK: Generated accessors for store
extension Image {

    @objc(addStoreObject:)
    @NSManaged public func addToStore(_ value: Store)

    @objc(removeStoreObject:)
    @NSManaged public func removeFromStore(_ value: Store)

    @objc(addStore:)
    @NSManaged public func addToStore(_ values: NSSet)

    @objc(removeStore:)
    @NSManaged public func removeFromStore(_ values: NSSet)

}
