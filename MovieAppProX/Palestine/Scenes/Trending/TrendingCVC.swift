//
//  TrendingCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import SDWebImage

class TrendingCVC: BaseCollectionViewCell {
  @IBOutlet weak var likeLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var topGradientView: UIView!
  @IBOutlet weak var bottomGradientView: UIView!
  
  override func setColor() {
    let topGradientImage = UIImage.gradientImage(bounds: topGradientView.bounds,
                                                 colors: [
                                                  UIColor(rgb: 0x000000, alpha: 0.4),
                                                  UIColor(rgb: 0x000000, alpha: 0.0)
                                                 ],
                                                 startPoint: .zero,
                                                 endPoint: CGPoint(x: 0.0, y: 1.0))
    let topGradientColor = UIColor(patternImage: topGradientImage)
    topGradientView.backgroundColor = topGradientColor
    
    let bottomGradientImage = UIImage.gradientImage(bounds: bottomGradientView.bounds,
                                                    colors: [
                                                      UIColor(rgb: 0x001924, alpha: 0.0),
                                                      UIColor(rgb: 0x000000, alpha: 0.5)
                                                    ],
                                                    startPoint: .zero,
                                                    endPoint: CGPoint(x: 0.0, y: 1.0))
    let bottomGradientColor = UIColor(patternImage: bottomGradientImage)
    bottomGradientView.backgroundColor = bottomGradientColor
  }
}

extension TrendingCVC {
  func config(_ trending: Trending) {
    likeLabel.text = convertLike(trending.like)
    nameLabel.text = trending.name
    descriptionLabel.text = trending.description
    thumbnailImageView.sd_setImage(with: trending.thumbnailURL.getCleanedURL(),
                                   placeholderImage: AppIcon.image(icon: .normal))
  }
}

extension TrendingCVC {
  private func convertLike(_ value: Int) -> String {
    return String((Double(value) / 1_000_000.0).roundToDecimals(decimals: 1)) + "M"
  }
}
