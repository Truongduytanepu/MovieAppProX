//
//  CGPointExtension.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 27/11/2023.
//

import Foundation

extension CGPoint {
  func distance(to second: CGPoint) -> Double {
    let first = self
    return sqrt((second.x - first.x).square() + (second.y - first.y).square())
  }
}
