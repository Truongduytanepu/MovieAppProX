//
//  MusicCVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import UIKit
import AVFoundation
import SnapKit
import NVActivityIndicatorView

class MusicCVC: BaseCollectionViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var controlImageView: UIImageView!
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let loadingView = NVActivityIndicatorView(frame: .zero)
    loadingView.type = .lineScalePulseOutRapid
    loadingView.padding = 20.0
    loadingView.color = UIColor(rgb: 0x000000)
    return loadingView
  }()
  
  private var music: MusicObject?
  private var player: AVPlayer?
  private var timer: Timer?
  private var isPresent = false
  
  override func addComponents() {
    addSubview(loadingView)
  }
  
  override func setConstraints() {
    loadingView.snp.makeConstraints { make in
      make.width.height.equalTo(20.0)
      make.center.equalTo(controlImageView)
    }
  }
  
  override func setProperties() {
    controlImageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(control)))
  }
}

extension MusicCVC {
  func config(_ music: MusicObject) {
    self.music = music
    nameLabel.text = music.name
    descriptionLabel.text = music.describe
    thumbnailImageView.sd_setImage(with: music.thumbnailURL.getCleanedURL(),
                                   placeholderImage: AppIcon.image(icon: .normal))
    
    clean()
    if music.isDownloaded() {
      controlImageView.isHidden = false
      createPlayer()
    } else {
      controlImageView.isHidden = true
      loadingView.startAnimating()
      fire()
    }
  }
  
  func select() {
    containerView.backgroundColor = UIColor(rgb: 0xECF9FE)
    containerView.borderColor = UIColor(rgb: 0x5F9FBC)
    controlImageView.isUserInteractionEnabled = true
  }
  
  func deselect() {
    containerView.backgroundColor = UIColor(rgb: 0xFFFFFF)
    containerView.borderColor = UIColor(rgb: 0x000000, alpha: 0.1)
    controlImageView.isUserInteractionEnabled = false
  }
  
  func start() {
    guard !isPresent else {
      return
    }
    self.isPresent = true
    addNotificationDidPlayToEnd()
    play()
  }
  
  func stop() {
    guard isPresent else {
      return
    }
    self.isPresent = false
    pause()
    removeNotificationDidPlayToEnd()
  }
}

extension MusicCVC {
  @objc private func control() {
    guard let player = player else {
      return
    }
    switch player.timeControlStatus {
    case .paused:
      LogEventManager.shared.log(event: .soundClickPlay)
      play()
    case .playing:
      pause()
    default:
      return
    }
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
      let music,
      music.isDownloaded()
    else {
      return
    }
    invalidate()
    controlImageView.isHidden = false
    loadingView.stopAnimating()
    createPlayer()
    if isPresent {
      play()
    }
  }
  
  private func createPlayer() {
    guard
      let music,
      let filename = music.filename,
      let url = FileHelper.shared.getStorageURL(folder: .data, fileName: filename)
    else {
      return
    }
    self.player = AVPlayer(url: url)
    player?.volume = 1.0
  }
  
  private func clean() {
    invalidate()
    self.player = nil
    self.isPresent = false
    controlImageView.image = AppIcon.image(icon: .play)
  }
  
  @objc private func play() {
    guard let player = player else {
      return
    }
    player.seek(to: .zero)
    player.play()
    controlImageView.image = AppIcon.image(icon: .pause)
  }
  
  private func pause() {
    guard let player = player else {
      return
    }
    player.pause()
    controlImageView.image = AppIcon.image(icon: .play)
  }
  
  private func addNotificationDidPlayToEnd() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(play),
                                           name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                           object: nil)
  }
  
  private func removeNotificationDidPlayToEnd() {
    NotificationCenter.default.removeObserver(self)
  }
}
