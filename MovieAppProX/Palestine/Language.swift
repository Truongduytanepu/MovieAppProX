//
//  Language.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import Foundation

enum Language: Int, CaseIterable {
  case english
  case portuguese
  case portugueseBr
  case spanish
  case hindi
  case french
  case hungarian
  case vietnamese
  
  var code: String {
    switch self {
    case .english:
      return "en"
    case .portuguese:
      return "pt-PT"
    case .portugueseBr:
      return "pt-BR"
    case .spanish:
      return "es"
    case .hindi:
      return "hi"
    case .french:
      return "fr"
    case .hungarian:
      return "hu"
    case .vietnamese:
      return "vi"
    }
  }
  
  var name: String {
    switch self {
    case .english:
      return "English"
    case .portuguese:
      return "Portuguese"
    case .portugueseBr:
      return "Portuguese Br"
    case .spanish:
      return "Spanish"
    case .hindi:
      return "Hindi"
    case .french:
      return "French"
    case .hungarian:
      return "Hungarian"
    case .vietnamese:
      return "Vietnamese"
    }
  }
  
  var ensign: AppIcon.Icon {
    switch self {
    case .english:
      return .english
    case .portuguese:
      return .portuguese
    case .hindi:
      return .hindi
    case .spanish:
      return .spanish
    case .portugueseBr:
      return .portugueseBr
    case .vietnamese:
      return .vietnamese
    case .french:
      return .french
    case .hungarian:
      return .hungarian
    }
  }
}
