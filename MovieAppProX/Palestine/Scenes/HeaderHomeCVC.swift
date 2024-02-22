//
//  HeaderHomeCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit

class HeaderHomeCVC: BaseCollectionViewCell {
  @IBOutlet weak var tryNowView: UIView!
  @IBOutlet weak var tryNowLabel: UILabel!
  @IBOutlet weak var trendingLabel: UILabel!
  
  private var task: Task<(), Error>?
  
  override func setProperties() {
    tryNowLabel.text = AppText.LanguageKeys.tryNow.localized
    trendingLabel.text = AppText.LanguageKeys.trending.localized
    
    tryNowView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(toRecord)))
  }
  
  override func setColor() {
    let gradientImage = UIImage.gradientImage(bounds: tryNowView.bounds,
                                              colors: [
                                                UIColor(rgb: 0x79BEDB),
                                                UIColor(rgb: 0x7D94FB)
                                              ],
                                              startPoint: .zero,
                                              endPoint: CGPoint(x: 0.0, y: 1.0))
    let gradientColor = UIColor(patternImage: gradientImage)
    tryNowView.backgroundColor = gradientColor
  }
}

extension HeaderHomeCVC {
  @objc private func toRecord() {
    LogEventManager.shared.log(event: .homeClickBanner)
    MusicManager.shared.changeDefault()
    push(to: RecordVC(), animated: false)
  }
}
