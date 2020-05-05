//
//  MainCollectionViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 4/17/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit
private let reuseIdentifier = "itemCell"
var editing = false
@available(iOS 11.0, *)
class MainCollectionViewController: UICollectionViewController {
    
    let savedData = SavedDataHandler()
    var selectedRow = 0
    var keys:Array = [""]
    @IBOutlet var itemImageTest: UIImageView!


    var columnLayout = FlowLayout(
        cellsPerRow: 3,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        //NSUbiquitousKeyValueStore.default.set(false, forKey: "setup")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editGrid))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        keys = getKeys()
        // Do any additional setup after loading the view.
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        print("Turning the background to black...")
        NotificationCenter.default.addObserver(self, selector: #selector(iCloudUpdate(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default) //This is going to be constantly looking for changes from iCloud... When one happens the iCloudUpdate method will be called.
       
        
       
    }
    @objc func iCloudUpdate(notification:NSNotification){
        print("iCloud Update")
        keys = getKeys()
        collectionView?.reloadData()
    }
    
    @objc func editGrid(){
        print("Editing the grid")
        self.performSegue(withIdentifier: "editItems", sender: self)
    }
    
    func isEditing()->Bool{
        return editing
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getKeys()-> Array<String>{ //This will return the array of keys from the dictionary so we can put it into the grid easier
        let unsortedKeys = Array(savedData.getDictionary().keys) //Make all of the keys an array
        let sortedKeys = unsortedKeys.sorted() //Sort the array by name
        return Array(sortedKeys) //Return the sorted array of keys
    }

    
    // MARK: - Navigation
/**
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "itemSelected" {
            let destinationViewController = segue.destination as! ItemInfoViewController
            let keys = getKeys()
            destinationViewController.itemName = keys[selectedRow]
        }
    }
    **/

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return savedData.getDictionary().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackedItemCollectionViewCell//This is our custom cell for the grid... The class devleration is above for the cell
    
        // Configure the cell
        cell.itemImage.image = UIImage(named: "\(keys[indexPath.row]).png")
        cell.itemImage.contentMode = .scaleAspectFit
        cell.itemName.text = "\(keys[indexPath.row])"
        
        
        
        
        //Add the gesture to the cell
        return cell
    }

    @objc func deleteCell(sender:UIButton) {
        let item : String = (sender.layer.value(forKey: "item")) as! String
        print("Delete \(item) from the index...")
        let items = ItemHandler()
        items.removeFromDictionary(item: item)
        self.collectionView?.reloadData()
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        UserDefaults.standard.set(keys[indexPath.row], forKey: "selectedCell")
        self.performSegue(withIdentifier: "itemSelected", sender: self)
        
        
        return true
    }
 
    override func prefersHomeIndicatorAutoHidden() -> Bool { //This way the label in the grid does not get cut off of by the iPhone X bar...
        return false
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
