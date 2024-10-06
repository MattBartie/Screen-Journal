//
//  ViewController.swift
//  Quick Screen Journal
//
//  Created by Matt Bartie on 8/28/24.
//

import UIKit

class YourViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
   
    
    @objc func appWillEnterForeground() {
     
    }
    
    
    func reloadContentView() {
        
    }
    
    
    deinit {
        // Remove observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
}
