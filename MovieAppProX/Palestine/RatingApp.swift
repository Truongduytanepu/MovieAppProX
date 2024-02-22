//
//  RatingApp.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 06/11/2023.
//

import UIKit
import StoreKit
import SwiftKeychainWrapper

class RatingApp {
  static let shared = RatingApp()
  
  enum Keys {
    static let didPushRate = "DID_PUSH_RATE"
  }
  
  private var didPushRate = false
  private var isSaved = false
}

extension RatingApp {
  func fetch() {
    self.didPushRate = UserDefaults.standard.bool(forKey: Keys.didPushRate)
  }
  
  func didRate() {
    self.didPushRate = true
    UserDefaults.standard.set(true, forKey: Keys.didPushRate)
  }
  
  func clickRateSetting() {
    guard
      let pushRateConfig = Global.shared.pushRateConfig,
      pushRateConfig.status,
      pushRateConfig.setting
    else {
      if Global.shared.rateInApp {
        rateInApp()
      } else {
        ratingOnAppStore()
      }
      return
    }
    showPushRate()
  }
  
  func showRateHome() {
    guard
      !didPushRate,
      let pushRateConfig = Global.shared.pushRateConfig,
      pushRateConfig.status,
      pushRateConfig.home,
      Global.shared.openAppCount % 2 == 0
    else {
      return
    }
    showPushRate()
  }
  
  func showRateShare() {
    guard
      !didPushRate,
      let pushRateConfig = Global.shared.pushRateConfig,
      pushRateConfig.status,
      pushRateConfig.share,
      isSaved
    else {
      return
    }
    showPushRate()
  }
  
  func resetSaved() {
    self.isSaved = false
  }
  
  func saved() {
    self.isSaved = true
  }
  
  func ratingOnAppStore() {
    let reviewPath = "https://apps.apple.com/app/id\(AppText.App.idApp)?action=write-review"
    guard let writeReviewURL = reviewPath.getCleanedURL() else {
      return
    }
    UIApplication.shared.open(writeReviewURL,
                              options: [:],
                              completionHandler: nil)
  }
}

extension RatingApp {
  private func rateInApp() {
    let connectedScenes = UIApplication.shared.connectedScenes
    if let scene = connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
      DispatchQueue.main.async {
        SKStoreReviewController.requestReview(in: scene)
      }
    }
  }
  
  private func showPushRate() {
    DispatchQueue.main.async {
      guard let topVC = UIApplication.topViewController() else {
        return
      }
      let pushRateView = PushRateView()
      pushRateView.frame = topVC.view.frame
      topVC.view.addSubview(pushRateView)
    }
  }
  
  func showThanksRate() {
    DispatchQueue.main.async {
      guard let topVC = UIApplication.topViewController() else {
        return
      }
      let thankRateView = ThankRateView()
      thankRateView.frame = topVC.view.frame
      topVC.view.addSubview(thankRateView)
    }
  }
}
