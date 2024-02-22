//
//  AppIcon.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit

class AppIcon {
  enum Icon {
    case normal
    
    case galleryDeselectTabBar
    case gallerySelectTabBar
    case homeDeselectTabBar
    case homeSelectTabBar
    
    case deselectMusic
    case selectMusic
    
    case point0
    
    case play
    case pause
    
    case selectGallery
    case deselectGallery
    
    case backLight
    
    case menuSetting
    case menuGallery
    case deleteGallery
    
    case share
    case rate
    case privacy
    case language
    
    case step1
    case step2
    case step3
    
    case english
    case portuguese
    case portugueseBr
    case spanish
    case hindi
    case french
    case hungarian
    case vietnamese
    
    case selectLanguage
    case deselectLanguage
    
    case limitReward
    case moreReward
    case maxReward
    
    case disableStar
    case enableStar
  }
  
  static func image(icon: Icon) -> UIImage {
    if let image = UIImage(named: "\(icon)") {
      return image
    } else if let imageSystem = UIImage(systemName: "\(icon)") {
      return imageSystem
    }
    return image(icon: Icon.normal)
  }
}
