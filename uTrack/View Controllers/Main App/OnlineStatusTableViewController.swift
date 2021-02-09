//
//  OnlineStatusTableViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 4/25/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit

class OnlineStatusTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let itemInfo = ItemInfoViewController()
    let itemHandler = ItemHandler()
    let savedData = SavedDataHandler()
    var checkStock = CheckStock()
    var inStockOnly = true //In Stock Only Filter On By Default
    var itemName = ""
    var checkTimer:Timer!
    lazy var selectedIndex = 0

    
    @IBOutlet var filterResultsButton: UIButton!
    @IBOutlet var indicatorView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var onlineTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        print("Online Status Will Appear")
        itemName = UserDefaults.standard.string(forKey: "selectedCell")!//Get the specific key for the item we are going to be searching
        var dictionary = savedData.getDictionary()
        checkStock = CheckStock(link: dictionary[itemName]!) //This is going to pass the link into the check stock handler....
        indicatorView.isHidden = false
        onlineTableView.isScrollEnabled = false
        onlineTableView.allowsSelection = false
        checkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkRows), userInfo: nil, repeats: true) //Because it might take an extra second to download we are going to wait to populate the table...
        
        onlineTableView.delegate = self
        onlineTableView.dataSource = self
        onlineTableView.rowHeight = 111
        filterResultsButton.setTitle("Filter Results: In Stock Only", for: .normal)
        self.tabBarController?.navigationItem.rightBarButtonItems = []
        
    }
    
    
    @IBAction func changeFilter(_ sender: Any) { //This is used to have the filter change to either all items OR just in stock items
        let alert = UIAlertController(title: "Filter", message: "Choose A Filter", preferredStyle: .actionSheet) //make an action sheet for it
        alert.addAction(UIAlertAction(title: "In Stock Only (Default)", style: .default, handler: {_ in
            self.inStockOnly = true
            self.filterResultsButton.setTitle("Filter Results: In Stock Only", for: .normal)
            self.onlineTableView.reloadData()
        })) 
        alert.addAction(UIAlertAction(title: "All Stores", style: .default, handler: {_ in
            self.inStockOnly = false
            self.filterResultsButton.setTitle("Filter Results: All Stores", for: .normal)
            self.onlineTableView.reloadData()
            
        }))
        if let popoverController = alert.popoverPresentationController { //For iPad it needs to present as a popover so we need to make one!!
            popoverController.sourceView = sender as! UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        self.present(alert, animated: true , completion: nil) //Present the actual alert
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
    }
    
    
    @objc func checkRows(){
        print("checkRows called")
        if(checkStock.getAmountOfRows() != 0){
            checkTimer.invalidate()
            print("reloading table")
            onlineTableView.reloadData()
            indicatorView.isHidden = true
            onlineTableView.isScrollEnabled = true
            onlineTableView.allowsSelection = true
        }
        else{
            
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("reloaded")
        print("TABLE VIEW = There are \(checkStock.getAmountOfRows()) rows")
    
        if(inStockOnly){
            print("there should be \(checkStock.getInStockOnlyRows()) cells")
            return checkStock.getInStockOnlyRows()
        }
        else{
            return checkStock.getAmountOfRows()
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onlineStockCell", for: indexPath) as! InStockTableViewCell

        // Configure the cell...
        if(inStockOnly){
            cell.storeLogo.image = determineImage(storeName: checkStock.getInStockName(indexPath.row))
            cell.storeLogo.contentMode = .scaleAspectFit
            cell.storeName.text = checkStock.getInStockName(indexPath.row)
            cell.statusImage.image = UIImage(named:"Checkmark.png")
        }
        else{
            cell.storeLogo.image = determineImage(storeName: checkStock.getWebsiteName(indexPath.row))
            cell.storeLogo.contentMode = .scaleAspectFit
            cell.storeName.text = checkStock.getWebsiteName(indexPath.row)
            
            if(checkStock.getItemStatus(indexPath.row)){
                cell.statusImage.image = UIImage(named:"Checkmark.png")
            }
            else{
                cell.statusImage.image = UIImage(named:"X Icon.png")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "loadWeb", sender: nil)
    }
    func determineImage(storeName:String) -> UIImage{ //This will find the image for the stores... If one has not been provided the default app icon is displayed.
        if(storeName.contains("Amazon")){
            return UIImage(named: "Amazon")!
        }
        else if(storeName.contains("B&H")){
            return UIImage(named:"B&H")!
        }
        else if(storeName.contains("Best Buy")){
            return UIImage(named: "Best Buy")!
        }
        else if(storeName.contains("Microsoft")){
            return UIImage(named:"Microsoft")!
        }
        else if(storeName.contains("Newegg")){
            return UIImage(named:"Newegg")!
        }
        else if(storeName.contains("GameStop")){
            return UIImage(named: "Gamestop")!
        }
        else{
            return UIImage(named:"Stock Image")!
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "loadWeb"{
            let webView = segue.destination as! WebViewController
            if(inStockOnly){
                webView.productURL = checkStock.getInStockLink(selectedIndex)
            }
            else{
                webView.productURL = checkStock.getLink(selectedIndex)
            }
            
        }
    }
    

}
