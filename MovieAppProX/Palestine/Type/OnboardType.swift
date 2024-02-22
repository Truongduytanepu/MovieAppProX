//
//  OnboardType.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import Foundation

enum OnboardType: CaseIterable {
  case step1
  case step2
  case step3
  
  var title: String {
    switch self {
    case .step1:
      return AppText.LanguageKeys.discoverTr.localized
    case .step2:
      return AppText.LanguageKeys.drawTheAc.localized
    case .step3:
      return AppText.LanguageKeys.contributeWithJoy.localized
    }
  }
  
  var icon: AppIcon.Icon {
    switch self {
    case .step1:
      return .step1
    case .step2:
      return .step2
    case .step3:
      return .step3
    }
  }
}
