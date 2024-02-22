//
//  GalleryCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit

class GalleryCVC: BaseCollectionViewCell {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyStackView: UIStackView!
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var containerMenuView: UIView!
  @IBOutlet weak var leftImageView: UIImageView!
  @IBOutlet weak var rightImageView: UIImageView!
  @IBOutlet weak var selectView: UIView!
  @IBOutlet weak var clearView: UIView!
  @IBOutlet weak var discardView: UIView!
  @IBOutlet weak var deleteView: UIView!
  @IBOutlet weak var selectDiscardView: UIView!
  @IBOutlet weak var emptyLabel: UILabel!
  @IBOutlet weak var selectLabel: UILabel!
  @IBOutlet weak var clearLabel: UILabel!
  @IBOutlet weak var deleteThisLabel: UILabel!
  @IBOutlet weak var youWonLabel: UILabel!
  @IBOutlet weak var deleteLabel: UILabel!
  @IBOutlet weak var discardLabel: UILabel!
  @IBOutlet weak var galleryLabel: UILabel!
  
  enum Mode {
    case present
    case all
    case select
  }
  
  @Published private(set) var stateMode: Mode = .present
  
  override func setProperties() {
    galleryLabel.text = AppText.LanguageKeys.gallery.localized
    emptyLabel.text = AppText.LanguageKeys.yourGallery.localized
    selectLabel.text = AppText.LanguageKeys.select.localized
    clearLabel.text = AppText.LanguageKeys.clearAllGallery.localized
    deleteThisLabel.text = AppText.LanguageKeys.deleteThis.localized
    youWonLabel.text = AppText.LanguageKeys.youWon.localized
    deleteLabel.text = AppText.LanguageKeys.delete.localized
    discardLabel.text = AppText.LanguageKeys.discard.localized
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: RecordCVC.self)
    
    menuView.layer.maskedCorners = [
      .layerMinXMinYCorner,
      .layerMinXMaxYCorner,
      .layerMaxXMaxYCorner
    ]
    
    leftImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(onTapLeft)))
    
    rightImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(onTapRight)))
    
    containerMenuView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(onTapCancel)))
    
    selectView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(onTapSelect)))
    
    clearView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(onTapClear)))
    
    deleteView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(onTapDelete)))
    
    selectDiscardView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(onTapDiscard)))
  }
  
  override func binding() {
    GalleryManager.shared.$records
      .receive(on: DispatchQueue.main)
      .sink { [weak self] records in
        guard let self else {
          return
        }
        emptyStackView.isHidden = !records.isEmpty
        collectionView.reloadData()
        selectView.alpha = records.isEmpty ? 0.5 : 1.0
        clearView.alpha = records.isEmpty ? 0.5 : 1.0
      }.store(in: &subscriptions)
    
    GalleryManager.shared.$cacheSelecteds
      .receive(on: DispatchQueue.main)
      .sink { [weak self] cacheSelecteds in
        guard let self else {
          return
        }
        collectionView.reloadData()
        switch stateMode {
        case .select:
          rightImageView.alpha = cacheSelecteds.isEmpty ? 0.5 : 1.0
        default:
          rightImageView.alpha = 1.0
        }
      }.store(in: &subscriptions)
    
    $stateMode
      .receive(on: DispatchQueue.main)
      .sink { [weak self] stateMode in
        guard let self else {
          return
        }
        switch stateMode {
        case .select:
          leftImageView.image = AppIcon.image(icon: .backLight)
          rightImageView.image = AppIcon.image(icon: .deleteGallery)
          rightImageView.alpha = 0.5
          enableSelect()
        default:
          leftImageView.image = AppIcon.image(icon: .menuSetting)
          rightImageView.image = AppIcon.image(icon: .menuGallery)
          disableSelect()
        }
      }.store(in: &subscriptions)
  }
}

extension GalleryCVC {
  @objc private func onTapLeft() {
    switch stateMode {
    case .select:
      self.stateMode = .present
      GalleryManager.shared.cleanCache()
    default:
      guard let topVC = UIApplication.topViewController() else {
        return
      }
      let settingView = SettingView()
      settingView.frame = topVC.view.frame
      topVC.view.addSubview(settingView)
    }
  }
  
  @objc private func onTapRight() {
    switch stateMode {
    case .present:
      LogEventManager.shared.log(event: .galleryClickOption)
      containerMenuView.isHidden = false
    case .select:
      guard !GalleryManager.shared.cacheSelecteds.isEmpty else {
        return
      }
      discardView.isHidden = false
    default:
      break
    }
  }
  
  @objc private func onTapCancel() {
    containerMenuView.isHidden = true
  }
  
  @objc private func onTapSelect() {
    guard !GalleryManager.shared.records.isEmpty else {
      return
    }
    LogEventManager.shared.log(event: .galleryClickOptionSelect)
    self.stateMode = .select
    containerMenuView.isHidden = true
  }
  
  @objc private func onTapClear() {
    guard !GalleryManager.shared.records.isEmpty else {
      return
    }
    LogEventManager.shared.log(event: .galleryClickOptionClear)
    self.stateMode = .all
    containerMenuView.isHidden = true
    discardView.isHidden = false
  }
  
  @objc private func onTapDelete() {
    discardView.isHidden = true
    switch stateMode {
    case .select:
      GalleryManager.shared.deleteSelected()
      if GalleryManager.shared.records.isEmpty {
        self.stateMode = .present
      }
    case .all:
      GalleryManager.shared.deleteAll()
      self.stateMode = .present
    default:
      break
    }
  }
  
  @objc private func onTapDiscard() {
    discardView.isHidden = true
    switch stateMode {
    case .all:
      self.stateMode = .present
    default:
      break
    }
  }
  
  private func disableSelect() {
    collectionView.visibleCells.forEach { cell in
      if let cell = cell as? RecordCVC {
        cell.disableSelect()
      }
    }
  }
  
  private func enableSelect() {
    collectionView.visibleCells.forEach { cell in
      if let cell = cell as? RecordCVC {
        cell.enableSelect()
      }
    }
  }
}

extension GalleryCVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let record = GalleryManager.shared.records[indexPath.item]
    switch stateMode {
    case .present:
      GalleryManager.shared.play(record)
      push(to: PlayRecordVC(), animated: false)
    case .select:
      GalleryManager.shared.choose(record)
    default:
      break
    }
  }
}

extension GalleryCVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return GalleryManager.shared.records.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: RecordCVC.self, indexPath: indexPath)
    let record = GalleryManager.shared.records[indexPath.item]
    cell.config(record)
    if GalleryManager.shared.isSelected(record) {
      cell.select()
    } else {
      cell.deselect()
    }
    switch stateMode {
    case .present, .all:
      cell.disableSelect()
    case .select:
      cell.enableSelect()
    }
    return cell
  }
}

extension GalleryCVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sumInset = 16.0 * 2
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
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 16.0,
                        left: 16.0,
                        bottom: safeAreaInsets.bottom + 134.0 + 16.0,
                        right: 16.0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 16.0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 16.0
  }
}
