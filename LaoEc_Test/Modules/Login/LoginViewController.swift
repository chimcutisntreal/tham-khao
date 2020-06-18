//
//  LoginViewController.swift
//  LaoEc_Test
//
//  Created by MacOne on 11/15/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var btnLoginWith: UIButton!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var password: UITextField!
    
    var isEmail = false
    let btnFlag = UIButton(type: .custom)
    var isRootView : Bool!
    var isNoti: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavCancel()
        setupLoginWith()
        setupUser()
        setupFlag()
        setupPassword()
        setupSignIn()
        
    }
    
    func setupLoginWith(){
        btnLoginWith.setupRadius()
    }
    
    func setupSignIn(){
        btnSignIn.backgroundColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
        btnSignIn.tintColor = .white
        btnSignIn.setupRadius()
    }
    
    func setupPassword(){
        let keyView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let key = UIImageView(image: UIImage(named: "key"))
        key.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        keyView.addSubview(key)
        password.leftView = keyView
        password.leftViewMode = .always
        password.placeholder = "Password"
    }
    
    func setupFlag(){
        btnFlag.setImage(UIImage(named: "laos_flag"), for: .normal)
        btnFlag.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnFlag.addTarget(self, action: #selector(self.pressOnFlag), for: .touchUpInside)
        btnFlag.frame = CGRect(x: user.frame.width - 50, y: 0, width: 50, height: user.frame.height)
        btnFlag.setupLeftBorder(color: UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1), width: 0.5)
        user.rightView = btnFlag
        user.rightViewMode = .always
    }
    
    func setupUser(){
        if(isEmail) {
            user.placeholder = "Email"
            btnFlag.isHidden = true
            user.keyboardType = .default
            user.reloadInputViews()
            isEmail = true
        } else {
            user.placeholder = "Telephone number"
            btnFlag.isHidden = false
            user.keyboardType = .phonePad
            user.reloadInputViews()
            isEmail = false
        }
    }
    
    
    @objc func pressOnFlag(_ sender: Any) {
        print("flag")
    }
    
    @IBAction func pressOnLoginWith(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Use Email", style: .default, handler: {action in
            self.isEmail = true
            self.setupUser()
        }))
        alert.addAction(UIAlertAction(title: "Use Phone Number", style: .default, handler: {action in
            self.isEmail = false
            self.setupUser()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert,animated: true)
    }
    
    
    @IBAction func pressOnSignIn(_ sender: Any) {
        alert()
    }
    
    @IBAction func pressOnCancel(_ sender: Any) {
        navigateCancel()
    }
    
    @IBAction func pressOnForgot(_ sender: Any) {
        
    }
    @IBAction func pressOnCreate(_ sender: Any) {
    }
    
    func alert(){
        //check sign in id nil
        if (user.text == "") {
            let alert = UIAlertController(title: "Please enter your Sign in ID", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert,animated: true)
        } else if (password.text?.count ?? 0 < 8) { //check password requires
            let alert = UIAlertController(title: "The password must be at least 8 characters", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert,animated: true)
        } else { //all requirements are OK
            checkLogin()
        }
    }
    
    func checkLogin(){
        let dataTobeSent = AuthLogin(phone: user.text!, password: password.text!)
        let postRequest = LoginRequest()
        postRequest.sendData(dataTobeSent, completion: {result in
            switch result {
            case .success(let success):
                UserDefaults.standard.set(success.token, forKey: "token")
                UserDefaults.standard.set(success.profile.id, forKey: "clientID")
//                SocketIOManager.sharedInstance.establishConnection()
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            case .failure(let error):
                print("error \(error)")
                let alert = UIAlertController(title: "Your phone number or email is not matched", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert,animated: true)
                }
            }
        })
    }
    
    func navigateCancel(){
        if isRootView == true {
            let navToRoot = UINavigationController(rootViewController: TabBarController())
            navToRoot.modalPresentationStyle = .currentContext
            self.navigationController?.present(navToRoot, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
