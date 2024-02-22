//
//  SuggestTrendingCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit

class SuggestTrendingCVC: BaseCollectionViewCell {
  @IBOutlet weak var likeView: UIView!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var likeLabel: UILabel!
  
  override func setProperties() {
    likeView.layer.borderWidth = 0.5
  }
}

extension SuggestTrendingCVC {
  func config(_ trending: Trending) {
    likeLabel.text = convertLike(trending.like)
    thumbnailImageView.sd_setImage(with: trending.thumbnailURL.getCleanedURL(),
                                   placeholderImage: AppIcon.image(icon: .normal))
  }
}

extension SuggestTrendingCVC {
  private func convertLike(_ value: Int) -> String {
    return String((Double(value) / 1_000_000.0).roundToDecimals(decimals: 1)) + "M"
  }
}
