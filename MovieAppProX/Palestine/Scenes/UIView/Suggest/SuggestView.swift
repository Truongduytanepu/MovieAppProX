//
//  SuggestView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit
import SnapKit
import NVActivityIndicatorView
import AdMobManager
import CustomBlurEffectView

class SuggestView: BaseView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var exploreLabel: UILabel!
  @IBOutlet weak var blurEffectView: CustomBlurEffectView!
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let loadingView = NVActivityIndicatorView(frame: .zero)
    loadingView.type = .ballSpinFadeLoader
    loadingView.padding = 25.0
    loadingView.color = UIColor(rgb: 0x000000)
    return loadingView
  }()
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
    addSubview(loadingView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    loadingView.snp.makeConstraints { make in
      make.width.height.equalTo(20.0)
      make.center.equalTo(collectionView)
    }
  }
  
  override func setProperties() {
    exploreLabel.text = AppText.LanguageKeys.explore.localized
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: SuggestTrendingCVC.self)
    
    containerView.layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMaxXMinYCorner
    ]
    
    blurEffectView.colorTintAlpha = 0.2
    blurEffectView.blurRadius = 20.0
  }
  
  override func setColor() {
    blurEffectView.colorTint = UIColor(rgb: 0xFFFFFF)
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
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    removeFromSuperview()
  }
}

extension SuggestView {
  private func toPlayTrending(_ trending: Trending) {
    guard 
      let topVC = UIApplication.topViewController(),
      let navigationController = topVC.navigationController
    else {
      return
    }
    TrendingManager.shared.play(trending)
    let viewControllers = navigationController.viewControllers.prefix(1)
    let playTrendingVC = PlayTrendingVC()
    navigationController.viewControllers = viewControllers + [playTrendingVC]
  }
}

extension SuggestView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let topVC = UIApplication.topViewController() else {
      return
    }
    let play = { [weak self] in
      guard let self else {
        return
      }
      toPlayTrending(TrendingManager.shared.trendings[indexPath.item])
    }
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .interstitial,
            name: AppText.AdName.interCameraTrending,
            rootViewController: topVC,
            didFail: play,
            didHide: play)
  }
}

extension SuggestView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TrendingManager.shared.trendings.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: SuggestTrendingCVC.self, indexPath: indexPath)
    cell.config(TrendingManager.shared.trendings[indexPath.item])
    return cell
  }
}

extension SuggestView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 110.0, height: collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: .zero,
                        left: 16.0,
                        bottom: .zero,
                        right: 16.0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 8.0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 8.0
  }
}
