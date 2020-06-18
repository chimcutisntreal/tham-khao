//
//  TabBarController.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/19/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
    let notiStoryboard = UIStoryboard(name: "Notification", bundle: nil)
    let meStoryboard = UIStoryboard(name: "Me", bundle: nil)
    var homeVC = UIViewController()
    var notiVC = UIViewController()
    var meVC = UIViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        checkViewLoaded()
        
        homeVC = homeStoryboard.instantiateViewController(withIdentifier: "homevc")
        homeVC.tabBarItem = UITabBarItem(title : "Home",  image :nil,  selectedImage:nil)
        homeVC.tabBarItem.tag = 0

        notiVC.tabBarItem = UITabBarItem(title : "Notification",  image :nil,  selectedImage:nil)
        notiVC.tabBarItem.tag = 1
        
        meVC = meStoryboard.instantiateViewController(withIdentifier: "mevc")
        meVC.tabBarItem = UITabBarItem(title:"Me", image: nil, selectedImage: nil)
        meVC.tabBarItem.tag = 2
        
        viewControllers = [homeVC,notiVC,meVC]
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            checkSession()
        }
    }
    
    func checkSession() {
        if UserDefaults.standard.string(forKey: "token") == nil {
           navigateToLogin()
        }
    }
    
    func checkViewLoaded(){
        if UserDefaults.standard.string(forKey: "token") != nil {
            notiVC = notiStoryboard.instantiateViewController(withIdentifier: "notivc")
        }
    }
    
    func navigateToLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        loginVC.isRootView = true
//        self.present(loginVC, animated: true, completion: nil)
//        navigationController?.present(loginVC, animated: true, completion: nil)
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
}
