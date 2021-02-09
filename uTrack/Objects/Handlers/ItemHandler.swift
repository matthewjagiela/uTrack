//
//  ItemHandler.swift
//  uTrack
//
//  Created by Matthew Jagiela on 2/25/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit

class ItemHandler: NSObject {
    
    var selectedItems = [String: String]()
    var savedData = SavedDataHandler()
    var potentialItems = ["Airpods","Xbox One X","PlayStation 4","Nintendo Switch","SNES Classic Edition","NVIDIA GTX 1050","NVIDIA GTX 1050TI","NVIDIA GTX 1060","NVIDIA GTX 1070","NVIDIA GTX 1070TI","NVIDIA GTX 1080", "NVIDIA GTX 1080TI"]
    var potentialItemsLinks = ["https://www.nowinstock.net/electronics/headphones/apple/","https://www.nowinstock.net/videogaming/consoles/xboxonex/","https://www.nowinstock.net/videogaming/consoles/ps4/","https://www.nowinstock.net/videogaming/consoles/nintendoswitch/","https://www.nowinstock.net/videogaming/consoles/nintendosnesclassicedition/","https://www.nowinstock.net/computers/videocards/nvidia/gtx1050/","https://www.nowinstock.net/computers/videocards/nvidia/gtx1050ti/","https://www.nowinstock.net/computers/videocards/nvidia/gtx1060/","https://www.nowinstock.net/computers/videocards/nvidia/gtx1070/","https://www.nowinstock.net/computers/videocards/nvidia/gtx1070ti/","https://www.nowinstock.net/computers/videocards/nvidia/gtx1080/", "https://www.nowinstock.net/computers/videocards/nvidia/gtx1080ti/"]
    let customItems = NSMutableArray()

    func addToDictionary(item:String, link:String){
        print("Adding link: \(link)")
        selectedItems[item] = link
        savedData.saveDictionary(dictionary: selectedItems)
    }
    func removeFromDictionary(item:String){
        selectedItems.removeValue(forKey: item)
        savedData.saveDictionary(dictionary: selectedItems)
    }
    func getPotentialItems()->Array<String>{
        return potentialItems
    }
    func getPotentialItemsLinks()->Array<String>{
        return potentialItemsLinks
    }
    func getItemLink(_ item:String) ->String{
       var itemDictionary = savedData.getDictionary()
        return (itemDictionary[item] as! String)
    }
    
}
