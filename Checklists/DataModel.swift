//
//  DataModel.swift
//  Checklists
//
//  Created by Kathleen Hang on 4/8/18.
//  Copyright © 2018 Kathleen Hang. All rights reserved.
//

import Foundation

class DataModel {
    // array of Checklist data type
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    // full path to Documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    // full path to the data file
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists()
    {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }
    
    // by default its at -1 which means main menu
    // changes to UserDefault default value
    func registerDefaults() {
        let dictionary: [String: Any] = [ "ChecklistIndex": -1,
                                          "FirstTime": true, "ChecklistItemID": 0 ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            // make sure app auto segue to new list
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }

    // get activates when app tries to read value of IndexOfSelectedChecklist
    // set activates when app tries to put new value into indexOfSelectedChecklist
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }

    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
    
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}
