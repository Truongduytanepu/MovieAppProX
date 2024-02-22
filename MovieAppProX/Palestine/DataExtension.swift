//
//  DataExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 02/11/2023.
//

import Foundation

extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
