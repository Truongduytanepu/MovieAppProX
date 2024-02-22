//
//  RecordCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit

class RecordCVC: BaseCollectionViewCell {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var topGradientView: UIView!
  @IBOutlet weak var bottomGradientView: UIView!
  @IBOutlet weak var selectImageView: UIImageView!
  
  override func setColor() {
    let topGradientImage = UIImage.gradientImage(bounds: topGradientView.bounds,
                                                 colors: [
                                                  UIColor(rgb: 0x000000),
                                                  UIColor(rgb: 0x000000, alpha: 0.0)
                                                 ],
                                                 startPoint: .zero,
                                                 endPoint: CGPoint(x: 0.0, y: 1.0))
    let topGradientColor = UIColor(patternImage: topGradientImage)
    topGradientView.backgroundColor = topGradientColor
    
    let bottomGradientImage = UIImage.gradientImage(bounds: bottomGradientView.bounds,
                                                    colors: [
                                                      UIColor(rgb: 0x001924, alpha: 0.0),
                                                      UIColor(rgb: 0x000000, alpha: 0.5)
                                                    ],
                                                    startPoint: .zero,
                                                    endPoint: CGPoint(x: 0.0, y: 1.0))
    let bottomGradientColor = UIColor(patternImage: bottomGradientImage)
    bottomGradientView.backgroundColor = bottomGradientColor
  }
}

extension RecordCVC {
  func config(_ record: RecordObject) {
    durationLabel.text = convertToTime(record.duration)
    let url = FileHelper.shared.getStorageURL(folder: .gallery, fileName: record.thumbnailFilename)
    thumbnailImageView.sd_setImage(with: url,
                                   placeholderImage: AppIcon.image(icon: .normal))
  }
  
  func select() {
    selectImageView.image = AppIcon.image(icon: .selectGallery)
  }
  
  func deselect() {
    selectImageView.image = AppIcon.image(icon: .deselectGallery)
  }
  
  func enableSelect() {
    selectImageView.isHidden = false
  }
  
  func disableSelect() {
    selectImageView.isHidden = true
  }
}

extension RecordCVC {
  private func convertToTime(_ duration: Double) -> String {
    guard duration > 0 else {
      return "00 : 00"
    }
    
    let hours = Int(duration) / 3600
    let minute = (Int(duration) / 60) % 60
    let second = Int(duration) % 60
    var result = String()
    
    if hours >= 10 {
      result += String(hours) + " : "
    } else if hours > 0 {
      result += "0" + String(hours) + " : "
    }
    
    if minute >= 10 {
      result += String(minute) + " : "
    } else {
      result += "0" + String(minute) + " : "
    }
    
    if second >= 10 {
      result += String(second)
    } else {
      result += "0" + String(second)
    }
    
    return result
  }
}
