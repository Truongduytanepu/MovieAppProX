//
//  CanvasView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import UIKit

class CanvasView: BaseView {
  @IBOutlet var contentView: UIView!
  
  private lazy var pointImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = AppIcon.image(icon: .point0)
    imageView.isHidden = true
    return imageView
  }()
  
  @Published private(set) var lastPoint: CGPoint?
  private var lines = [Line]()
  private var isDraw = false
  private var isTouching = false
  private let strokeColor = UIColor(rgb: 0x7A0000)
  private let strokeOpacity = 0.8
  private let strokeWidth = 15.0
  private var melonSeeds = 0
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    lines.forEach { line in
      for (index, point) in line.points.enumerated() {
        if index == 0 {
          context.move(to: point)
        } else {
          context.addLine(to: point)
        }
      }
      context.setStrokeColor(line.color.withAlphaComponent(line.opacity).cgColor)
      context.setLineWidth(line.width)
      context.setLineCap(.round)
      context.strokePath()
    }
    
    guard isTouching, let lastPoint else {
      return
    }
    pointImageView.center = lastPoint
    pointImageView.isHidden = false
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard isDraw else {
      return
    }
    guard let touch = touches.first else {
      return
    }
    let startPoint = touch.location(in: self)
    self.isTouching = true
    let newLine = Line(color: strokeColor,
                       width: strokeWidth,
                       opacity: strokeOpacity,
                       points: [startPoint])
    lines.append(newLine)
    setNeedsDisplay()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard isTouching, let touch = touches.first else {
      return
    }
    let currentPoint = touch.location(in: self)
    self.lastPoint = currentPoint
    
    guard !lines.isEmpty else {
      return
    }
    var lastLine = lines.removeLast()
    lastLine.points.append(currentPoint)
    lines.append(lastLine)
    
    setNeedsDisplay()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.lastPoint = nil
    if isTouching {
      self.isTouching = false
      setNeedsDisplay()
    }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchesEnded(touches, with: event)
  }
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
    addSubview(pointImageView)
  }
  
  override func setConstraints() {
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    pointImageView.frame.size = CGSize(width: 70.0, height: 70.0)
  }
}

extension CanvasView {
  func setDraw(enable: Bool) {
    self.isDraw = enable
  }
  
  func addMelonSeeds() {
    self.melonSeeds += 1
    pointImageView.image = UIImage(named: "point\(melonSeeds)")
  }
  
  func animation(completion: Handler?) {
    lines.removeAll()
    setNeedsDisplay()
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self else {
        return
      }
      pointImageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    } completion: { _ in
      UIView.animate(withDuration: 0.5) { [weak self] in
        guard let self else {
          return
        }
        pointImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        pointImageView.alpha = 0.0
      } completion: { _ in
        completion?()
      }
    }
  }
}
