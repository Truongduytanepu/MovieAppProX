//
//  HomeCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import NVActivityIndicatorView
import SnapKit
import AdMobManager

class HomeCVC: BaseCollectionViewCell {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var settingImageView: UIImageView!
  @IBOutlet weak var creditView: UIView!
  @IBOutlet weak var creditLabel: UILabel!
  @IBOutlet weak var appNameLabel: UILabel!
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let loadingView = NVActivityIndicatorView(frame: .zero)
    loadingView.type = .ballSpinFadeLoader
    loadingView.padding = 30.0
    loadingView.color = UIColor(rgb: 0x000000)
    return loadingView
  }()
  
  enum Section: CaseIterable {
    case header
    case trendings
  }
  
  override func addComponents() {
    addSubview(loadingView)
  }
  
  override func setConstraints() {
    loadingView.snp.makeConstraints { make in
      make.width.height.equalTo(20.0)
      make.center.equalTo(collectionView)
    }
  }
  
  override func setProperties() {
    appNameLabel.text = AppText.App.name
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: HeaderHomeCVC.self)
    collectionView.registerNib(ofType: TrendingCVC.self)
    
    settingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(onTapSetting)))
    
    creditView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(onTapCredit)))
  }
  
  override func setColor() {
    let gradientImage = UIImage.gradientImage(bounds: appNameLabel.bounds,
                                              colors: [
                                                UIColor(rgb: 0x79BEDB),
                                                UIColor(rgb: 0x7D94FB)
                                              ],
                                              startPoint: .zero,
                                              endPoint: CGPoint(x: 0.0, y: 1.0))
    let gradientColor = UIColor(patternImage: gradientImage)
    appNameLabel.textColor = gradientColor
  }
  
  override func binding() {
    TrendingManager.shared.$isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        guard let self else {
          return
        }
        collectionView.isHidden = isLoading
        if isLoading {
          loadingView.startAnimating()
        } else {
          loadingView.stopAnimating()
        }
      }.store(in: &subscriptions)
    
    TrendingManager.shared.$trendings
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        collectionView.reloadData()
      }.store(in: &subscriptions)
    
    CreditManager.shared.$remainingFree
      .receive(on: DispatchQueue.main)
      .sink { [weak self] remainingFree in
        guard let self else {
          return
        }
        creditLabel.text = String(remainingFree)
      }.store(in: &subscriptions)
  }
}

extension HomeCVC {
  @objc private func onTapSetting() {
    LogEventManager.shared.log(event: .homeClickSettings)
    guard let topVC = UIApplication.topViewController() else {
      return
    }
    let settingView = SettingView()
    settingView.frame = topVC.view.frame
    topVC.view.addSubview(settingView)
  }
  
  @objc private func onTapCredit() {
    LogEventManager.shared.log(event: .homeClickUses)
    guard let topVC = UIApplication.topViewController() else {
      return
    }
    let rewardView = RewardView()
    rewardView.frame = topVC.view.frame
    topVC.view.addSubview(rewardView)
  }
  
  private func toPlayTrending(_ trending: Trending) {
    TrendingManager.shared.play(trending)
    let playTrendingVC = PlayTrendingVC()
    push(to: playTrendingVC, animated: false)
  }
}

extension HomeCVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch Section.allCases[indexPath.section] {
    case .trendings:
      LogEventManager.shared.log(event: .homeClickTrending)
      guard let topVC = UIApplication.topViewController() else {
        return
      }
      let toPlay = { [weak self] in
        guard let self else {
          return
        }
        toPlayTrending(TrendingManager.shared.trendings[indexPath.item])
      }
      LoadingManager.shared.show()
      AdMobManager
        .shared
        .show(type: .interstitial,
              name: AppText.AdName.interHomeClickVideo,
              rootViewController: topVC,
              didFail: toPlay,
              didHide: toPlay)
    default:
      return
    }
  }
}

extension HomeCVC: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Section.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch Section.allCases[section] {
    case .header:
      return 1
    case .trendings:
      return TrendingManager.shared.trendings.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch Section.allCases[indexPath.section] {
    case .header:
      return collectionView.dequeue(ofType: HeaderHomeCVC.self, indexPath: indexPath)
    case .trendings:
      let cell = collectionView.dequeue(ofType: TrendingCVC.self, indexPath: indexPath)
      cell.config(TrendingManager.shared.trendings[indexPath.item])
      return cell
    }
  }
}

extension HomeCVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch Section.allCases[indexPath.section] {
    case .header:
      let inset = 24.0
      let scale = 328.0 / 199.0
      let otherSpacing = 47.0
      return CGSize(width: collectionView.frame.width,
                    height: (collectionView.frame.width - inset * 2) / scale + otherSpacing)
    case .trendings:
      let sumInset = 24.0 * 2
      let groupSpace = 16.0
      let numberGroupOnPhone = 2.0
      let scale = 156.0 / 240.0
      let width: CGFloat!
      if UIDevice.current.userInterfaceIdiom == .phone {
        width = (collectionView.frame.width - sumInset - (numberGroupOnPhone - 1) * groupSpace) / numberGroupOnPhone
        - AppSize.divisionInterval
      } else {
        let minWidth = AppSize.normalPhoneWidth / numberGroupOnPhone
        let maxItemInGroupOnPad = CGFloat(Int((collectionView.frame.width - sumInset + groupSpace) / (minWidth + groupSpace)))
        width = (collectionView.frame.width - sumInset - (maxItemInGroupOnPad - 1) * groupSpace) / maxItemInGroupOnPad
        - AppSize.divisionInterval
      }
      return CGSize(width: width, height: width / scale)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch Section.allCases[section] {
    case .header:
      return UIEdgeInsets(top: 8.0,
                          left: .zero,
                          bottom: .zero,
                          right: .zero)
    case .trendings:
      let bottom = safeAreaInsets.bottom + 134.0 + 16.0
      return UIEdgeInsets(top: 8.0,
                          left: 24.0,
                          bottom: bottom,
                          right: 24.0)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch Section.allCases[section] {
    case .header:
      return .zero
    case .trendings:
      return 8.0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch Section.allCases[section] {
    case .header:
      return .zero
    case .trendings:
      return 16.0
    }
  }
}
