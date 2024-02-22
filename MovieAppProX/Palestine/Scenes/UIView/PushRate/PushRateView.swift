//
//  PushRateView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 30/11/2023.
//

import UIKit

class PushRateView: BaseView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var betterView: UIView!
  @IBOutlet weak var boxTextView: UITextView!
  @IBOutlet weak var star1ImageView: UIImageView!
  @IBOutlet weak var star2ImageView: UIImageView!
  @IBOutlet weak var star3ImageView: UIImageView!
  @IBOutlet weak var star4ImageView: UIImageView!
  @IBOutlet weak var star5ImageView: UIImageView!
  @IBOutlet weak var submitView: UIView!
  @IBOutlet weak var havingLabel: UILabel!
  @IBOutlet weak var supportLabel: UILabel!
  @IBOutlet weak var submitLabel: UILabel!
  @IBOutlet weak var howCanLabel: UILabel!
  
  private var star = 0
  private var isPlaceholder = true
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  override func setProperties() {
    havingLabel.text = AppText.LanguageKeys.having.localized
    supportLabel.text = AppText.LanguageKeys.supportOur.localized
    submitLabel.text = AppText.LanguageKeys.submit.localized
    howCanLabel.text = AppText.LanguageKeys.howCan.localized
    
    hideKeyboardWhenTappedAround()
    boxTextView.delegate = self
    addPlaceholder()
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    removeFromSuperview()
  }
  
  @IBAction func onTap1Star(_ sender: Any) {
    rate(star: 1)
  }
  
  @IBAction func onTap2Star(_ sender: Any) {
    rate(star: 2)
  }
  
  @IBAction func onTap3Star(_ sender: Any) {
    rate(star: 3)
  }
  
  @IBAction func onTap4Star(_ sender: Any) {
    rate(star: 4)
  }
  
  @IBAction func onTap5Star(_ sender: Any) {
    rate(star: 5)
  }
  
  @IBAction func onTapSubmit(_ sender: Any) {
    didRate()
  }
}

extension PushRateView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    guard isPlaceholder else {
      return
    }
    didEnterComment()
  }
  
  func textViewDidChange(_ textView: UITextView) {
    self.isPlaceholder = false
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    guard boxTextView.text.isEmpty else {
      return
    }
    addPlaceholder()
  }
}

extension PushRateView {
  private func rate(star: Int) {
    self.star = star
    updateStar()
    submitView.isUserInteractionEnabled = true
    submitView.backgroundColor = UIColor(rgb: 0x7FD4FA)
    
    if star >= 4 {
      RatingApp.shared.ratingOnAppStore()
      didRate()
    } else {
      betterView.isHidden = false
    }
  }
  
  private func didRate() {
    RatingApp.shared.didRate()
    RatingApp.shared.showThanksRate()
    removeFromSuperview()
  }
  
  private func addPlaceholder() {
    self.isPlaceholder = true
    boxTextView.text = AppText.LanguageKeys.yourFeedback.localized
    boxTextView.textColor = UIColor(rgb: 0x777373)
  }
  
  private func didEnterComment() {
    boxTextView.text = String()
    boxTextView.textColor = UIColor(rgb: 0x1C1516)
  }
  
  private func updateStar() {
    star1ImageView.image = AppIcon.image(icon: .enableStar)
    star2ImageView.image = AppIcon.image(icon: star >= 2 ? .enableStar : .disableStar)
    star3ImageView.image = AppIcon.image(icon: star >= 3 ? .enableStar : .disableStar)
    star4ImageView.image = AppIcon.image(icon: star >= 4 ? .enableStar : .disableStar)
    star5ImageView.image = AppIcon.image(icon: star == 5 ? .enableStar : .disableStar)
  }
}
