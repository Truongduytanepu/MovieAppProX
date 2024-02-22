//
//  FilterCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import UIKit

class FilterCVC: BaseCollectionViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var stateImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
}

extension FilterCVC {
  func config(_ filter: Filter) {
    nameLabel.text = filter.name
    thumbnailImageView.sd_setImage(with: filter.thumbnailURL.getCleanedURL(),
                                   placeholderImage: AppIcon.image(icon: .normal))
  }
  
  func select() {
    containerView.backgroundColor = UIColor(rgb: 0xD7F2FD)
    containerView.borderColor = UIColor(rgb: 0x66AAC8)
    nameLabel.font = AppFont.getFont(fontName: .nunitoBold, size: 16.0)
    stateImageView.isHidden = false
    spaceConstraint.constant = 16.0
    layoutIfNeeded()
  }
  
  func deselect() {
    containerView.backgroundColor = UIColor(rgb: 0xFFFFFF)
    containerView.borderColor = UIColor(rgb: 0xECECEE)
    nameLabel.font = AppFont.getFont(fontName: .nunitoRegular, size: 16.0)
    stateImageView.isHidden = true
    spaceConstraint.constant = 4.0
    layoutIfNeeded()
  }
}
