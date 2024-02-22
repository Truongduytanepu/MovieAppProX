//
//  SettingType.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import Foundation

enum SettingType: CaseIterable {
  case share
  case rate
  case privacy
  case language
  
  var icon: AppIcon.Icon {
    switch self {
    case .share:
      return .share
    case .rate:
      return .rate
    case .privacy:
      return .privacy
    case .language:
      return .language
    }
  }
  
  var name: String {
    switch self {
    case .share:
      return AppText.LanguageKeys.shareApp.localized
    case .rate:
      return AppText.LanguageKeys.rateApp.localized
    case .privacy:
      return AppText.LanguageKeys.privacyPolicy.localized
    case .language:
      return AppText.LanguageKeys.language.localized
    }
  }
}
