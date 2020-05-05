//
//  ItemInfoViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 4/23/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit

class ItemInfoViewController: UIViewController {
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var onlineStatus: UILabel!
    @IBOutlet var nearbyStatus: UILabel!
    var checkStock = CheckStock()
    let savedData = SavedDataHandler()
    var itemName = ""
    var itemImage:UIImage = UIImage()
    var checkTimer:Timer!
    

    override func viewWillAppear(_ animated: Bool) {
        itemName = UserDefaults.standard.object(forKey: "selectedCell") as! String
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            
        }
        var itemDictionary = savedData.getDictionary()
        checkStock = CheckStock(link: itemDictionary[itemName]!)
        checkStock.fillData()
        self.title = itemName
        self.tabBarController?.navigationItem.title = itemName
        nameLabel.text = itemName
        productImage.contentMode = .scaleAspectFit
        productImage.image = UIImage(named: "\(itemName).png")
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareInformation))
        self.tabBarController?.navigationItem.setRightBarButton(share, animated: false)
        
    }
    @objc func shareInformation(){ //Share the info to social media
        var activityViewController:UIActivityViewController
        if(checkStock.isItemInStock()){
             activityViewController = UIActivityViewController(activityItems: ["\(itemName) is in stock online. Checked using uTrack for iOS"], applicationActivities: nil)
        }
        else{
            activityViewController = UIActivityViewController(activityItems: ["\(itemName) is not in stock online. Checked using uTrack for iOS"], applicationActivities: nil)
        }
        
        
        let items = self.tabBarController?.navigationItem.rightBarButtonItems
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = items?[0]
        }
        present(activityViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        onlineStatus.text = "Checking..."
        nearbyStatus.text = "Coming Soon..."
        // Do any additional setup after loading the view.
         checkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkRows), userInfo: nil, repeats: true)
    }
    @objc func checkRows(){
        print("checkRows Called")
        if (checkStock.getAmountOfRows() != 0){
            checkTimer.invalidate()
            if(checkStock.isItemInStock()){
                print("The item is in stock")
                onlineStatus.textColor = .green
                onlineStatus.text = "In Stock"
            }
            else{
                onlineStatus.textColor = .red
                onlineStatus.text = "Out Of Stock"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
