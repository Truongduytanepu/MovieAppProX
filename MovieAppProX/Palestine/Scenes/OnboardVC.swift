//
//  OnboardVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit
import TrackingSDK
import AdMobManager

class OnboardVC: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageCollectionView: UICollectionView!
  @IBOutlet weak var nextLabel: UILabel!
  @IBOutlet weak var customNativeAdView: CustomNativeAdView!
  
  private var location: CGFloat = 0.0
  private var currentPage: Int = 0 {
    didSet {
      if currentPage == 2 {
        nextLabel.text = AppText.LanguageKeys.begin.localized
      } else {
        nextLabel.text = AppText.LanguageKeys.next.localized
      }
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Global.shared.setShowAppOpen(allow: true)
  }
  
  override func setProperties() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: OnboardCVC.self)
    
    pageCollectionView.delegate = self
    pageCollectionView.dataSource = self
    pageCollectionView.registerNib(ofType: PageCVC.self)
    
    if AdMobManager.shared.status(type: .onceUsed(.native), name: AppText.AdName.nativeOnboard) == true {
      customNativeAdView.load(name: AppText.AdName.nativeOnboard)
    } else {
      customNativeAdView.isHidden = true
    }
  }
  
  @IBAction func onTapNext(_ sender: Any) {
    self.currentPage += 1
    switch currentPage {
    case 1, 2:
      LogEventManager.shared.log(event: .onboardClickNext)
      collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0),
                                  at: .centeredHorizontally,
                                  animated: true)
    default:
      LogEventManager.shared.log(event: .onboardClickBegin)
      skip()
    }
  }
}

extension OnboardVC {
  private func skip() {
    Global.shared.didShowWelcome()
    if let push = Global.shared.pushTrackingConfig,
       push.status,
       push.onboard,
       TrackingSDK.shared.status() {
      let trackingFullScreenView = TrackingFullScreenView()
      trackingFullScreenView.frame = view.frame
      view.addSubview(trackingFullScreenView)
    } else {
      guard let navigationController else {
        return
      }
      navigationController.viewControllers = [LanguageVC()]
    }
  }
}

extension OnboardVC: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.location = (collectionView.contentOffset.x / collectionView.frame.width).roundToDecimals(decimals: 2)
    self.currentPage = Int(location)
    pageCollectionView.reloadData()
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    self.location = (collectionView.contentOffset.x / collectionView.frame.width).roundToDecimals(decimals: 0)
    pageCollectionView.reloadData()
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.currentPage = Int(location)
  }
}

extension OnboardVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int
  ) -> Int {
    return OnboardType.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    switch collectionView.tag {
    case 0:
      let cell = collectionView.dequeue(ofType: OnboardCVC.self, indexPath: indexPath)
      cell.config(OnboardType.allCases[indexPath.item])
      return cell
    default:
      let cell = collectionView.dequeue(ofType: PageCVC.self, indexPath: indexPath)
      cell.updateUI()
      return cell
    }
  }
}

extension OnboardVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView.tag {
    case 0:
      return collectionView.frame.size
    default:
      var location = self.location
      var scale: CGFloat
      if indexPath.item == 0 && location > CGFloat(OnboardType.allCases.count - 1) {
          location -= CGFloat(OnboardType.allCases.count - 1)
          scale = location
      } else {
          scale = 1 - abs(location - CGFloat(indexPath.item))
      }
      if scale < 0 {
          scale = 0
      }
      
      let width = AppSize.Page.onboardMin + (AppSize.Page.onboardMax - AppSize.Page.onboardMin) * scale
      return CGSize(width: width, height: AppSize.Page.onboardMin)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView.tag {
    case 0:
      return .zero
    default:
      return 12.0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView.tag {
    case 0:
      return .zero
    default:
      return 12.0
    }
  }
}
