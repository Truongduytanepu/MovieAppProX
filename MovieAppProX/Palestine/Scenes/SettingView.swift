//
//  SettingView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit
import SafariServices

class SettingView: BaseView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var settingLabel: UILabel!
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override func setProperties() {
    settingLabel.text = AppText.LanguageKeys.setting.localized
    
    containerView.layer.maskedCorners = [
      .layerMaxXMinYCorner,
      .layerMaxXMaxYCorner
    ]
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: SettingCVC.self)
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    removeFromSuperview()
  }
}

extension SettingView: UIPopoverPresentationControllerDelegate {
  private func rate() {
    RatingApp.shared.clickRateSetting()
  }
  
  private func share() {
    guard let url = URL(string: "https://itunes.apple.com/us/app/myapp/id\(AppText.App.idApp)?ls=1&mt=8") else {
      return
    }
    let objectsToShare = [url]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    if UIDevice.current.userInterfaceIdiom == .pad {
      activityVC.modalPresentationStyle = .popover
      if let popoverPresentationController = activityVC.popoverPresentationController {
        popoverPresentationController.permittedArrowDirections = .up
        popoverPresentationController.sourceView = collectionView
        popoverPresentationController.sourceRect = CGRect(origin: .zero,
                                                          size: CGSize(width: collectionView.frame.width,
                                                                       height: 56.0))
        popoverPresentationController.delegate = self
      }
    }
    present(to: activityVC, animated: true)
  }
  
  private func privacy() {
    guard let url = URL(string: AppText.App.privacyLink) else {
      return
    }
    let safariVC = SFSafariViewController(url: url)
    present(to: safariVC, animated: true)
  }
  
  private func language() {
    guard 
      let topVC = UIApplication.topViewController(),
      let navigationController = topVC.navigationController
    else {
      return
    }
    navigationController.viewControllers = [LanguageVC()]
  }
}

extension SettingView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch SettingType.allCases[indexPath.item] {
    case .rate:
      LogEventManager.shared.log(event: .menuClickRate)
      rate()
    case .language:
      LogEventManager.shared.log(event: .menuClickLanguage)
      language()
    case .privacy:
      LogEventManager.shared.log(event: .menuClickPolicy)
      privacy()
    case .share:
      LogEventManager.shared.log(event: .menuClickShare)
      share()
    }
  }
}

extension SettingView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return SettingType.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: SettingCVC.self, indexPath: indexPath)
    cell.config(SettingType.allCases[indexPath.item])
    return cell
  }
}

extension SettingView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 56.0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: .zero,
                        left: .zero,
                        bottom: safeAreaInsets.bottom + 24.0,
                        right: .zero)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
}
