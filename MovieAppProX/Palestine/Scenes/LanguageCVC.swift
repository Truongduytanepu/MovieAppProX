//
//  LanguageCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit

class LanguageCVC: BaseCollectionViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var ensignImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var chooseImageView: UIImageView!
}

extension LanguageCVC {
  func config(language: Language) {
    ensignImageView.image = AppIcon.image(icon: language.ensign)
    nameLabel.text = language.name
  }
  
  func select() {
    chooseImageView.image = AppIcon.image(icon: .selectLanguage)
    nameLabel.font = AppFont.getFont(fontName: .nunitoExtraBold, size: 18.0)
    nameLabel.textColor = UIColor(rgb: 0x7FD4FA)
    containerView.layer.borderWidth = 2.0
  }
  
  func deselect() {
    chooseImageView.image = AppIcon.image(icon: .deselectLanguage)
    nameLabel.font = AppFont.getFont(fontName: .nunitoRegular, size: 16.0)
    nameLabel.textColor = UIColor(rgb: 0x20293C)
    containerView.layer.borderWidth = 0.0
  }
}
