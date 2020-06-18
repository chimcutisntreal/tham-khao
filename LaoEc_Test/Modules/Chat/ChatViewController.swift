//
//  ChatViewController.swift
//  LaoEc_Test
//
//  Created by MacOne on 11/25/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import UIKit
import SocketIO


class ChatViewController: UIViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let leftCellID = "leftCell"
    let rightCellID = "rightCell"
    
    var languadeCode = GetLanguageChanged()
    var messages = [String:[HistoryMessage]]()
    var dateArray = [String]()
    var myMessage: HistoryMessage!
    var senderMessage: HistoryMessage!
    var senderAvatar = UIImage(named: "avatar")
    
    
    var readIndexPath = IndexPath()
    var unreadIndexPath = IndexPath()
    var status = [UIImage(named: "status_send"),UIImage(named: "status_sent")]
    var currentRead = false
    var keyboardHeight : CGFloat!
    var originHeight : CGFloat!
    var isSent = false
    var myMessages = HistoryMessages()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = ProductDetailValue.sharedInstance.senderName
        register()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        loading.startAnimating()
        
        loadImages()
        originHeight = bottomConstraint.constant
        notiToHideKeyboard()
        //        disconnect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        waitForLoading()
        onConnectChannel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onSendMessage()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.sharedInstance.removeEvent()
        SocketIOManager.sharedInstance.disconnect()
    }
    
    func register(){
        chatTableView.register(RightChatCell.self, forCellReuseIdentifier: rightCellID)
        chatTableView.register(LeftChatCell.self, forCellReuseIdentifier: leftCellID)
        chatTableView.register(UINib(nibName: "RightChatCell", bundle: nil), forCellReuseIdentifier: rightCellID)
        chatTableView.register(UINib(nibName: "LeftChatCell", bundle: nil), forCellReuseIdentifier: leftCellID)
    }
    
    lazy var messageInputView: InputAccessoryView! = {
        let footerView = InputAccessoryView.inputAccessoryView(target: self, action: #selector(sendMessage))
        return footerView
    }()
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return self.messageInputView
    }
    
    
    @objc func sendMessage() {
        //get message from textview
        if let text = self.messageInputView.textView.text {
            let messageText =  text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.messageInputView.textView.text = ""
            self.messageInputView.textViewDidChange(messageInputView.textView)
            saveMyMessage(message: messageText)
            SocketIOManager.sharedInstance.emitSendMessage(channel_id: SocketValue.channelID, message: messageText)
            sendMessageSuccess()
        }
    }
}

extension ChatViewController { //Communicate with socket manager
    
    func onConnectChannel(){
        SocketIOManager.sharedInstance.onConnectChannel()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveConnectChannel), name: .OnConnectChannel, object: nil)
    }
    
    @objc func receiveConnectChannel(_ notification: Notification){
        let received = notification.object as! [Any]
        SocketValue.channelID = received[0] as! String
        SocketValue.historyMessage = parseHistories(data: received[1])
    }
    
    func onSendMessage(){
        SocketIOManager.sharedInstance.onSendMessage()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveSendMessage), name: .OnSendMessage, object: nil)
        
    }
    @objc func receiveSendMessage(_ notification: Notification){
        let received = notification.object as! [Any]
        senderMessage = HistoryMessage(clientID: received[3] as! Int, createdAt: getDateTime(), isRead: 0, message: received[2] as! String, type: 1)
        saveSenderMessage()
        
    }
    func sendMessageSuccess(){
        SocketIOManager.sharedInstance.sendMessageSuccess()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessageSuccess), name: .SendMessageSuccess, object: nil)
    }
    
    @objc func receiveMessageSuccess(_ notification: Notification) {
        let received = notification.object as! [Any]
        if (!received.isEmpty){
            
            let successMessage = parseSuccessMessage(data: received)
            SocketValue.successMessage = successMessage[0]
            checkMessageStatus()
        }
    }
    
    func disconnect(){
        SocketIOManager.sharedInstance.disconnect()
        NotificationCenter.default.addObserver(self, selector: #selector(onDisconnect), name: .Disconnect, object: nil)
    }
    
    @objc func onDisconnect(_ notification: Notification) {
        self.notiAlert(title: "Can not connect to server. Please check your internet", message: nil)
    }
}

extension ChatViewController {
    func checkMessageStatus(){
        SocketValue.historyMessage[SocketValue.historyMessage.count-1].isSending = false
        if (SocketValue.successMessage.message == SocketValue.myMessage.message) {
            if(SocketValue.successMessage.isRead==1){
                SocketValue.myMessage.isRead = 1
                SocketValue.historyMessage.removeLast()
                SocketValue.historyMessage.append(SocketValue.myMessage)
            }
        }
        filterData()
    }
    func waitForLoading(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if(!SocketValue.historyMessage.isEmpty){
                self.filterData()
                self.getKeyboardHeight()
            } else {
                self.notiAlert(title: "Request Timeout", message: "Check your connection!!!")
            }
            self.loading.removeFromSuperview()
        }
    }
    
    func reloadLastRow(){
        let numberOfRows = chatTableView.numberOfRows(inSection: chatTableView.numberOfSections - 1) - 1
        guard numberOfRows >= 0 else { return }
        let indexPath = IndexPath(row: numberOfRows, section: self.chatTableView.numberOfSections - 1)
        self.chatTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func scrollToBottom(animated: Bool = true, delay: Double = 0.0) {
        let numberOfRows = chatTableView.numberOfRows(inSection: chatTableView.numberOfSections - 1) - 1
        guard numberOfRows >= 0 else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            let indexPath = IndexPath(row: numberOfRows, section: self.chatTableView.numberOfSections - 1)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func filterDate() -> [String]{
        var date = [String]()
        for i in SocketValue.historyMessage {
            date.append(i.createdAt.take(from: 0, to: -9))
        }
        date.removeDuplicates()
        return date
    }
    
    func filterData(){
        var message = [HistoryMessage]()
        for i in filterDate() {
            for j in SocketValue.historyMessage {
                if i == j.createdAt.take(from: 0, to: -9) {
                    message.append(j)
                    messages.updateValue(message, forKey: i)
                }
            }
            message.removeAll()
        }
        self.dateArray = Array(messages.keys).sorted(by: <)
        
        readIndex()
    }
    
    func saveMyMessage(message: String){
        myMessage = HistoryMessage(clientID: SocketValue.clientID, createdAt: getDateTime(), isRead: 0, message: message, type: 1,isSending: true)
        SocketValue.myMessage = myMessage
        SocketValue.historyMessage.append(myMessage)
        filterData()
    }
    
    func saveSenderMessage(){
        SocketValue.historyMessage.append(senderMessage)
        filterData()
    }
    
    func readIndex(){
        var readRow = Int()
        var readSection = Int()
        for i in dateArray {
            if let index = messages[i]?.lastIndex(where: {$0.isRead == 1}) {
                readRow = index
                readSection = dateArray.lastIndex(of: i)!
            }
        }
        readIndexPath = IndexPath(row: readRow, section: readSection)
        print(readIndexPath)
        chatTableView.reloadData()
        self.scrollToBottom()
    }
    
    func checkDate() -> [String]{
        var date = dateArray
        if let index = date.lastIndex(of: getDate()) {
            date[index] = LanguageData.sharedInstance.today["\(languadeCode)"]!
        }
        return date
    }
    
    func getDateTime() -> String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = dateFormatter.string(from: currentDate)
        return now
    }
    
    func getDate()->String{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: currentDate)
        return now
    }
    
    func loadImages(){
        ImageService.getImage(withURL: URLToRequest.init(string: ProductDetailValue.sharedInstance.senderAvatar ?? "").urlImage) { image in
            self.senderAvatar = image ?? UIImage(named: "avatar")!
        }
    }
}

extension ChatViewController { //Keyboard manager
    
    func notiToHideKeyboard(){
        NotificationCenter.default.addObserver(self,selector: #selector(hideKeyboard),name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func hideKeyboard(){
        self.chatTableView.keyboardDismissMode = .interactive
        self.bottomConstraint.constant = self.originHeight
        self.chatTableView.layoutIfNeeded()
        self.scrollToBottom()
    }
    
    public func getKeyboardHeight(){
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            originHeight = bottomConstraint.constant
            bottomConstraint.constant = keyboardHeight
            UIView.animate(withDuration: 0.3, animations: {
                self.chatTableView.layoutIfNeeded()
            })
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[dateArray[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mess = messages[dateArray[indexPath.section]]![indexPath.row]
        if SocketValue.senderID == mess.clientID { //left
            let cell = tableView.dequeueReusableCell(withIdentifier: leftCellID, for: indexPath) as! LeftChatCell
            cell.message.text = mess.message
            cell.time.text = mess.createdAt.take(from: 10, to: -3)
            cell.avatar.image = senderAvatar
            return cell
        } else { //right
            let cell = tableView.dequeueReusableCell(withIdentifier: rightCellID, for: indexPath) as! RightChatCell
            cell.message.text = mess.message
            cell.time.text = mess.createdAt.take(from: 10, to: -3)
            cell.status.alpha = 0
            if indexPath == readIndexPath {
                cell.status.alpha = 1
                cell.status.image = senderAvatar
            } else if (indexPath > readIndexPath) {
                if mess.isSending == true {
                    cell.status.alpha = 1
                    cell.status.image = status[0]
                } else {
                    cell.status.alpha = 1
                    cell.status.image = status[1]
                }
            }
            return cell
        }
    }
}

extension ChatViewController: UITableViewDelegate {
    //HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        let title = UILabel()
        let date = checkDate()
        title.text = date[section]
        title.setupMessageHeader(view: self.view)
        view.addSubview(title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath:IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
}





