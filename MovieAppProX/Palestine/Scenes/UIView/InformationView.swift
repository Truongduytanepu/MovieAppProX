//
//  InformationView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit

class InformationView: BaseView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var whyYouLabel: UILabel!
  @IBOutlet weak var becauseLabel: UILabel!
  @IBOutlet weak var okLabel: UILabel!
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override func setProperties() {
    whyYouLabel.text = AppText.LanguageKeys.whyYou.localized
    becauseLabel.text = AppText.LanguageKeys.withinThisApp.localized
    okLabel.text = AppText.LanguageKeys.oke.localized
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    removeFromSuperview()
  }
}
