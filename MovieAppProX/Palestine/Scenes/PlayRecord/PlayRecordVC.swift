//
//  PlayRecordVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit

class PlayRecordVC: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var discardView: UIView!
  @IBOutlet weak var deleteThisLabel: UILabel!
  @IBOutlet weak var youWonLabel: UILabel!
  @IBOutlet weak var deleteLabel: UILabel!
  @IBOutlet weak var discardLabel: UILabel!
  
  private var stateIndexPath = IndexPath(item: 0, section: 0)
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reStart()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stopAllPlaying()
  }
  
  override func setProperties() {
    deleteThisLabel.text = AppText.LanguageKeys.deleteThis.localized
    youWonLabel.text = AppText.LanguageKeys.youWon.localized
    deleteLabel.text = AppText.LanguageKeys.delete.localized
    discardLabel.text = AppText.LanguageKeys.discard.localized
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerNib(ofType: PlayRecordCVC.self)
  }
  
  override func binding() {
    GalleryManager.shared.$playings
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
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    pop(animated: false)
  }
  
  @IBAction func onTapDelete(_ sender: Any) {
    LogEventManager.shared.log(event: .itemClickDelete)
    discardView.isHidden = false
  }
  
  @IBAction func onTapYes(_ sender: Any) {
    discardView.isHidden = true
    stopAllPlaying()
    let record = GalleryManager.shared.playings[stateIndexPath.item]
    GalleryManager.shared.delete(record)
    if GalleryManager.shared.playings.isEmpty {
      pop(animated: false)
    }
  }
  
  @IBAction func onTapDiscard(_ sender: Any) {
    LogEventManager.shared.log(event: .itemClickDeleteDiscard)
    discardView.isHidden = true
  }
}

extension PlayRecordVC {
  private func stopAllPlaying() {
    collectionView.visibleCells.forEach { cell in
      if let cell = cell as? PlayRecordCVC {
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
    guard let cell = collectionView.cellForItem(at: indexPath) as? PlayRecordCVC else {
      return
    }
    cell.start()
  }
  
  private func reStart() {
    guard let cell = collectionView.cellForItem(at: stateIndexPath) as? PlayRecordCVC else {
      return
    }
    cell.start()
  }
}

extension PlayRecordVC: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let location = scrollView.contentOffset.y / collectionView.frame.height
    guard !location.isNaN else {
      return
    }
    start(indexPath: IndexPath(item: Int(location + 0.5), section: 0))
  }
}

extension PlayRecordVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return GalleryManager.shared.playings.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(ofType: PlayRecordCVC.self, indexPath: indexPath)
    cell.config(GalleryManager.shared.playings[indexPath.item])
    return cell
  }
}

extension PlayRecordVC: UICollectionViewDelegateFlowLayout {
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
