//
//  LoadImage.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/15/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation
import UIKit

//GLOBAL
func convertJsonToDictionary(data: String) -> [String:Any]{
    let dataUTF8 = data.data(using: .utf8)!
    var output = [String:Any]()
    do{
        output = try JSONSerialization.jsonObject(with: dataUTF8, options: .allowFragments) as! [String:Any]
    }
    catch {
        print (error)
    }
    return output
}

func parseHistories(data: Any) -> HistoryMessages{
    var output = HistoryMessages()
    do{
        let dataUTF8 = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
        output = try JSONDecoder().decode(HistoryMessages.self, from: dataUTF8)
    }
    catch {
        print (error)
    }
    return output
}

func parseSuccessMessage(data: Any) -> SuccessMessages{
    var output = SuccessMessages()
    do{
        let dataUTF8 = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
        output = try JSONDecoder().decode(SuccessMessages.self, from: dataUTF8)
    }
    catch {
        print (error)
    }
    return output
}

func convertedByLanguage(handler: String) -> String {
    var converted = convertJsonToDictionary(data: handler )["\(GetLanguageChanged())"] as? String
    if (converted == "" || converted == "null" || converted == nil) {
        converted = "updating"
    }
    return converted!
}

extension UIView {
    func setAnchor(top: NSLayoutYAxisAnchor?,left: NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?,right:NSLayoutXAxisAnchor?,paddingTop: CGFloat,paddingLeft:CGFloat,paddingBottom:CGFloat,paddingRight:CGFloat,width: CGFloat = 0,height:CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}

extension UICollectionViewCell {
    func shadowItem(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
        layer.backgroundColor = UIColor.white.cgColor
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
}

extension UIViewController {
    func setupNavBack(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.tintColor = .orange
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupNavCancel(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    func notiAlert(title:String?,message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert,animated: true)
    }
    
}

extension UIButton {
    func setupRadius(){
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        self.layer.cornerRadius = 5
    }
    
    func setupLeftBorder(color: UIColor, width: CGFloat){
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


extension UIColor {
    static var random : UIColor{
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1)
    }
}

extension Notification.Name {
    static var OnConnectChannel: Notification.Name {
        return .init(rawValue: "OnConnectChannel")
    }
    
    static var OnSendMessage: Notification.Name {
        return .init(rawValue: "OnSendMessage")
    }
    static var SendMessageSuccess: Notification.Name {
        return .init(rawValue: "SendMessageSuccess")
    }
    static var ReadAllMessage: Notification.Name {
        return .init(rawValue: "ReadAllMessage")
    }
    static var Disconnect: Notification.Name {
        return .init(rawValue: "Disconnect")
    }
    static var Reconnect: Notification.Name {
        return .init(rawValue: "Reconnect")
    }
}


extension String {
    func take(from: Int, to: Int)-> String{
        let indexStartOfText = self.index(self.startIndex, offsetBy: from)
        let indexEndOfText = self.index(self.endIndex, offsetBy: to)
        let subString = self[indexStartOfText..<indexEndOfText]
        return String(subString)
    }
    
//    func takeToIndex(_ n: Int) -> String {
//        guard n >= 0 else {
//            fatalError("n should never be negative")
//        }
//        let index = self.index(self.startIndex, offsetBy: min(n, self.count))
//        return String(self[..<index])
//    }
}

extension UILabel {
    func setupMessageHeader(view: UIView){
        self.textColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.backgroundColor = .orange
        self.sizeToFit()
        self.center.x = view.center.x
        self.center.y = 25
    }
}

extension UITextView {
    func setupMessage(){
        self.textColor = .white
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 70/255, green: 148/255, blue: 92/255, alpha: 1)
        self.sizeToFit()
    }
    
}

var recentArray = [Int]()

func getRecentView(){
    recentArray = UserDefaults.standard.array(forKey: "recentview") as? [Int] ?? [0]
}
func saveRecentView(id: Int) {
    recentArray.insert(id, at: 0)
    recentArray.removeDuplicates()
    if (recentArray.count > 11) {
        recentArray.removeLast()
    }
    UserDefaults.standard.set(recentArray, forKey: "recentview")
}

let key = "language"
func setLanguageChanged(value: String) {
    UserDefaults.standard.set(value, forKey: key)
}

func GetLanguageChanged() -> String {
    var locale = Locale.current.languageCode
    if locale == "en" {
        locale = "us"
    }
    return UserDefaults.standard.string(forKey: key) ?? locale!
}






