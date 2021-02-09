//
//  WebViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 5/3/18.
//  Copyright © 2018 Matthew Jagiela. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var webView: WKWebView!
    var productURL:URL = URL(string: "https://google.com")! //Make an empty URL...
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) //This is going to be tracking the progress for the webkit view
        let myRequest = URLRequest(url: productURL)
        webView.load(myRequest) //This is going to load the URL we have provided to the view
        webView.allowsBackForwardNavigationGestures = true //This allows the user to go backwards and forwards using gestures (like the actual safari app)
        webView.navigationDelegate = self //Allows us to tell when the web page finishes loading the view and starts loading so we can handle the progress bar
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { //If the web view has finished loading hide the porogress view
        progressView.isHidden = true;
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { //If the web view has started to load content show the progress view
        progressView.isHidden = false
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) { //Used to tell the estimated progress of the web view
        if(keyPath == "estimatedProgress"){
            progressView.progress = Float(webView.estimatedProgress) //Set the progress view to the estimated progress
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
