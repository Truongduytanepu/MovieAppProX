//
//  ThankRateView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit

class ThankRateView: BaseView {
  @IBOutlet var contentView: UIView!
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override func setProperties() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
      guard let self else {
        return
      }
      removeFromSuperview()
    })
  }
}
