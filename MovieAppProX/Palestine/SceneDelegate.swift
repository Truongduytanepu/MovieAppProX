//
//  SceneDelegate.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import AdMobManager

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func sceneDidBecomeActive(_ scene: UIScene) {
    guard Global.shared.allowShowAppOpen else {
      return
    }
    guard let topVC = UIApplication.topViewController() else {
      return
    }
    AdMobManager.shared.show(type: .appOpen,
                             name: AppText.AdName.openApp,
                             rootViewController: topVC,
                             didFail: nil,
                             didHide: nil)
  }
}
