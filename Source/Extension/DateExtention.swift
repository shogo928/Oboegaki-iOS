//
//  DateExtention.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/10/27.
//

import Foundation

extension TimeZone {
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    static let japan = Locale(identifier: "ja_JP")
}

extension Date {
    var zeroTime: Date {
        return fixed(hour: 0, minute: 0, second: 0)
    }
    
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .japan
        calendar.locale   = .japan
        return calendar
    }
    
    func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year   = year   ?? calendar.component(.year,   from: self)
        comp.month  = month  ?? calendar.component(.month,  from: self)
        comp.day    = day    ?? calendar.component(.day,    from: self)
        comp.hour   = hour   ?? calendar.component(.hour,   from: self)
        comp.minute = minute ?? calendar.component(.minute, from: self)
        comp.second = second ?? calendar.component(.second, from: self)

        return calendar.date(from: comp)!
    }
    
    func now() -> Date {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year   = calendar.component(.year,   from: self)
        comp.month  = calendar.component(.month,  from: self)
        comp.day    = calendar.component(.day,    from: self)
        comp.hour   = calendar.component(.hour,   from: self)
        comp.minute = calendar.component(.minute, from: self)
        comp.second = calendar.component(.second, from: self)

        return calendar.date(from: comp)!
    }
}
