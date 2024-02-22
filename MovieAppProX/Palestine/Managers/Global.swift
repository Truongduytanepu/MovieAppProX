//
//  Global.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import Combine
import FirebaseRemoteConfig
import IAPManager
import AdMobManager
import Glassfy

class Global {
  static let shared = Global()
  
  enum Keys {
    // Local
    static let didShowWelcome = "DID_SHOW_WELCOME"
    static let openAppCount = "OPEN_APP_COUNT"
    static let didShowShowInformation = "DID_SHOW_INFORMATION"
    // Feedback
    static let email = "EMAIL"
    // Credit
    static let defaultFree = "DEFAULT_FREE"
    static let rewardFree = "REWARD_FREE"
    static let maxRemainingFree = "MAX_REMAINING_FREE"
    // IAA
    static let adMobConfig = "ADMOB_V1_0"
    // Push Rate
    static let pushRateConfig = "PUSH_RATE_V1_0"
    static let rateInApp = "RATE_IN_APP"
    // Push Update
    static let pushUpdateConfig = "PUSH_UPDATE_V1_0"
    // Push Tracking
    static let pushTrackingConfig = "PUSH_TRACKING_V1_0"
  }
  
  // Local
  private(set) var loadRemoteConfigState = false
  private(set) var allowShowAppOpen = false
  private(set) var allowShowWelcome = false
  private(set) var allowShowInformation = false
  private(set) var openAppCount = 0
  // Feedback
  private(set) var email: String?
  // Credit
  private(set) var defaultFree = 3
  private(set) var rewardFree = 3
  private(set) var maxRemainingFree = 10
  // Push Rate
  private(set) var pushRateConfig: PushRateConfig?
  private(set) var rateInApp = true
  // Push Update
  private(set) var pushUpdateConfig: PushUpdateConfig?
  // Push Tracking
  private(set) var pushTrackingConfig: PushTrackingConfig?
}

extension Global {
  func fetch() {
    fetchWelcome()
    fetchInformation()
    
    AdMobManager.shared.addActionConfigValue { [weak self] remoteConfig in
      guard let self else {
        return
      }
      updateWithRCValues(remoteConfig: remoteConfig)
    }
    
    openApp()
    registerAdMob()
    LanguageManager.shared.fetchChoseLanguage()
    RatingApp.shared.fetch()
    CreditManager.shared.fetch()
    TrendingManager.shared.fetch()
    MusicManager.shared.fetch()
    FilterManager.shared.fetch()
    GalleryManager.shared.fetch()
  }
  
  func setShowAppOpen(allow: Bool) {
    self.allowShowAppOpen = allow
  }
  
  func didShowWelcome() {
    UserDefaults.standard.set(true, forKey: Keys.didShowWelcome)
    fetchWelcome()
  }
  
  func pushUpdate() -> Bool {
    guard 
      let pushUpdateConfig,
      pushUpdateConfig.status,
      let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
      let version = Double(versionString),
      version < pushUpdateConfig.nowVersion
    else {
      return false
    }
    return true
  }
  
  func showPushUpdate() {
    DispatchQueue.main.async { [weak self] in
      guard let self else {
        return
      }
      guard 
        let pushUpdateConfig,
        let topVC = UIApplication.topViewController()
      else {
        return
      }
      if pushUpdateConfig.obligatory {
        let obligatoryPushUpdateView = ObligatoryPushUpdateView()
        obligatoryPushUpdateView.frame = topVC.view.frame
        topVC.view.addSubview(obligatoryPushUpdateView)
      } else {
        let normalPushUpdateView = NormalPushUpdateView()
        normalPushUpdateView.frame = topVC.view.frame
        topVC.view.addSubview(normalPushUpdateView)
      }
    }
  }
  
  func showInformation() {
    DispatchQueue.main.async { [weak self] in
      guard let self else {
        return
      }
      guard allowShowInformation else {
        return
      }
      didShowInformation()
      guard let topVC = UIApplication.topViewController() else {
        return
      }
      let informationView = InformationView()
      informationView.frame = topVC.view.frame
      topVC.view.addSubview(informationView)
    }
  }
}

extension Global {
  private func updateWithRCValues(remoteConfig: RemoteConfig) {
    // Feedback
    self.email = remoteConfig.configValue(forKey: Keys.email).stringValue
    // Credit
    if let defaultFree = remoteConfig.configValue(forKey: Keys.defaultFree).numberValue as? Int {
      self.defaultFree = defaultFree
    }
    if let rewardFree = remoteConfig.configValue(forKey: Keys.rewardFree).numberValue as? Int {
      self.rewardFree = rewardFree
    }
    if let maxRemainingFree = remoteConfig.configValue(forKey: Keys.maxRemainingFree).numberValue as? Int {
      self.maxRemainingFree = maxRemainingFree
    }
    // Push Rate
    let pushRateData = remoteConfig.configValue(forKey: Keys.pushRateConfig).dataValue
    if let pushRateConfig = try? JSONDecoder().decode(PushRateConfig.self, from: pushRateData) {
      self.pushRateConfig = pushRateConfig
    }
    self.rateInApp = remoteConfig.configValue(forKey: Keys.rateInApp).boolValue
    // Push Update
    let pushUpdateData = remoteConfig.configValue(forKey: Keys.pushUpdateConfig).dataValue
    if let pushUpdateConfig = try? JSONDecoder().decode(PushUpdateConfig.self, from: pushUpdateData) {
      self.pushUpdateConfig = pushUpdateConfig
    }
    // Push Tracking
    let pushTrackingData = remoteConfig.configValue(forKey: Keys.pushTrackingConfig).dataValue
    if let pushTrackingConfig = try? JSONDecoder().decode(PushTrackingConfig.self, from: pushTrackingData) {
      self.pushTrackingConfig = pushTrackingConfig
    }
    // Local
    self.loadRemoteConfigState = true
  }
  
  private func registerAdMob() {
    AdMobManager.shared.addActionSuccessRegister {
      AdMobManager.shared.load(type: .appOpen, name: AppText.AdName.openApp)
      AdMobManager.shared.load(type: .splash, name: AppText.AdName.internSplash)
      AdMobManager.shared.load(type: .rewarded, name: AppText.AdName.rewardsCamera)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interHomeTrending)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interstitialEmpty)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interHomeClickVideo)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interstitialPreview)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interHomeTrendingDetail)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interstitialCameraBack)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interRetake)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interTrendingBack)
      AdMobManager.shared.load(type: .interstitial, name: AppText.AdName.interCameraTrending)
      AdMobManager.shared.preloadNative(name: AppText.AdName.nativeOnboard)
      AdMobManager.shared.preloadNative(name: AppText.AdName.nativeLanguage)
    }
    
    if let url = Bundle.main.url(forResource: "AdMobDefaultValue", withExtension: "json"),
       let data = try? Data(contentsOf: url) {
      AdMobManager.shared.register(remoteKey: Keys.adMobConfig, defaultData: data)
    }
  }
  
  private func didShowInformation() {
    UserDefaults.standard.set(true, forKey: Keys.didShowShowInformation)
    fetchInformation()
  }
  
  private func fetchWelcome() {
    self.allowShowWelcome = !UserDefaults.standard.bool(forKey: Keys.didShowWelcome)
  }
  
  private func fetchInformation() {
    self.allowShowInformation = !UserDefaults.standard.bool(forKey: Keys.didShowShowInformation)
  }
  
  private func openApp() {
    self.openAppCount = UserDefaults.standard.integer(forKey: Keys.openAppCount)
    self.openAppCount += 1
    UserDefaults.standard.set(openAppCount, forKey: Keys.openAppCount)
  }
}
