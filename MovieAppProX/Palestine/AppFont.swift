//
//  AppFont.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit

class AppFont {
  enum FontName: String {
    case nunitoRegular = "NunitoSans-Regular"
    case nunitoBold = "NunitoSans-Bold"
    case nunitoExtraBold = "NunitoSans-ExtraBold"
  }
  
  class func getFont(fontName: FontName, size: CGFloat) -> UIFont {
    guard let font = UIFont(name: fontName.rawValue, size: size) else {
      return UIFont.systemFont(ofSize: size)
    }
    return font
  }
}
