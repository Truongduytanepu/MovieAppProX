//
//  MusicVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import UIKit
import NVActivityIndicatorView
import SnapKit
import AdMobManager

class MusicVC: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var audioLabel: UILabel!
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
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stopAllPlaying()
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
    audioLabel.text = AppText.LanguageKeys.audio.localized
    doneLabel.text = AppText.LanguageKeys.done.localized
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: MusicCVC.self)
  }
  
  override func binding() {
    MusicManager.shared.$isLoading
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
    
    MusicManager.shared.$playings
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        collectionView.reloadData()
      }.store(in: &subscriptions)
    
    MusicManager.shared.$cacheSelectedMusic
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self else {
          return
        }
        collectionView.reloadData()
      }.store(in: &subscriptions)
    
    if AdMobManager.shared.status(type: .onceUsed(.native), name: AppText.AdName.nativeSounds) == true {
      customNativeAdView.load(name: AppText.AdName.nativeSounds)
    } else {
      customNativeAdView.isHidden = true
    }
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    LogEventManager.shared.log(event: .soundClickEscape)
    MusicManager.shared.clean()
    pop(animated: false)
  }
  
  @IBAction func onTapDone(_ sender: Any) {
    LogEventManager.shared.log(event: .soundClickAdd)
    MusicManager.shared.save()
    pop(animated: false)
  }
}

extension MusicVC {
  private func stopAllPlaying() {
    collectionView.visibleCells.forEach { cell in
      if let cell = cell as? MusicCVC {
        cell.stop()
      }
    }
  }
  
  private func start(indexPath: IndexPath) {
    self.stopAllPlaying()
    guard let cell = collectionView.cellForItem(at: indexPath) as? MusicCVC else {
      return
    }
    cell.start()
  }
}

extension MusicVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let music = MusicManager.shared.playings[indexPath.item]
    MusicManager.shared.choose(music: music)
    if MusicManager.shared.isSelected(music: music) {
      LogEventManager.shared.log(event: .soundClickChoose)
      LogEventManager.shared.log(event: .soundClickPlay)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
        guard let self else {
          return
        }
        start(indexPath: indexPath)
      })
    } else {
      stopAllPlaying()
    }
  }
}

extension MusicVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return MusicManager.shared.playings.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: MusicCVC.self, indexPath: indexPath)
    let music = MusicManager.shared.playings[indexPath.item]
    cell.config(music)
    if MusicManager.shared.isSelected(music: music) {
      cell.select()
    } else {
      cell.deselect()
    }
    return cell
  }
}

extension MusicVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let inset = 12.0
    return CGSize(width: collectionView.frame.width - inset * 2,
                  height: 64.0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 12.0,
                        left: 12.0,
                        bottom: 12.0 + view.safeAreaInsets.bottom,
                        right: 12.0)
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
