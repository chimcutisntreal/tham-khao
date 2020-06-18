//
//  MeViewController.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/19/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var btnSign: UIButton!
    
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var checkLoginView: UIView!
    let languages = ["English","Tiếng Việt","Laos","French","Thailand","Chinese"]
    let languagesCode = ["us","vn","la","fr","th","cn"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkSession()
    }
    
    func checkSession(){
        if UserDefaults.standard.string(forKey: "token") != nil {
            checkLoginView.isHidden = true
        } else {
            checkLoginView.isHidden = false
        }
    }
    @IBAction func pressOnLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "clientID")
        SocketIOManager.sharedInstance.closeConnection()
        checkLoginView.isHidden = false
    }
    
    func customBtnSign(){
        btnSign.backgroundColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
    }
    
    @IBAction func pressOnSign(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        loginVC.isRootView = false
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension MeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
        return cell
    }
}

extension MeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let navToRoot = UINavigationController(rootViewController: TabBarController())
        navToRoot.modalPresentationStyle = .currentContext
        setLanguageChanged(value: languagesCode[indexPath.row])
        self.navigationController?.present(navToRoot, animated: true, completion: nil)
        
    }
}
