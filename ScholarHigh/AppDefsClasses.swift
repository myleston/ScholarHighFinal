//
//  AppDefsClasses.swift
//  ScholarHighPrototype1
//
//  Created by 広瀬陽一 on 2018/11/13.
//  Copyright © 2018 FRESHNESS. All rights reserved.
//

import Foundation

var classes = [Class]()

class Class1 {
    var title: String
    var teacherName: String
    var period: Int
    var day: String
    var place: String
    
    init(title: String, teacherName: String, period: Int, day: String, place: String) {
        self.title = title
        self.teacherName = teacherName
        self.period = period
        self.day = day
        self.place = place
    }
}

var startTimes = [
    "8:50", "10:30", "13:00", "14:40", "16:20", "18:00", "19:40"
]

var endTimes = [
    "10:20", "12:00", "14:30", "16:10", "17:50", "19:30", "21:10"
]

let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]

