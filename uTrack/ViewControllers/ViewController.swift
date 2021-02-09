//
//  ViewController.swift
//  uTrack
//
//  Created by Matthew Jagiela on 2/6/21.
//

import UIKit
import SwiftUI
class ViewController: UIViewController {
    var hostingView: UIHostingController<IntroView>?
    override func viewDidLoad() {
        super.viewDidLoad()
        hostingView = UIHostingController(rootView: IntroView())
        if let hostingView = self.hostingView {
            addChild(hostingView)
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
            hostingView.didMove(toParent: self)
        }
    }
}
