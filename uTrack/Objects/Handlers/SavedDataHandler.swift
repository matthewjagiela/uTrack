//
//  SavedDataHandler.swift
//  uTrack
//
//  Created by Matthew Jagiela on 4/4/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit

class SavedDataHandler: NSObject {
    
    func saveItemArray(itemArray:NSMutableArray){
        NSUbiquitousKeyValueStore.default.set(itemArray, forKey: "itemArray")//This will save the array to icloud so we can use it later.
    }
    func getItemArray()->NSMutableArray{
        return NSUbiquitousKeyValueStore.default.array(forKey: "itemArray") as! NSMutableArray
    } //This is going to get the item array from iCloud.
    func saveDictionary(dictionary:[String:String]){
        NSUbiquitousKeyValueStore.default.set(dictionary, forKey: "itemDictionary")
    }
    func getDictionary()->[String:String]{
        return NSUbiquitousKeyValueStore.default.dictionary(forKey: "itemDictionary") as! [String: String]
    }
    func setUpDone()->Bool{
        return NSUbiquitousKeyValueStore.default.bool(forKey: "setup")
    }
    func setupFinished(){ //When this is called it is registered that the setup has officially been completed...
        print("Finished")
        NSUbiquitousKeyValueStore.default.set(true, forKey: "setup")
    }
    //Coming for customization later...
    func setUserFirstName(_ firstName:String){
        NSUbiquitousKeyValueStore.default.set(firstName, forKey: "firstName")
    }
    func getUserFirstName() -> String{
        return NSUbiquitousKeyValueStore.default.object(forKey: "firstName") as! String
    }

}
