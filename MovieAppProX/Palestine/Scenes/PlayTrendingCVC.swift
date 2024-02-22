//
//  PlayTrendingCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView
import SnapKit
import AdMobManager

class PlayTrendingCVC: BaseCollectionViewCell {
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var likeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var tryNowView: UIView!
  @IBOutlet weak var topGradientView: UIView!
  @IBOutlet weak var bottomGradientView: UIView!
  @IBOutlet weak var tryNowLabel: UILabel!
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let loadingView = NVActivityIndicatorView(frame: .zero)
    loadingView.type = .ballSpinFadeLoader
    loadingView.padding = 30.0
    loadingView.color = UIColor(rgb: 0xFFFFFF)
    return loadingView
  }()
  
  private var trending: TrendingObject?
  private var player: AVPlayer?
  private var videoLayer: AVPlayerLayer?
  private var timer: Timer?
  private var isPresent = false
  
  override func addComponents() {
    addSubview(loadingView)
  }
  
  override func setConstraints() {
    loadingView.snp.makeConstraints { make in
      make.width.height.equalTo(20.0)
      make.center.equalToSuperview()
    }
  }
  
  override func setProperties() {
    tryNowLabel.text = AppText.LanguageKeys.tryNow.localized
    
    tryNowView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                           action: #selector(tryNow)))
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

extension PlayTrendingCVC {
  func config(_ trending: TrendingObject) {
    self.trending = trending
    likeLabel.text = convertLike(trending.like)
    nameLabel.text = trending.name
    descriptionLabel.text = trending.describe
    thumbnailImageView.sd_setImage(with: trending.thumbnailURL.getCleanedURL(),
                                   placeholderImage: AppIcon.image(icon: .normal))
    TrendingManager.shared.willPlay(trending)
    
    clean()
    if trending.isDownloaded() {
      createPlayer()
    } else {
      loadingView.startAnimating()
      fire()
    }
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

extension PlayTrendingCVC {
  @objc private func tryNow() {
    LogEventManager.shared.log(event: .trendingClickCreate)
    guard let topVC = UIApplication.topViewController() else {
      return
    }
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .interstitial,
            name: AppText.AdName.interHomeTrendingDetail,
            rootViewController: topVC,
            didFail: toRecord,
            didHide: toRecord)
  }
  
  private func invalidate() {
    timer?.invalidate()
    self.timer = nil
  }
  
  private func fire() {
    invalidate()
    self.timer = Timer.scheduledTimer(timeInterval: 0.1,
                                      target: self,
                                      selector: #selector(checkDownload),
                                      userInfo: nil,
                                      repeats: true)
  }
  
  @objc private func checkDownload() {
    guard
      let trending,
      trending.isDownloaded()
    else {
      return
    }
    invalidate()
    loadingView.stopAnimating()
    createPlayer()
    if isPresent {
      playVideo()
    }
  }
  
  private func createPlayer() {
    guard
      let trending,
      let filename = trending.filename,
      let url = FileHelper.shared.getStorageURL(folder: .data, fileName: filename)
    else {
      return
    }
    self.player = AVPlayer(url: url)
    player?.volume = 1.0
    self.videoLayer?.removeFromSuperlayer()
    let layer = AVPlayerLayer(player: player)
    self.videoLayer = layer
    layer.frame = CGRect(origin: .zero, size: frame.size)
    layer.videoGravity = .resizeAspectFill
    videoView.layer.addSublayer(layer)
  }
  
  private func clean() {
    invalidate()
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
  
  private func convertLike(_ value: Int) -> String {
    return String((Double(value) / 1_000_000.0).roundToDecimals(decimals: 1)) + "M"
  }
  
  private func toRecord() {
    guard
      let topVC = UIApplication.topViewController(),
      let navigationController = topVC.navigationController
    else {
      return
    }
    if let trending, let musicId = trending.musicId {
      MusicManager.shared.change(musicId: musicId)
    }
    let viewControllers = navigationController.viewControllers.prefix(1)
    let recordVC = RecordVC()
    navigationController.viewControllers = viewControllers + [recordVC]
  }
}
