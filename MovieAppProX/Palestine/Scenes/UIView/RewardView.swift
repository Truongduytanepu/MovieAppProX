//
//  RewardView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit
import AdMobManager

class RewardView: BaseView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var watchAdsView: UIView!
  @IBOutlet weak var watchAdsLabel: UILabel!
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override func setProperties() {
    updateUI()
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    removeFromSuperview()
  }
  
  @IBAction func onTapWatchAds(_ sender: Any) {
    LogEventManager.shared.log(event: .usesClickWatchAds)
    guard let topVC = UIApplication.topViewController() else {
      return
    }
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .rewarded,
            name: AppText.AdName.rewardsCamera,
            rootViewController: topVC,
            didFail: back,
            didEarnReward: CreditManager.shared.didReceiveReward,
            didHide: back)
    ()
  }
}

extension RewardView {
  private func back() {
    LoadingManager.shared.hide()
    removeFromSuperview()
  }
  
  private func updateUI() {
    if CreditManager.shared.isLimit() {
      LogEventManager.shared.log(event: .usesShowPopNoUses)
      thumbnailImageView.image = AppIcon.image(icon: .limitReward)
      titleLabel.text = AppText.LanguageKeys.youHaveRun.localized
      contentLabel.text = AppText.LanguageKeys.upgradeTo.localized
      watchAdsView.backgroundColor = UIColor(rgb: 0x7FD4FA)
      watchAdsView.isUserInteractionEnabled = true
      watchAdsLabel.text = AppText.LanguageKeys.watchAds.localized
    } else if !CreditManager.shared.showReward {
      LogEventManager.shared.log(event: .usesShowPopLimit)
      thumbnailImageView.image = AppIcon.image(icon: .maxReward)
      titleLabel.text = AppText.LanguageKeys.youHave.localized
      contentLabel.text = AppText.LanguageKeys.upgradeToUnlimited.localized
      watchAdsView.backgroundColor = UIColor(rgb: 0xAAAAAA)
      watchAdsView.isUserInteractionEnabled = false
      watchAdsLabel.text = AppText.LanguageKeys.watchAds.localized
    } else {
      LogEventManager.shared.log(event: .usesShowPopFreeUses)
      thumbnailImageView.image = AppIcon.image(icon: .moreReward)
      titleLabel.text = AppText.LanguageKeys.getFreeUses.localized
      contentLabel.text = AppText.LanguageKeys.onlyAShort.localized
      watchAdsView.backgroundColor = UIColor(rgb: 0x7FD4FA)
      watchAdsView.isUserInteractionEnabled = true
      watchAdsLabel.text = AppText.LanguageKeys.watchAdsFor.localized
    }
  }
}
