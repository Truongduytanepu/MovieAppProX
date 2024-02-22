//
//  CGFloatExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension CGFloat {
  func roundToDecimals(decimals: Int = 9) -> CGFloat {
    let multiplier = pow(10, CGFloat(decimals))
    return ((self * multiplier).rounded() / multiplier)
  }
}
