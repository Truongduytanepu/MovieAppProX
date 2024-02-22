//
//  PlayTrendingVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import AdMobManager
import TrackingSDK

class PlayTrendingVC: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var creditView: UIView!
  @IBOutlet weak var creditLabel: UILabel!
  @IBOutlet weak var customBannerAdView: CustomBannerAdView!
  
  private var stateIndexPath = IndexPath(item: 0, section: 0)
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    pushTracking()
    LoadingManager.shared.remove()
    reStart()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stopAllPlaying()
  }
  
  override func setProperties() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: PlayTrendingCVC.self)
  }
  
  override func binding() {
    TrendingManager.shared.$playings
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
          guard let self else {
            return
          }
          reStart()
        }
      }.store(in: &subscriptions)
    
    CreditManager.shared.$remainingFree
      .receive(on: DispatchQueue.main)
      .sink { [weak self] remainingFree in
        guard let self else {
          return
        }
        creditLabel.text = String(remainingFree)
      }.store(in: &subscriptions)
    
    if AdMobManager.shared.status(type: .onceUsed(.banner), name: AppText.AdName.collapsibleTrendingDetail) == true {
      customBannerAdView.load(name: AppText.AdName.collapsibleTrendingDetail)
    } else {
      customBannerAdView.isHidden = true
    }
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    LogEventManager.shared.log(event: .trendingClickBack)
    let back = { [weak self] in
      guard let self else {
        return
      }
      pop(animated: false)
    }
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .interstitial,
            name: AppText.AdName.interTrendingBack,
            rootViewController: self,
            didFail: back,
            didHide: back)
  }
  
  @IBAction func onTapCredit(_ sender: Any) {
    LogEventManager.shared.log(event: .trendingClickUses)
    let rewardView = RewardView()
    rewardView.frame = view.frame
    view.addSubview(rewardView)
  }
}

extension PlayTrendingVC {
  private func pushTracking() {
    guard
      let push = Global.shared.pushTrackingConfig,
      push.status,
      push.trending,
      TrackingSDK.shared.status()
    else {
      return
    }
    let trackingPopupView = TrackingPopupView()
    trackingPopupView.frame = view.frame
    view.addSubview(trackingPopupView)
  }
  
  private func stopAllPlaying() {
    collectionView.visibleCells.forEach { cell in
      if let cell = cell as? PlayTrendingCVC {
        cell.stop()
      }
    }
  }
  
  private func start(indexPath: IndexPath) {
    guard stateIndexPath != indexPath else {
      return
    }
    self.stopAllPlaying()
    self.stateIndexPath = indexPath
    guard let cell = collectionView.cellForItem(at: indexPath) as? PlayTrendingCVC else {
      return
    }
    cell.start()
  }
  
  private func reStart() {
    guard let cell = collectionView.cellForItem(at: stateIndexPath) as? PlayTrendingCVC else {
      return
    }
    cell.start()
  }
}

extension PlayTrendingVC: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let location = scrollView.contentOffset.y / collectionView.frame.height
    guard !location.isNaN else {
      return
    }
    start(indexPath: IndexPath(item: Int(location + 0.5), section: 0))
  }
}

extension PlayTrendingVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TrendingManager.shared.playings.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: PlayTrendingCVC.self, indexPath: indexPath)
    cell.config(TrendingManager.shared.playings[indexPath.item])
    return cell
  }
}

extension PlayTrendingVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.frame.size
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return .zero
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
