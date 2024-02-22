//
//  TrackingFullScreenView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit
import TrackingSDK

class TrackingFullScreenView: BaseView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var doYouWantLabel: UILabel!
  @IBOutlet weak var isSupportedLabel: UILabel!
  @IBOutlet weak var youCanLabel: UILabel!
  @IBOutlet weak var okLabel: UILabel!
  @IBOutlet weak var appNameLabel: UILabel!
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override func setProperties() {
    appNameLabel.text = AppText.App.name
    doYouWantLabel.text = AppText.LanguageKeys.doYouWant.localized
    isSupportedLabel.text = "\(AppText.App.name) " + AppText.LanguageKeys.isSupported.localized
    youCanLabel.text = AppText.LanguageKeys.youCan.localized
    okLabel.text = AppText.LanguageKeys.oke.localized
  }
  
  override func setColor() {
    let gradientImage = UIImage.gradientImage(bounds: contentView.bounds,
                                              colors: [
                                                UIColor(rgb: 0x79BEDB),
                                                UIColor(rgb: 0x7D94FB)
                                              ],
                                              startPoint: .zero,
                                              endPoint: CGPoint(x: 0.0, y: 1.0))
    let gradientColor = UIColor(patternImage: gradientImage)
    contentView.backgroundColor = gradientColor
    
    let appNameGradientImage = UIImage.gradientImage(bounds: appNameLabel.bounds,
                                                     colors: [
                                                      UIColor(rgb: 0x79BEDB),
                                                      UIColor(rgb: 0x7D94FB)
                                                     ],
                                                     startPoint: .zero,
                                                     endPoint: CGPoint(x: 0.0, y: 1.0))
    let appNameGradientColor = UIColor(patternImage: appNameGradientImage)
    appNameLabel.textColor = appNameGradientColor
  }
  
  @IBAction func onTapAgree(_ sender: Any) {
    Global.shared.setShowAppOpen(allow: false)
    TrackingSDK.shared.requestAuthorization {
      DispatchQueue.main.async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
          Global.shared.setShowAppOpen(allow: true)
        })
        guard
          let topVC = UIApplication.topViewController(),
          let navigationController = topVC.navigationController
        else {
          return
        }
        navigationController.viewControllers = [LanguageVC()]
      }
    }
  }
}
