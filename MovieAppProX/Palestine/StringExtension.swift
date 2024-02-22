//
//  StringExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

public extension String {
  func convertToDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: self)
  }
  
  func heightText(width: CGFloat, font: UIFont) -> CGFloat {
    let maxSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
    let text: String = self
    return text.boundingRect(with: maxSize,
                             options: .usesLineFragmentOrigin,
                             attributes: [.font: font],
                             context: nil).height + 1
  }
  
  func widthText(height: CGFloat, font: UIFont) -> CGFloat {
    let maxSize = CGSize(width: CGFloat(MAXFLOAT), height: height)
    let text: String = self
    return text.boundingRect(with: maxSize,
                             options: .usesLineFragmentOrigin,
                             attributes: [.font: font],
                             context: nil).width + 1
  }
  
  func hexStringFromInt() -> Int {
    return Int(self, radix: 16) ?? 0
  }
  
  func getCleanedURL() -> URL? {
    guard !self.isEmpty else {
      return nil
    }
    if let url = URL(string: self) {
      return url
    } else if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
              let escapedURL = URL(string: urlEscapedString) {
      return escapedURL
    }
    return nil
  }
  
  func trimmingAllSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
      return components(separatedBy: characterSet).joined()
  }
}
