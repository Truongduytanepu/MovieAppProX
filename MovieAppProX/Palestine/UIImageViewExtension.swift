//
//  UIImageViewExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension UIImageView {
  func realImageRect() -> CGRect {
    let imageViewSize = frame.size
    let imgSize = image?.size
    
    guard let imageSize = imgSize else {
      return CGRect.zero
    }
    
    let aspect = fmin(imageViewSize.width / imageSize.width, imageViewSize.height / imageSize.height)
    
    var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
    
    imageRect.origin.x = (imageViewSize.width - imageRect.width) / 2
    imageRect.origin.y = (imageViewSize.height - imageRect.height) / 2
    
    imageRect.origin.x += frame.origin.x
    imageRect.origin.y += frame.origin.y
    
    return imageRect
  }
  
  func pulsate(from value: Float, to secondValue: Float, duration: CGFloat = 1.0, repeatCount: Float = 2) {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = duration
    pulse.fromValue = value
    pulse.toValue = secondValue
    pulse.autoreverses = true
    pulse.repeatCount = repeatCount
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    
    layer.add(pulse, forKey: "pulse")
  }
  
  func flash() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.2
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 3
    
    layer.add(flash, forKey: nil)
  }
  
  func shake() {
    let shake = CABasicAnimation(keyPath: "position")
    shake.duration = 0.05
    shake.repeatCount = 2
    shake.autoreverses = true
    
    let fromPoint = CGPoint(x: center.x - 5, y: center.y)
    let fromValue = NSValue(cgPoint: fromPoint)
    
    let toPoint = CGPoint(x: center.x + 5, y: center.y)
    let toValue = NSValue(cgPoint: toPoint)
    
    shake.fromValue = fromValue
    shake.toValue = toValue
    
    layer.add(shake, forKey: "position")
  }
}
