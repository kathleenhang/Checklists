//
//  Checklist.swift
//  Checklists
//
//  Created by Kathleen Hang on 4/8/18.
//  Copyright © 2018 Kathleen Hang. All rights reserved.
//

import UIKit
// creates checklist objects and encodes/decodes
class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    // convenience initializer since it farms out its work to another init method
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    // designated initializer
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
        
        
        /*
         // cnt increments by 1 or 0. returns total count of unchecked items
         return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
        */
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
