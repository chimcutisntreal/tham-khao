//
//  SocketIOModel.swift
//  LaoEc_Test
//
//  Created by MacOne on 12/2/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation

struct SocketConstants {
    static let keyConnectChannel = "connect-channel"
    static let keySendMessage = "send-message"
    static let keyDisconnect = "disconnect"
    static let keyReconnect = "reconnect"
    static let keyReconnectError = "reconnect_error"
    static let keyToken = "token"
    static let keyConnectType = "connect_type"
    static let keyClientId = "client_id"
    static let keyReadAll = "read-all-message"
    static let keySendMessageSuccess = "send-message-success"
    static let keyConnectionStatus = "connection-status"
    
}

struct SocketValue {
    static var clientID = UserDefaults.standard.integer(forKey: "clientID")
    static var senderID = Int()
    static var channelID = String()
    static var historyMessage = HistoryMessages()
    static var successMessage : SuccessMessage!
    static var myMessage : HistoryMessage!
}

typealias HistoryMessages = [HistoryMessage]
struct HistoryMessage: Codable {
    var clientID: Int
    var createdAt: String
    var isRead: Int
    var message: String
    var type: Int
    var isSending = false
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case createdAt = "created_at"
        case isRead = "is_read"
        case message, type
    }
}

typealias SuccessMessages = [SuccessMessage]

struct SuccessMessage: Codable {
    let channelID: String
    let clientID, isRead, memberID: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case clientID = "client_id"
        case isRead = "is_read"
        case memberID = "member_id"
        case message
    }
}


struct isReadAll {
    let indexPath : IndexPath!
}

struct ChatMember {
    let name: String
    let id: Int
}

//extension HistoryMessage: MessageType {
//    var sender: SenderType {
//        return Sender(senderId: clientID)
//    }
//    
//    var sentDate: Date {
//        return Date()
//    }
//    
//    var kind: MessageKind {
//        return .text(message)
//    }
//}


