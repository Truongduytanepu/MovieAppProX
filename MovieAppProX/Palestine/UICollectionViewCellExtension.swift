//
//  UICollectionViewCellExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension UICollectionViewCell {
  func getIndexPath() -> IndexPath? {
    guard let collectionView = nearestAncestor(ofType: UICollectionView.self) else {
      return nil
    }
    return collectionView.indexPath(for: self)
  }
}
