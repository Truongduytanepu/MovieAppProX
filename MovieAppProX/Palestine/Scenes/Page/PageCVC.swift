//
//  PageCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit

class PageCVC: BaseCollectionViewCell {
  @IBOutlet weak var containerView: UIView!
}

extension PageCVC {
  func updateUI() {
    if frame.width > AppSize.Page.onboardMin {
      containerView.backgroundColor = UIColor(rgb: 0x7FD4FA)
    } else {
      containerView.backgroundColor = UIColor(rgb: 0xC7CACE)
    }
  }
}
