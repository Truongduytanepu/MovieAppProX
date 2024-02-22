//
//  LanguageVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit
import AdMobManager

class LanguageVC: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var customNativeAdView: CustomNativeAdView!
  
  private var choseLanguage: Language?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  override func setProperties() {
    languageLabel.text = AppText.LanguageKeys.language.localized
    
    self.choseLanguage = LanguageManager.shared.getChoseLanguage()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: LanguageCVC.self)
  }
  
  override func binding() {
    if AdMobManager.shared.status(type: .onceUsed(.native), name: AppText.AdName.nativeLanguage) == true {
      customNativeAdView.load(name: AppText.AdName.nativeLanguage)
    } else {
      customNativeAdView.isHidden = true
    }
  }
  
  @IBAction func onTapDone(_ sender: UITapGestureRecognizer) {
    LogEventManager.shared.log(event: .languageClickSave)
    if let choseLanguage = choseLanguage {
      LanguageManager.shared.setChoseLanguage(choseLanguage)
    }
    guard let navigationController else {
      return
    }
    navigationController.viewControllers = [RootVC()]
  }
}

extension LanguageVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let leftInset = 24.0
    let rightInset = 24.0
    return CGSize(width: collectionView.frame.width - leftInset - rightInset, height: 60.0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16.0,
                        left: 24.0,
                        bottom: 16.0 + view.safeAreaInsets.bottom,
                        right: 24.0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 8.0
  }
}

extension LanguageVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int
  ) -> Int {
    return Language.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: LanguageCVC.self, indexPath: indexPath)
    cell.config(language: Language.allCases[indexPath.item])
    if let choseLanguage = choseLanguage, choseLanguage == Language.allCases[indexPath.item] {
      cell.select()
    } else {
      cell.deselect()
    }
    return cell
  }
}

extension LanguageVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath
  ) {
    if let choseLanguage = choseLanguage,
       let cell = collectionView.cellForItem(at: IndexPath(item: choseLanguage.rawValue, section: 0)) as? LanguageCVC {
      cell.deselect()
    }
    self.choseLanguage = Language.allCases[indexPath.item]
    if let cell = collectionView.cellForItem(at: indexPath) as? LanguageCVC {
      cell.select()
    }
  }
}
