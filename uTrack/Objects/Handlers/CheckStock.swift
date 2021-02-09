//
//  CheckStock.swift
//  uTrack
//
//  Created by Matthew Jagiela on 4/24/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit
import SwiftSoup

class CheckStock: NSObject {
    var dictionary = [String: String]()
    var keys = [""]
    let savedData  = SavedDataHandler()
    let itemHandler = ItemHandler()
    var amountOfRows = 0//This is going to store the raw table data
    var itemDataRows = NSMutableArray() //This is going to store each individual row
    var nameTracker = 0 //track of the name array indices
    var link = "" //The link to be used later
    var nameArray:NSMutableArray = []
    var statusArray:NSMutableArray = []
    var lastInStockArray:NSMutableArray = []
    var lastPriceArray:NSMutableArray = []
    var linkArray:NSMutableArray = []
    var inStockNameArray:NSMutableArray = []
    var inStockStatusArray:NSMutableArray = []
    var inStockLinkArray:NSMutableArray = []
    override init() {
        super.init()
    }
    init(link: String) {
        super.init()
        dictionary = savedData.getDictionary()
        keys = Array(dictionary.keys)
        self.link = link
        self.fillData()
        
        
    }
    func fillData(){ //We need to fetch and format the table
        let nameLocalArray:NSMutableArray = []
        let statusLocalArray:NSMutableArray = []
        let lastInStockLocalArray:NSMutableArray = []
        let lastPriceLocalArray:NSMutableArray = []
        let linkLocalArray:NSMutableArray = []
        print("called fillData")
        let url = URL(string: link)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print (error?.localizedDescription ?? "error description not found")
            }
            else {
                if let unwrappedData = data {
                    if let htmlContentString = String.init(data: unwrappedData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        do{
                            //
                            let doc : Document = try SwiftSoup.parse(htmlContentString)
                            //
                            let tableBody = try doc.select("tbody").first()
                            let links = try tableBody?.select("a").array()
                            for link in links!{
                                linkLocalArray.add(try link.attr("href"))
                            }
                            let tableData = (try tableBody?.select("tr").array())!
                            self.amountOfRows = tableData.count - 1
                            print("amountOfRows = \(self.amountOfRows)")
                            for rowElement in tableData{
                                let element = try rowElement.text()
                                print("Element = \(element)")
                                self.itemDataRows.add(element)
                                print("itemDataRows Count = \(self.itemDataRows.count)")
                                let rowEntries = try rowElement.select("td").array()
                                
                                
                                print("the amount of rowEntries is \(rowEntries.count)")
                                
                                if(rowEntries.count != 0){
                                    for index in 0...(rowEntries.count - 1){
                                        var text = try rowEntries[index].text()
                                        print("Adding text: \(text)")
                                        print("index == \(index)")
                                        if(index == 0){ //Name›
                                            if let i = text.firstIndex(of: "("){
                                                text.remove(at: i)
                                            }
                                            if let i = text.firstIndex(of: ")"){
                                                text.remove(at: i)
                                            }
                                            nameLocalArray.add(text)
                                            
                                        }
                                        else if(index == 1){ //Stock Status
                                            //This is adding the plain text of stock status
                                            statusLocalArray.add(text)
                                        }
                                        else if(index == 2){ //Last price
                                            //This is adding the last price that was seen
                                            lastPriceLocalArray.add(text)
                                        }
                                        else if(index == 3){ //Last Stock Date
                                            
                                            lastInStockLocalArray.add(text)
                                        }
                                    }
                                    
                                }
                        
                            }
                            self.saveArrays(nameArray: nameLocalArray, statusArray: statusLocalArray, lastPriceArray: lastPriceLocalArray, lastInStockArray: lastInStockLocalArray, linkArray: linkLocalArray) //Save the local arrays to the global arrays!
                             //Remove the headers from the table!
                        }catch{
                            print(error.localizedDescription)
                        }
                        
                    }
                    else {
                        print("Could not create html content string from data")
                    }
                }
                else {
                    print ("could not unwrapp data object for html content")
                }
            }
        }
        task.resume()
    }
    func saveArrays(nameArray:NSMutableArray, statusArray:NSMutableArray, lastPriceArray:NSMutableArray, lastInStockArray:NSMutableArray, linkArray:NSMutableArray){ //Convert whatever was passed into the global variables
        self.nameArray = nameArray
        self.statusArray = statusArray
        self.lastInStockArray = lastInStockArray
        self.lastPriceArray = lastPriceArray
        self.linkArray = linkArray
        extraFormatting() //I want to remove Ebay because it will always say true for in stock AND doesn't even bring it to a search page
    }
    func extraFormatting(){ //Remove ebay and remove the google group alert notification from the table
        print("extra formatting called")
        if(nameArray.contains(" = Item alerts via Google Group")){
            nameArray.removeObject(at: nameArray.count - 1)
        }
        else if(nameArray.object(at: nameArray.count - 1) as! String).contains("Ebay"){
            nameArray.removeObject(at:nameArray.count - 1)
            statusArray.removeObject(at: statusArray.count - 1)
            lastInStockArray.removeObject(at: lastInStockArray.count - 1)
            lastPriceArray.removeObject(at: lastPriceArray.count - 1)
            linkArray.removeObject(at: linkArray.count - 1)
        }
        else{
            
        }
        
     
    }
    func getAmountOfRows() -> Int{ //The amount of rows that will go into the stock checker table view
        print("Amount of rows (Item Handler) = \(amountOfRows)")
        return nameArray.count
    }
    func getInStockOnlyRows() -> Int{
        if(nameArray.count == 0){
            return 0
        }
        else{
            var amountInStock = 0
            for i in 0...(statusArray.count - 1){
                if(getItemStatus(i)){ //The Item Is In Stock
                    amountInStock += 1
                    inStockNameArray.add(nameArray.object(at: i))
                    inStockStatusArray.add(statusArray.object(at: i))
                    inStockLinkArray.add(linkArray.object(at: i))
                }
            }
            extraFormatting()
            print("There are \(amountInStock) items in stock")
            return amountInStock
        }
    }
    
    //0 = name, 1 = Status, 1 = Status, 2 = Last Price, 3 = Last Stock
    func getWebsiteName(_ index:Int)->String{ //This is going to check the name of the celler at the index
        return nameArray[index] as! String
    }
    func getItemStatus(_ index: Int) ->Bool { //This is going to check the stock status of the cell at the index
        let itemStatus = statusArray[index] as! String
        if(itemStatus.contains("In")){ //The item must be in stock
            return true
        }
        else if(itemStatus.contains("Out")){ //The item must be out of stock
            return false
        }
        return true
    }
    func getListedPrice(_ index:Int) ->String{ //This is going to check the listed price of the cell at the index
        return lastPriceArray[index] as! String
    }
    func getLastInStockDate(_ index:Int) ->String{ //This is going to try and check when the item was last in stock...
        return lastInStockArray[index] as! String
    }
    func getLink(_ index:Int) -> URL{ //This is the link off the product on the specific website it is/isn't in stock for (using for WebKit View)
        print("Get Link: \(linkArray[index] as! String)")
        return URL(string: linkArray[index]as! String)!
    }
    func getInStockName(_ index:Int) ->String{
        return inStockNameArray[index] as! String
    }
    func getInStockLink(_ index: Int) -> URL{
        return URL(string: inStockLinkArray[index] as! String)!
    }
    func isItemInStock() -> Bool{ //Check all of the items to see if it is in stock or not...
        var inStock = false
        print("status array count = \(statusArray.count)")
        for i in 0...(statusArray.count - 1) {
            if(getItemStatus(i)){
                inStock = true
            }
        }
        return inStock
    }
    

}
