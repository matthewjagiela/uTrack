//
//  PresetItemsTableViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 4/4/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit

class PresetItemsTableViewController: UITableViewController {
    
    var potentialItems:Array<String> = []
    var potentialItemsLinks = [""]
    let itemHandler = ItemHandler()
    let savedData = SavedDataHandler()
    var itemDict = [String:String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.hidesBackButton = true
        self.title = "Select An Item"
        potentialItems = itemHandler.getPotentialItems()
        potentialItemsLinks = itemHandler.getPotentialItemsLinks()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneSelecting))

        if(savedData.setUpDone()){
            itemDict = savedData.getDictionary()
        }
        
    }
    @objc func doneSelecting(){ //We need to save the selected items 
        print("Done Selecting")
        saveData()
        savedData.setupFinished()
        printDictionary()
        self.performSegue(withIdentifier: "Done Selecting", sender: nil)
    }
    func printDictionary(){
        let savedData = SavedDataHandler()
        let keys = savedData.getDictionary().keys
        let values = savedData.getDictionary().values
        for key in keys{
            print("Key : \(key)")
        }
        for value in values{
            print("Value : \(value)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return potentialItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "potentialItem", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = potentialItems[indexPath.row]
        if(savedData.setUpDone()){
            if(itemDict[potentialItems[indexPath.row]] != nil){
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            if(cell.accessoryType == .checkmark){ //Deselecting the row... do not search for it...
                cell.accessoryType = .none
                
                //itemHandler.removeFromDictionary(item:(cell.textLabel?.text)!)
                
            }
            else{
                cell.accessoryType = .checkmark //Selecting the row... we want to search for this item.
                //itemHandler.addToDictionary(item: (cell.textLabel?.text)!,link: potentialItemsLinks[indexPath.row])
            }
        }
    }
    func saveData(){
        let cells = tableView.visibleCells
        for (index, element) in cells.enumerated(){
            if element.accessoryType == .checkmark{
                itemHandler.addToDictionary(item: (element.textLabel?.text)!, link: potentialItemsLinks[index])
            }
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
