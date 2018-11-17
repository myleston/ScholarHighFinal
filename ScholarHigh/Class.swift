//
//  Class.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/15.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import Foundation
import Firebase
import MessageKit
import RealmSwift
import Realm

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
