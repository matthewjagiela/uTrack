//
//  SetupProfileViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 2/26/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit



class SetupProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var continueButton: UIButton!
    let savedData = SavedDataHandler()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Hide these on launch:
        descriptionText.alpha = 0.0
        
        //Disable autolayout constraints for the welcome label:
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = true
        //Alright we want to move the welcome label to the center of the screen:
        welcomeLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        //We are going to use this timer to move the welcome label to the top a second after the app has launched
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.moveWelcome), userInfo: nil, repeats: false)
        continueButton.alpha = 0.0
    }
    @objc func moveWelcome(){ //Move welcome, make objects appear
        UIView.animate(withDuration: 2, animations: { //Animate the movement
            self.welcomeLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.height / 7)
        }) { (moved) in //When it has moved
            UIView.animate(withDuration: 1, animations: { //Animate the appearance of other elements
                self.descriptionText.alpha = 1.0
                self.continueButton.alpha = 1.0
            }, completion: { (shown) in //This doesnt matter
                
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        savedData.setUserFirstName(textField.text!)
        self.performSegue(withIdentifier: "AuthorizationSegue", sender: nil)
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
