//
//  SplashVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import AdMobManager
import NVActivityIndicatorView

class SplashVC: BaseViewController {
  @IBOutlet weak var loadingView: NVActivityIndicatorView!
  
  private var firstAppear = true
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if !firstAppear {
      LoadingManager.shared.show(rootViewController: self)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if firstAppear {
      self.firstAppear = false
      AdMobManager.shared.addActionSuccessRegister { [weak self] in
        guard let self else {
          return
        }
        AdMobManager.shared.show(type: .splash,
                                 name: AppText.AdName.internSplash,
                                 rootViewController: self,
                                 didFail: self.endAnimation,
                                 didHide: self.endAnimation)
      }
    }
  }
  
  override func setProperties() {
    loadingView.startAnimating()
  }
}

extension SplashVC {
  func endAnimation() {
    guard let navigationController else {
      return
    }
    if Global.shared.allowShowWelcome {
      navigationController.viewControllers = [OnboardVC()]
    } else {
      navigationController.viewControllers = [RootVC()]
    }
  }
}
