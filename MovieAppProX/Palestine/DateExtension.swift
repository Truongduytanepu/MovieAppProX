//
//  DateExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension Date {
  func asString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: self)
  }
  
  func asStringTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy - HH:mm"
    return dateFormatter.string(from: self)
  }
  
  func asStringEnglish() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale(identifier: "en_US")
    return dateFormatter.string(from: self)
  }
  
  func asStringPDF() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    return dateFormatter.string(from: self)
  }
  
  func toLocalTime() -> Date {
    return Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: self)), since: self)
  }
  
  func resetTime(_ hour: Int = 0, _ minute: Int = 0, _ second: Int = 0) -> Date {
    return Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: self)!
  }
  
  func nextDate(_ number: Int = 100) -> Date {
    return Calendar.current.date(byAdding: .day, value: number, to: self)!
  }
  
  func settingDate(year: Int,
                   month: Int,
                   day: Int,
                   hour: Int,
                   minute: Int
  ) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.second = 0
    return Calendar(identifier: .gregorian).date(from: dateComponents)!
  }
  
  func getYear() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: self)
  }
  
  func getTimestamp() -> Int {
    return Int(self.timeIntervalSince1970)
  }
}
