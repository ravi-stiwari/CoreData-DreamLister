//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Ravi Tiwari on 3/12/17.
//  Copyright © 2017 SelfStudy. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
        
    }
    
}
