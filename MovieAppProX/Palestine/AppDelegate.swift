//
//  AppDelegate.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import Firebase
import GoogleMobileAds
import AVFoundation
import TrackingSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Override point for customization after application launch.
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    FirebaseApp.configure()
    Global.shared.fetch()
    TrackingSDK.shared.initialize(devKey: "PdFSXQuoCZKy2mQvtsMXsW",
                                  appID: AppText.App.idApp,
                                  timeout: nil)
    try? AVAudioSession.sharedInstance().setCategory(.playback)
    return true
  }
}
