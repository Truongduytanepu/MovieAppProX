//
//  ShareVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit
import AdMobManager

class ShareVC: BaseViewController {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var shareLabel: UILabel!
  @IBOutlet weak var finishLabel: UILabel!
  @IBOutlet weak var otherLabel: UILabel!
  @IBOutlet weak var customNativeAdView: CustomNativeAdView!
  
  private var recordURL: URL?
  private var thumbnailImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    RatingApp.shared.showRateShare()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  override func setProperties() {
    shareLabel.text = AppText.LanguageKeys.share.localized
    finishLabel.text = AppText.LanguageKeys.finish.localized
    otherLabel.text = AppText.LanguageKeys.other.localized
  }
  
  override func binding() {
    if let thumbnailImage {
      thumbnailImageView.image = thumbnailImage
    }
    
    if AdMobManager.shared.status(type: .onceUsed(.native), name: AppText.AdName.nativeShare) == true {
      customNativeAdView.load(name: AppText.AdName.nativeShare)
    } else {
      customNativeAdView.isHidden = true
    }
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    pop(animated: false)
  }
  
  @IBAction func onTapFinish(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickShareFinish)
    guard let navigationController else {
      return
    }
    let viewControllers = navigationController.viewControllers
    let previousVC = viewControllers[viewControllers.count - 2]
    if previousVC is ResultVC {
      let viewControllers = navigationController.viewControllers.prefix(1)
      let recordVC = RecordVC()
      recordVC.suggest()
      navigationController.viewControllers = viewControllers + [recordVC]
    } else if previousVC is PlayRecordVC {
      guard let rootVC = viewControllers.first as? RootVC else {
        return
      }
      navigationController.popToViewController(rootVC, animated: false)
    }
  }
  
  @IBAction func onTapTiktok(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickShareTiktok)
    share()
  }
  
  @IBAction func onTapInstagram(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickShareInstagram)
    share()
  }
  
  @IBAction func onTapOther(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickShareOther)
    share()
  }
  
  @IBAction func onTapShare(_ sender: Any) {
    share()
  }
}

extension ShareVC {
  func config(recordURL: URL, thumbnailImage: UIImage) {
    self.recordURL = recordURL
    self.thumbnailImage = thumbnailImage
  }
}

extension ShareVC: UIPopoverPresentationControllerDelegate {
  private func share() {
    guard let recordURL else {
      return
    }
    DispatchQueue.main.async { [weak self] in
      guard let self else {
        return
      }
      let objectsToShare = [recordURL]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      activityVC.setValue("Image", forKey: "subject")
      activityVC.excludedActivityTypes = [
        .airDrop,
        .addToReadingList,
        .assignToContact,
        .copyToPasteboard,
        .mail,
        .message,
        .openInIBooks,
        .postToTencentWeibo,
        .postToVimeo,
        .postToWeibo,
        .print
      ]
      if UIDevice.current.userInterfaceIdiom == .pad {
        activityVC.modalPresentationStyle = .popover
        if let popoverPresentationController = activityVC.popoverPresentationController {
          popoverPresentationController.permittedArrowDirections = .up
          popoverPresentationController.sourceView = self.view
          popoverPresentationController.sourceRect = self.thumbnailImageView.frame
          popoverPresentationController.delegate = self
        }
      }
      self.present(to: activityVC, animated: true)
    }
  }
}
