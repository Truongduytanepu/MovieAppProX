//
//  ObligatoryPushUpdateView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit

class ObligatoryPushUpdateView: BaseView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var versionLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var updateAvailableLabel: UILabel!
  @IBOutlet weak var updateLabel: UILabel!
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override func setProperties() {
    updateAvailableLabel.text = AppText.LanguageKeys.updateAvailable.localized
    updateLabel.text = AppText.LanguageKeys.update.localized
    
    containerView.layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner
    ]
  }
  
  override func binding() {
    if let pushUpdateConfig = Global.shared.pushUpdateConfig {
      versionLabel.text = "Version \(pushUpdateConfig.nowVersion)"
      contentLabel.text = pushUpdateConfig.obligatoryContent
    }
  }
  
  @IBAction func onTapUpdate(_ sender: Any) {
    let appPath = "https://apps.apple.com/app/id\(AppText.App.idApp)"
    guard let appURL = appPath.getCleanedURL() else {
      return
    }
    UIApplication.shared.open(appURL,
                              options: [:],
                              completionHandler: nil)
  }
}
