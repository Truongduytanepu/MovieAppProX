//
//  C.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import Foundation
import QuartzCore

extension CAGradientLayer {
  class func create(colors: [CGColor],
                    locations: [NSNumber],
                    affineTransform: CGAffineTransform,
                    bounds: CGRect
  ) -> CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.colors = colors
    gradient.locations = locations
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: 1)
    gradient.transform = CATransform3DMakeAffineTransform(affineTransform)
    gradient.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
    gradient.position = CGPoint(x: bounds.midX, y: bounds.midY)
    return gradient
  }
}
