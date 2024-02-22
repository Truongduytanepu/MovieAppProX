//
//  AppText.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import Foundation

class AppText {
  enum App {
    static let idApp = "6473266062"
    static let privacyLink = "https://nowtechpro.github.io/Privacy/Privacy.html"
    static let termsOfUse = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula"
    static let email = "minhtx@proxglobal.com"
    static let name = "Filter For Good"
  }
  
  enum LanguageKeys: String {
    case discoverTr
    case drawTheAc
    case contributeWithJoy
    case next
    case begin
    case language
    case youHaveRun
    case upgradeTo
    case watchAds
    case getFreeUses
    case onlyAShort
    case watchAdsFor
    case youHave
    case upgradeToUnlimited
    case doYouWant
    case isSupported
    case youCan
    case oke
    case tryNow
    case trending
    case camera
    case home
    case gallery
    case whyYou
    case withinThisApp
    case addSong
    case chooseFilter
    case done
    case audio
    case retake
    case share
    case saving
    case saved
    case loading
    case removeThis
    case afterDeleting
    case yes
    case discard
    case finish
    case other
    case explore
    case select
    case clearAllGallery
    case deleteThis
    case youWon
    case delete
    case updateAvailable
    case update
    case having
    case supportOur
    case submit
    case yourFeedback
    case shareApp
    case rateApp
    case privacyPolicy
    case thank
    case yourGallery
    case howCan
    case setting
    
    var localized: String {
      return LanguageManager.localized(key: self.rawValue) ?? String()
    }
  }
  
  enum AdName {
    static let openApp = "ID_Open_app"
    static let internSplash = "ID_Intern_Splash"
    static let nativeOnboard = "ID_Native_Onboard"
    static let nativeLanguage = "ID_Native_Language"
    static let collapsibleTrendingDetail = "ID_Collapsible_Trending_Detail"
    static let interHomeTrending = "ID_Inter_Home_Trending"
    static let collapsibleDefault = "ID_Collapsible_Default"
    static let nativeFilter = "ID_Native_Filter"
    static let nativeSounds = "ID_Native_Sounds"
    static let interstitialEmpty = "ID_Interstitial_Empty"
    static let collapGalleryItems = "ID_Collap_Gallery_Items"
    static let interHomeClickVideo = "ID_Inter_Home_Click_Video"
    static let interstitialPreview = "ID_Interstitial_Preview"
    static let interHomeTrendingDetail = "ID_Inter_Home_Trending_Detail"
    static let rewardsCamera = "ID_Rewards_Camera"
    static let interstitialCameraBack = "ID_Interstitial_Camera_Back"
    static let interRetake = "ID_Inter_Retake"
    static let collapsibleResultsTop = "ID_Collapsible_Results_Top"
    static let interTrendingBack = "ID_Inter_Trending_Back"
    static let nativeShare = "ID_Native_Share"
    static let interCameraTrending = "ID_Inter_Camera_Trending"
  }
}
