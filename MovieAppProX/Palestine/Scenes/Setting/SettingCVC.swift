//
//  SettingCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit

class SettingCVC: BaseCollectionViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
}

extension SettingCVC {
  func config(_ type: SettingType) {
    nameLabel.text = type.name
    thumbnailImageView.image = AppIcon.image(icon: type.icon)
  }
}
