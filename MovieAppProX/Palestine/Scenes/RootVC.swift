//
//  HomeVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import AdMobManager

class RootVC: BaseViewController {
  @IBOutlet weak var cameraView: UIView!
  @IBOutlet weak var homeImageView: UIImageView!
  @IBOutlet weak var homeLabel: UILabel!
  @IBOutlet weak var galleryImageView: UIImageView!
  @IBOutlet weak var galleryLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var cameraLabel: UILabel!
  @IBOutlet weak var customBannerAdView: CustomBannerAdView!
  
  private let tabBars: [TabBarType] = [.home, .gallery]
  private var stateTab: TabBarType = .home
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Global.shared.setShowAppOpen(allow: true)
    
    if Global.shared.pushUpdate() {
      Global.shared.showPushUpdate()
    } else {
      RatingApp.shared.showRateHome()
    }
    Global.shared.showInformation()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    MusicManager.shared.remove()
    LoadingManager.shared.remove()
  }
  
  override func setProperties() {
    cameraLabel.text = AppText.LanguageKeys.camera.localized
    homeLabel.text = AppText.LanguageKeys.home.localized
    galleryLabel.text = AppText.LanguageKeys.gallery.localized
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: HomeCVC.self)
    collectionView.registerNib(ofType: GalleryCVC.self)
  }
  
  override func setColor() {
    let gradientImage = UIImage.gradientImage(bounds: cameraView.bounds,
                                              colors: [
                                                UIColor(rgb: 0x79BEDB),
                                                UIColor(rgb: 0x7D94FB)
                                              ],
                                              startPoint: .zero,
                                              endPoint: CGPoint(x: 0.0, y: 1.0))
    let gradientColor = UIColor(patternImage: gradientImage)
    cameraView.backgroundColor = gradientColor
  }
  
  override func binding() {
    if AdMobManager.shared.status(type: .onceUsed(.banner), name: AppText.AdName.collapGalleryItems) == true {
      customBannerAdView.load(name: AppText.AdName.collapGalleryItems)
    } else {
      customBannerAdView.isHidden = true
    }
  }
  
  @IBAction func onTapHome(_ sender: Any) {
    LogEventManager.shared.log(event: .homeClickHome)
    changeTab(type: .home)
  }
  
  @IBAction func onTapGallery(_ sender: Any) {
    LogEventManager.shared.log(event: .homeClickGallery)
    changeTab(type: .gallery)
  }
  
  @IBAction func onTapCamera(_ sender: Any) {
    LoadingManager.shared.show()
    switch stateTab {
    case .home:
      LogEventManager.shared.log(event: .homeClickTry)
      AdMobManager
        .shared
        .show(type: .interstitial,
              name: AppText.AdName.interHomeTrending,
              rootViewController: self,
              didFail: toRecord,
              didHide: toRecord)
    case .gallery:
      if GalleryManager.shared.records.isEmpty {
        LogEventManager.shared.log(event: .emptyClickCamera)
        AdMobManager
          .shared
          .show(type: .interstitial,
                name: AppText.AdName.interstitialEmpty,
                rootViewController: self,
                didFail: toRecord,
                didHide: toRecord)
      } else {
        toRecord()
      }
    }
  }
}

extension RootVC {
  private func toRecord() {
    MusicManager.shared.changeDefault() 
    push(to: RecordVC(), animated: false)
  }
  
  private func changeTab(type: TabBarType) {
    self.stateTab = type
    collectionView.selectItem(at: IndexPath(item: type.rawValue, section: 0),
                              animated: false,
                              scrollPosition: .centeredHorizontally)
    
    homeImageView.image = AppIcon.image(icon: type == .home ? .homeSelectTabBar : .homeDeselectTabBar)
    homeLabel.font = AppFont.getFont(fontName: type == .home ? .nunitoExtraBold : .nunitoRegular, size: 14.0)
    homeLabel.textColor = UIColor(rgb: type == .home ? 0x7FD4FA : 0xF2FBFF)
    
    galleryImageView.image = AppIcon.image(icon: type == .gallery ? .gallerySelectTabBar : .galleryDeselectTabBar)
    galleryLabel.font = AppFont.getFont(fontName: type == .gallery ? .nunitoExtraBold : .nunitoRegular, size: 14.0)
    galleryLabel.textColor = UIColor(rgb: type == .gallery ? 0x7FD4FA : 0xF2FBFF)
  }
}

extension RootVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return TabBarType.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch TabBarType.allCases[indexPath.item] {
    case .home:
      return collectionView.dequeue(ofType: HomeCVC.self, indexPath: indexPath)
    case .gallery:
      return collectionView.dequeue(ofType: GalleryCVC.self, indexPath: indexPath)
    }
  }
}

extension RootVC: UICollectionViewDelegateFlowLayout {
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
