//
//  FilterVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import UIKit
import NVActivityIndicatorView
import SnapKit
import AdMobManager

class FilterVC: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var chooseLabel: UILabel!
  @IBOutlet weak var doneLabel: UILabel!
  @IBOutlet weak var customNativeAdView: CustomNativeAdView!
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let loadingView = NVActivityIndicatorView(frame: .zero)
    loadingView.type = .ballSpinFadeLoader
    loadingView.padding = 30.0
    loadingView.color = UIColor(rgb: 0x000000)
    return loadingView
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  override func addComponents() {
    view.addSubview(loadingView)
  }
  
  override func setConstraints() {
    loadingView.snp.makeConstraints { make in
      make.width.height.equalTo(20.0)
      make.center.equalTo(collectionView)
    }
  }
  
  override func setProperties() {
    chooseLabel.text = AppText.LanguageKeys.chooseFilter.localized
    doneLabel.text = AppText.LanguageKeys.done.localized
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: FilterCVC.self)
  }
  
  override func binding() {
    FilterManager.shared.$isLoading
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
    
    FilterManager.shared.$filters
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        collectionView.reloadData()
      }.store(in: &subscriptions)
    
    if AdMobManager.shared.status(type: .onceUsed(.native), name: AppText.AdName.nativeFilter) == true {
      customNativeAdView.load(name: AppText.AdName.nativeFilter)
    } else {
      customNativeAdView.isHidden = true
    }
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    pop(animated: false)
  }
  
  @IBAction func onTapDone(_ sender: Any) {
    LogEventManager.shared.log(event: .filterClick1st)
    LogEventManager.shared.log(event: .filterClickDone)
    pop(animated: false)
  }
}

extension FilterVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return FilterManager.shared.filters.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: FilterCVC.self, indexPath: indexPath)
    let filter = FilterManager.shared.filters[indexPath.item]
    cell.config(filter)
    if FilterManager.shared.isSelected(filter: filter) {
      cell.select()
    } else {
      cell.deselect()
    }
    return cell
  }
}

extension FilterVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let sumInset = 24.0 * 2
    let groupSpace = 20.0
    let numberGroupOnPhone = 2.0
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
    return CGSize(width: width, height: (width - 16.0 * 2) + 80.0)
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
                      minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 24.0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20.0
  }
}
