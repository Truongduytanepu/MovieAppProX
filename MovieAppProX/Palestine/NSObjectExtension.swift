//
//  NSObjectExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import Foundation

extension NSObject {
  public class var className: String {
    return String(describing: self)
  }
  
  public var className: String {
    return String(describing: self)
  }
}
