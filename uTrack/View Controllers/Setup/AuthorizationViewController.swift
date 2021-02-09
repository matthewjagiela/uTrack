//
//  AuthorizationViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 2/27/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit
import UserNotifications
import MapKit

class AuthorizationViewController: UIViewController {
    
    
    let locationManager = CLLocationManager()
    var locationGranted = false
    var notificationsGranted = true
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func authorizeNotifications(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert,.sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Authorization denied")
            }
            else{
            
            }
        }
        notificationsGranted = true
        let savedData = SavedDataHandler()
        if(locationGranted && notificationsGranted){
            self.performSegue(withIdentifier: "finalSetup", sender: self)
        }
        if(locationGranted && notificationsGranted && savedData.setUpDone()){
            self.performSegue(withIdentifier: "goHome", sender: self) //Go home you're drunk!
        }
    }
    @IBAction func authorizeLocation(_ sender: Any) {
        
        locationManager.requestAlwaysAuthorization()
        locationGranted = true
        let savedData = SavedDataHandler()
        if(locationGranted && notificationsGranted){
            self.performSegue(withIdentifier: "finalSetup", sender: self)
        }
        if(locationGranted && notificationsGranted && savedData.setUpDone()){
            self.performSegue(withIdentifier: "goHome", sender: self) //Go home you're drunk!
        }
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var shouldAutorotate: Bool { //I do not want this view to rotate
        return false
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
