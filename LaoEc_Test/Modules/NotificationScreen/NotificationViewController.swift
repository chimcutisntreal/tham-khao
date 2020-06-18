//
//  NotificationViewController.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/19/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    @IBOutlet weak var gotoChat: UIButton!
    
    @IBAction func pressOnGotoChat(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
        navigationController?.pushViewController(chatVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
