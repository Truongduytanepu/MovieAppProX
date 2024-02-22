//
//  RecordManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import UIKit
import AVFoundation
import Combine

class RecordManager: NSObject {
  static let shared = RecordManager()
  
  enum State {
    case notRunning
    case recording
    case save
  }
  
  @Published private(set) var state: State = .notRunning
  @Published private(set) var progress = 0.0
  private(set) var lastFrameData: Data?
  private var player: AVPlayer?
  private var renderManager: RenderManager?
}

extension RecordManager {
  func createThread(bind captureView: UIView) {
    cleanData()
    self.state = .notRunning
    self.renderManager = RenderManager(captureView: captureView)
  }
  
  func start() {
    guard state == .notRunning else {
      return
    }
    self.state = .recording
    playMusic()
    startRender()
  }
  
  func stop() {
    guard state == .recording else {
      return
    }
    self.state = .save
    stopRender()
  }
  
  func cancel() {
    self.state = .notRunning
    stopMedia()
    cleanData()
  }
}

extension RecordManager {
  private func stopMedia() {
    self.state = .save
    CameraManager.shared.stopCamera()
    stopMusic()
  }
  
  private func cleanData() {
    self.progress = 0.0
    self.renderManager = nil
    self.player = nil
    FileHelper.shared.deleteCache()
  }
  
  private func setProgress(newValue: Double) {
    self.progress = newValue
  }
  
  private func startRender() {
    guard let renderManager else {
      return
    }
    renderManager.render(progress: setProgress(newValue:),
                         stop: stopMedia,
                         finish: convertToVideo(outputURL:lastFrameData:))
  }
  
  private func stopRender() {
    guard let renderManager else {
      return
    }
    renderManager.stop()
  }
  
  private func convertToVideo(outputURL: URL?, lastFrameData: Data?) {
    self.state = .save
    stopMedia()
    guard let outputURL else {
      errored()
      return
    }
    self.lastFrameData = lastFrameData
    if let selectMusic = MusicManager.shared.selectedMusic,
       let filename = selectMusic.filename,
       let url = FileHelper.shared.getStorageURL(folder: .data, fileName: filename) {
      MediaHelper.shared.renderVideoWithAudio(videoURL: outputURL,
                                              audioURL: url,
                                              completion: toResult(outputURL:),
                                              errored: errored)
    } else {
      toResult(outputURL: outputURL)
    }
  }
  
  private func errored() {
    self.state = .notRunning
    cleanData()
    stopMusic()
    showError()
  }
  
  private func showError() {
    DispatchQueue.main.async {
      guard let topVC = UIApplication.topViewController() else {
        return
      }
      let message = "An error has occurred"
      let alert = UIAlertController(title: "Render error",
                                    message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Try later", style: .cancel))
      topVC.present(alert, animated: true)
    }
  }
  
  private func toResult(outputURL: URL) {
    DispatchQueue.main.async {
      guard let topVC = UIApplication.topViewController() else {
        return
      }
      CreditManager.shared.didCreate()
      let resultVC = ResultVC()
      resultVC.config(outputURL)
      topVC.push(to: resultVC, animated: false)
    }
  }
  
  private func playMusic() {
    createPlayer()
    addNotification()
  }
  
  private func stopMusic() {
    removeNotification()
    self.player = nil
  }
  
  private func addNotification() {
    addNotificationDidPlayToEnd()
    play()
  }
  
  private func removeNotification() {
    pause()
    removeNotificationDidPlayToEnd()
  }
  
  private func createPlayer() {
    guard
      let selectMusic = MusicManager.shared.selectedMusic,
      let filename = selectMusic.filename,
      let url = FileHelper.shared.getStorageURL(folder: .data, fileName: filename)
    else {
      return
    }
    self.player = AVPlayer(url: url)
    player?.volume = 1.0
  }
  
  @objc private func play() {
    guard let player = player else {
      return
    }
    player.seek(to: .zero)
    player.play()
  }
  
  private func pause() {
    guard let player = player else {
      return
    }
    player.pause()
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
