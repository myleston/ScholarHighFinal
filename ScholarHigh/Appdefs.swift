//
//  AppSettings.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/10/27.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//
/*
import Foundation
import Firebase
import MessageKit
import RealmSwift
import Realm

final class AppDefs {
    static var displayName: String! {
        get {
            return UserDefaults.standard.string(forKey: "displayName")
        }
        set {
            let defaults = UserDefaults.standard
            let key = "displayName"
        
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}


class Class: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var day: String = ""
    @objc dynamic var period: Int = 0
    @objc dynamic var teacherName: String = ""
    @objc dynamic var place: String = ""
    @objc dynamic var classID: String = ""
}

extension Class {
    func initialize(title: String, day: String, period: Int, teacherName: String, place: String, classID: String) -> Class {
        self.title = title
        self.day = day
        self.period = period
        self.teacherName = teacherName
        self.place = place
        self.classID = classID
        
        return self
    }
}

extension Class: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "title": self.title,
            "day": self.day,
            "period": self.period,
            "teacherName": self.teacherName,
            "place": self.place,
        ]
        
        return rep
    }
    
}

class Room: Object {
    @objc dynamic var title: String = ""
    var latestTime: Timestamp = Timestamp(date: Date())
    @objc dynamic var roomId: String  = ""
    
    override static func primaryKey() -> String? {
        return "roomId"
    }
}

extension Room {
    func initialize(title: String, latestTime: Timestamp, roomId: String) -> Bool {
        self.title = title
        self.latestTime = latestTime
        self.roomId = roomId
        return true
    }
    
    func initialize(document: QueryDocumentSnapshot) -> Bool {
        let data = document.data()
        
        guard let title = data["title"] as? String else {
            return false
        }
        self.title = title
        
        guard let time = data["latestTime"] as? Timestamp else {
            return false
        }
        self.latestTime = time
        
        self.roomId = document.documentID
        return true
    }
}

extension Room: Comparable {
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.roomId == rhs.roomId
    }
    static func < (lhs: Room, rhs: Room) -> Bool {
        return lhs.latestTime.dateValue() < rhs.latestTime.dateValue()
    }
}

struct Image: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
}

class Message: Object, MessageType {
  
    @objc dynamic var messageId: String = ""
    @objc dynamic var sentDate: Date = Date()
    @objc dynamic var content: String = ""
    var image: Image? = nil
    var sender: Sender = Sender(id: "", displayName: "")
    var kind: MessageKind {
        if let image = image {
            return .photo(image)
        } else {
            return .text(content)
        }
    }
    
    override static func primaryKey() -> String? {
        return "messageId"
    }
    
}


extension Message {
    func initialize(messageId: String, sender: Sender, sentDate: Date, content: String) {
        self.messageId = messageId
        self.sender = sender
        self.sentDate = sentDate
        self.content = content
        self.image?.image = nil
        self.image?.url = nil
    }
    
    func initialize(document: QueryDocumentSnapshot) -> Bool {
        let data = document.data()
        
        guard let senderId = data["senderID"] as? String,
            let displayName =  data["senderName"] as? String else {
                return false
        }
        guard let time = data["created"] as? Timestamp else {
            return false
        }
        guard let content = data["content"] as? String else {
            return false
        }
        self.sender = Sender(id: senderId, displayName: displayName)
        self.sentDate = time.dateValue()
        self.content = content
        self.messageId = document.documentID
        self.image = nil
        self.image?.url = nil
        
        return true
    }
    
    func initialize(user: User, content: String) -> Bool {
        sender = Sender(id: user.uid, displayName: AppDefs.displayName)
        self.content = content
        sentDate = Date()
        // ignoring messageId
        self.messageId = "0"
       // self.messageId = String(arc4random_uniform(100000))
        return true
    }
}
extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.id,
            "senderName": sender.displayName
        ]
        
        if let url = image?.url {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
}


extension UIColor {
    
    static var primary: UIColor {
        return UIColor(red: 1 / 255, green: 93 / 255, blue: 48 / 255, alpha: 1)
    }
    
    static var incomingMessage: UIColor {
        return UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }
    
}
*/

import Foundation
import Firebase
import MessageKit
import RealmSwift
import Realm

final class AppDefs {
    static var displayName: String! {
        get {
            return UserDefaults.standard.string(forKey: "displayName")
        }
        set {
            let defaults = UserDefaults.standard
            let key = "displayName"
            
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}






struct Image: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
}




extension UIColor {
    
    static var primary: UIColor {
        return UIColor(red: 1 / 255, green: 93 / 255, blue: 48 / 255, alpha: 1)
    }
    
    static var incomingMessage: UIColor {
        return UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }
    
}

