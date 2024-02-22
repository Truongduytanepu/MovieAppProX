//
//  CustomNativeAdView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 01/12/2023.
//

import UIKit
import AdMobManager
import SnapKit
import NVActivityIndicatorView
import GoogleMobileAds

class CustomNativeAdView: NativeAdMobView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var nativeAdView: GADNativeAdView!
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let loadingView = NVActivityIndicatorView(frame: .zero)
    loadingView.type = .ballPulse
    loadingView.padding = 25.0
    loadingView.color = UIColor(rgb: 0x000000)
    return loadingView
  }()
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
    addSubview(loadingView)
  }
  
  override func setConstraints() {
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    loadingView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalTo(20)
    }
  }
  
  override func setProperties() {
    startAnimation()
    binding(nativeAdView: nativeAdView) { [weak self] in
      guard let self = self else {
        return
      }
      self.stopAnimation()
    }
  }
}

extension CustomNativeAdView {
  func config(name: String) {
    load(name: name, rootViewController: nil)
  }
  
  private func startAnimation() {
    nativeAdView.isHidden = true
    loadingView.startAnimating()
  }
  
  private func stopAnimation() {
    nativeAdView.isHidden = false
    loadingView.stopAnimating()
  }
}
