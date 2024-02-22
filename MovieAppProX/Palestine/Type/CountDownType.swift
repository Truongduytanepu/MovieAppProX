//
//  CountDownType.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import Foundation

enum CountDownType {
  case cd0s
  case cd3s
  case cd5s
  case cd10s
  case cd15s
  
  var time: Double? {
    switch self {
    case .cd0s:
      return nil
    case .cd3s:
      return 3.0
    case .cd5s:
      return 5.0
    case .cd10s:
      return 10.0
    case .cd15s:
      return 15.0
    }
  }
}
