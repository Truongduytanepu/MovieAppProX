//
//  UIViewExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension UIView {
  @objc func push(to viewController: UIViewController, animated: Bool) {
    guard let topViewController = UIApplication.topViewController() else {
      return
    }
    topViewController.navigationController?.pushViewController(viewController, animated: animated)
  }
  
  @objc func pop(animated: Bool) {
    guard let topViewController = UIApplication.topViewController() else {
      return
    }
    topViewController.navigationController?.popViewController(animated: animated)
  }
  
  @objc func present(to viewController: UIViewController, animated: Bool) {
    guard let topViewController = UIApplication.topViewController() else {
      return
    }
    topViewController.present(viewController, animated: animated, completion: nil)
  }
  
  func nearestAncestor<T>(ofType type: T.Type) -> T? {
    if let view = self as? T {
      return view
    }
    return superview?.nearestAncestor(ofType: type)
  }
  
  class func loadNib() -> Self {
    return Bundle.main.loadNibNamed(String(describing: Self.className), owner: nil)?.first as! Self
  }
  
  func zoomIn(duration: TimeInterval = 0.2) {
    self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
      self.transform = .identity
    })
  }
  
  func zoomOut(duration: TimeInterval = 0.2) {
    self.transform = .identity
    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
      self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }, completion: { _ in
      self.isHidden = true
    })
  }
  
  func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
    let easeScale = 1.0 + easingOffset
    let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
    let scalingDuration = duration - easingDuration
    UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
      self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
    }, completion: { _ in
      UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.transform = .identity
      })
    })
  }
  
  func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
    let easeScale = 1.0 + easingOffset
    let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
    let scalingDuration = duration - easingDuration
    UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
      self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
    }, completion: { _ in
      UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
      })
    })
  }
  
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
  
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    endEditing(true)
  }
}

@IBDesignable extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    } set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    } set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable var shadowOpacity: CGFloat {
    get {
      return CGFloat(layer.shadowOpacity)
    } set {
      layer.shadowOpacity = Float(newValue / 100)
    }
  }
  
  @IBInspectable var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    } set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable var shadowColor: UIColor? {
    get {
      guard let cgColor = layer.shadowColor else {
        return nil
      }
      return UIColor(cgColor: cgColor)
    } set {
      layer.shadowColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      guard let cgColor = layer.borderColor else {
        return nil
      }
      return UIColor(cgColor: cgColor)
    } set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    } set {
      layer.borderWidth = newValue
    }
  }
}

extension UIView {
  func loadNibNamed() {
    Bundle.main.loadNibNamed(String(describing: Self.className), owner: self)
  }
  
  func addDashedBorder(lineDashPattern: [NSNumber], color: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat) {
    let shapeLayer = CAShapeLayer()
    let frameSize = frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = borderWidth
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = lineDashPattern
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath

    layer.addSublayer(shapeLayer)
  }
}
