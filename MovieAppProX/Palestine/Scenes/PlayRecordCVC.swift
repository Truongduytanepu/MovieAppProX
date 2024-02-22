//
//  PlayRecordCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit
import AVFoundation

class PlayRecordCVC: BaseCollectionViewCell {
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var topGradientView: UIView!
  @IBOutlet weak var bottomGradientView: UIView!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var shareView: UIView!
  @IBOutlet weak var shareLabel: UILabel!
  
  private var record: RecordObject?
  private var player: AVPlayer?
  private var videoLayer: AVPlayerLayer?
  private var isPresent = false
  
  override func setProperties() {
    shareLabel.text = AppText.LanguageKeys.share.localized
    
    shareView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(toShare)))
  }
  
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

extension PlayRecordCVC {
  func config(_ record: RecordObject) {
    self.record = record
    durationLabel.text = convertToTime(record.duration)
    let url = FileHelper.shared.getStorageURL(folder: .gallery, fileName: record.thumbnailFilename)
    thumbnailImageView.sd_setImage(with: url,
                                   placeholderImage: AppIcon.image(icon: .normal))
    clean()
    createPlayer()
  }
  
  func start() {
    guard !isPresent else {
      return
    }
    self.isPresent = true
    addNotificationDidPlayToEnd()
    playVideo()
  }
  
  func stop() {
    guard isPresent else {
      return
    }
    self.isPresent = false
    pauseVideo()
    removeNotificationDidPlayToEnd()
  }
}

extension PlayRecordCVC {
  @objc private func toShare() {
    LogEventManager.shared.log(event: .galleryClickShare)
    guard
      let record,
      let filename = record.filename,
      let recordURL = FileHelper.shared.getStorageURL(folder: .gallery, fileName: filename),
      let thumbnailImage = thumbnailImageView.image
    else {
      return
    }
    let shareVC = ShareVC()
    shareVC.config(recordURL: recordURL, thumbnailImage: thumbnailImage)
    push(to: shareVC, animated: false)
  }
  
  private func createPlayer() {
    guard
      let record,
      let filename = record.filename,
      let recordURL = FileHelper.shared.getStorageURL(folder: .gallery, fileName: filename)
    else {
      return
    }
    self.player = AVPlayer(url: recordURL)
    player?.volume = 1.0
    self.videoLayer?.removeFromSuperlayer()
    let layer = AVPlayerLayer(player: player)
    self.videoLayer = layer
    layer.frame = CGRect(origin: .zero, size: frame.size)
    layer.videoGravity = .resizeAspectFill
    videoView.layer.addSublayer(layer)
  }
  
  private func clean() {
    self.isPresent = false
    self.player = nil
    self.videoLayer = nil
  }
  
  @objc private func playVideo() {
    guard let player = player else {
      return
    }
    player.seek(to: .zero)
    player.play()
  }
  
  private func pauseVideo() {
    guard let player = player else {
      return
    }
    player.pause()
  }
  
  private func addNotificationDidPlayToEnd() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(playVideo),
                                           name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(playVideo),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)
  }
  
  private func removeNotificationDidPlayToEnd() {
    NotificationCenter.default.removeObserver(self)
  }
  
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
