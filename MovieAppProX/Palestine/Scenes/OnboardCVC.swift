//
//  OnboardCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit

class OnboardCVC: BaseCollectionViewCell {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var gradientView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  
  override func setColor() {
    let gradientImage = UIImage.gradientImage(bounds: gradientView.bounds,
                                              colors: [
                                                UIColor(rgb: 0xFFFFFF, alpha: 0.0),
                                                UIColor(rgb: 0xFFFFFF, alpha: 0.7),
                                                UIColor(rgb: 0xFFFFFF, alpha: 1.0)
                                              ],
                                              startPoint: .zero,
                                              endPoint: CGPoint(x: 0.0, y: 1.0))
    let gradientColor = UIColor(patternImage: gradientImage)
    gradientView.backgroundColor = gradientColor
  }
}

extension OnboardCVC {
  func config(_ step: OnboardType) {
    thumbnailImageView.image = AppIcon.image(icon: step.icon)
    nameLabel.text = step.title
  }
}
