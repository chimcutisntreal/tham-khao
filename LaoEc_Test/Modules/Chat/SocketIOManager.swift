//
//  SocketIOManager.swift
//  LaoEc_Test
//
//  Created by MacOne on 11/27/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: "https://laosec-chat.grooo.xyz")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var onConnectData = [Any]()
    //    var messages : [ChatMessage] = [ChatMessage]()
    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
        print("Connected to Socket !")
    }
    
    
    func closeConnection() {
        socket.disconnect()
        print("Disconnected from Socket !")
    }
    
    
    func emitConnectChannel(client_id: Int){
        let value = [UserDefaults.standard.string(forKey: "token")!,2,client_id] as [Any]
        socket.emit(SocketConstants.keyConnectChannel, with: value)
        print("Sending Message: \(value)")
    }
    
    func onConnectChannel(){
        socket?.on(SocketConstants.keyConnectChannel) {(dataArray, ack)->Void in
            NotificationCenter.default.removeObserver(self, name: .OnConnectChannel, object: dataArray)
            NotificationCenter.default.post(name: .OnConnectChannel, object: dataArray)
        }
        
    }
    
    func emitSendMessage(channel_id: String, message: String){
        let value = [UserDefaults.standard.string(forKey: "token")!,channel_id,message] as [Any]
        socket.emit(SocketConstants.keySendMessage, with: value)
        print("Sending Message: \(value)")
    }
    
    func onSendMessage(){
        socket?.on(SocketConstants.keySendMessage) {(dataArray, ack)->Void in
            NotificationCenter.default.removeObserver(self, name: .OnSendMessage, object: dataArray)
            NotificationCenter.default.post(name: .OnSendMessage, object: dataArray)
            print("received \(dataArray)")
        }
    }
    
    func sendMessageSuccess(){
        socket?.on(SocketConstants.keySendMessageSuccess) {(dataArray, ack)->Void in
            NotificationCenter.default.post(name: .SendMessageSuccess, object: dataArray)
        }
    }
    
    func isReadAllMessage(){
        socket?.on(SocketConstants.keyReadAll) {(dataArray, ack)->Void in
            NotificationCenter.default.post(name: .ReadAllMessage, object: dataArray)
        }
    }
    
    func disconnect(){
        socket.emit(SocketConstants.keyDisconnect)
    }
    
    func reconnect(){
        socket?.emit(SocketConstants.keyReconnect)
    }
    
    func reconnectError(){
        socket?.emit(SocketConstants.keyReconnectError)
    }
    
    func removeEvent(){
        socket?.off(SocketConstants.keyConnectChannel)
        socket?.off(SocketConstants.keySendMessage)
        socket?.off(SocketConstants.keyReadAll)
        socket?.off(SocketConstants.keySendMessageSuccess)
    }
    
    
}
