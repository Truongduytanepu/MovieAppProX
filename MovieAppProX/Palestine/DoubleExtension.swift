//
//  DoubleExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import Foundation

extension Double {
  func roundToDecimals(decimals: Int = 9) -> Double {
    let multiplier = pow(10, Double(decimals))
    return ((self * multiplier).rounded() / multiplier)
  }
  
  func square() -> Double {
    return self * self
  }
}
