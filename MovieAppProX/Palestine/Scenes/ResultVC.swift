//
//  ResultVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 27/11/2023.
//

import UIKit
import AdMobManager
import AVFoundation
import Photos
import NVActivityIndicatorView

class ResultVC: BaseViewController {
  @IBOutlet weak var videoView: UIView!
  @IBOutlet weak var containterView: UIView!
  @IBOutlet weak var backImageView: UIImageView!
  @IBOutlet weak var downloadImageView: UIImageView!
  @IBOutlet weak var homeImageView: UIImageView!
  @IBOutlet weak var saveView: UIView!
  @IBOutlet weak var saveLabel: UILabel!
  @IBOutlet weak var savingLabel: UILabel!
  @IBOutlet weak var indicatorView: NVActivityIndicatorView!
  @IBOutlet weak var discardView: UIView!
  @IBOutlet weak var retakeView: UIView!
  @IBOutlet weak var shareView: UIView!
  @IBOutlet weak var topGradientView: UIView!
  @IBOutlet weak var bottomGradientView: UIView!
  @IBOutlet weak var retakeLabel: UILabel!
  @IBOutlet weak var shareLabel: UILabel!
  @IBOutlet weak var removeThisLabel: UILabel!
  @IBOutlet weak var afterLabel: UILabel!
  @IBOutlet weak var discardLabel: UILabel!
  @IBOutlet weak var yesLabel: UILabel!
  @IBOutlet weak var customBannerAdView: CustomBannerAdView!
  
  private var player: AVPlayer?
  private var videoLayer: AVPlayerLayer?
  private var recordURL: URL?
  private var yesHandler: Handler?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    RatingApp.shared.resetSaved()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    addNotificationDidPlayToEnd()
    playVideo()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    pauseVideo()
    removeNotificationDidPlayToEnd()
  }
  
  override func setProperties() {
    saveLabel.text = AppText.LanguageKeys.saved.localized
    savingLabel.text = AppText.LanguageKeys.saving.localized
    retakeLabel.text = AppText.LanguageKeys.retake.localized
    shareLabel.text = AppText.LanguageKeys.share.localized
    removeThisLabel.text = AppText.LanguageKeys.removeThis.localized
    afterLabel.text = AppText.LanguageKeys.afterDeleting.localized
    discardLabel.text = AppText.LanguageKeys.discard.localized
    yesLabel.text = AppText.LanguageKeys.yes.localized
    
    indicatorView.startAnimating()
  }
  
  override func setColor() {
    let topGradientImage = UIImage.gradientImage(bounds: topGradientView.bounds,
                                                 colors: [
                                                  UIColor(rgb: 0x000000, alpha: 0.4),
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
  
  override func binding() {
    DispatchQueue.main.async { [weak self] in
      guard let self, let recordURL else {
        return
      }
      createPlayer(url: recordURL)
      playVideo()
    }
    
    if AdMobManager.shared.status(type: .onceUsed(.banner), name: AppText.AdName.collapsibleResultsTop) == true {
      customBannerAdView.load(name: AppText.AdName.collapsibleResultsTop)
    } else {
      customBannerAdView.isHidden = true
    }
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickBack)
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .interstitial,
            name: AppText.AdName.interstitialPreview,
            rootViewController: self,
            didFail: back,
            didHide: back)
  }
  
  @IBAction func onTapDownload(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickAddGallery)
    switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
    case .notDetermined:
      request()
    case .authorized, .limited:
      download()
    default:
      denied()
    }
  }
  
  @IBAction func onTapHome(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickHome)
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .interstitial,
            name: AppText.AdName.interstitialPreview,
            rootViewController: self,
            didFail: toHome,
            didHide: toHome)
  }
  
  @IBAction func onTapRetake(_ sender: Any) {
    LogEventManager.shared.log(event: .resultClickRetake)
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .interstitial,
            name: AppText.AdName.interRetake,
            rootViewController: self,
            didFail: retake,
            didHide: retake)
  }
  
  @IBAction func share(_ sender: Any) {
    LogEventManager.shared.log(event: .resultDetailClickShare)
    guard
      let recordURL,
      let lastFrameData = RecordManager.shared.lastFrameData,
      let thumbnailImage = UIImage(data: lastFrameData)
    else {
      return
    }
    let shareVC = ShareVC()
    shareVC.config(recordURL: recordURL, thumbnailImage: thumbnailImage)
    push(to: shareVC, animated: false)
  }
  
  @IBAction func onTapYes(_ sender: Any) {
    LogEventManager.shared.log(event: .removeYes)
    clean()
    yesHandler?()
  }
  
  @IBAction func onTapDiscard(_ sender: Any) {
    LogEventManager.shared.log(event: .removeDiscard)
    discardView.isHidden = true
    shareView.isHidden = false
    retakeView.isHidden = false
  }
}

extension ResultVC {
  func config(_ recordURL: URL) {
    self.recordURL = recordURL
  }
}

extension ResultVC {
  private func pauseVideo() {
    guard let player = player else {
      return
    }
    player.pause()
  }
  
  @objc private func playVideo() {
    guard let player = player else {
      return
    }
    player.seek(to: .zero)
    player.play()
  }
  
  private func createPlayer(url: URL) {
    self.player = AVPlayer(url: url)
    player?.volume = 1.0
    self.videoLayer?.removeFromSuperlayer()
    let layer = AVPlayerLayer(player: player)
    self.videoLayer = layer
    videoView.layoutIfNeeded()
    layer.frame = videoView.bounds
    layer.videoGravity = .resizeAspectFill
    videoView.layer.insertSublayer(layer, below: containterView.layer)
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
  
  private func request() {
    Global.shared.setShowAppOpen(allow: false)
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      guard let self = self else {
        return
      }
      switch status {
      case .authorized, .limited:
        self.download()
      default:
        self.denied()
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        Global.shared.setShowAppOpen(allow: true)
      })
    }
  }
  
  private func denied() {
    DispatchQueue.main.async {
      guard
        let topVC = UIApplication.topViewController(),
        let settingURL = URL(string: UIApplication.openSettingsURLString)
      else {
        return
      }
      let alert = UIAlertController(title: "Photos",
                                    message: "Please allow access to save video in your photo library",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Setting", style: .destructive, handler: { _ in
        UIApplication.shared.open(settingURL)
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      topVC.present(alert, animated: true)
    }
  }
  
  private func download() {
    DispatchQueue.main.async { [weak self] in
      guard
        let self,
        let recordURL,
        let thumbnailData = RecordManager.shared.lastFrameData,
        let player,
        let currentItem = player.currentItem
      else {
        return
      }
      saveView.isHidden = false
      backImageView.isHidden = true
      downloadImageView.isHidden = true
      homeImageView.isHidden = true
      retakeView.isHidden = true
      shareView.isHidden = true
      
      Task {
        do {
          let data = try await FileHelper.shared.download(url: recordURL)
          let filename = try await FileHelper.shared.saveStorage(folder: .gallery,
                                                                 data: data,
                                                                 fileExtension: recordURL.pathExtension)
          let thumbnailFilename = try await FileHelper.shared.saveStorage(folder: .gallery,
                                                                          data: thumbnailData,
                                                                          fileExtension: "jpg")
          
          DispatchQueue.main.async {
            GalleryManager.shared.save(filename: filename,
                                       duration: CMTimeGetSeconds(currentItem.duration),
                                       thumbnailFilename: thumbnailFilename)
            PHPhotoLibrary.shared().performChanges({
              PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: recordURL)
            }, completionHandler: { saved, error in
              DispatchQueue.main.async { [weak self] in
                guard let self else {
                  return
                }
                if saved, error == nil {
                  successfullyDownload()
                } else {
                  errorDownload()
                }
              }
            })
          }
        } catch {
          self.errorDownload()
        }
      }
    }
  }
  
  private func successfullyDownload() {
    RatingApp.shared.saved()
    savingLabel.isHidden = true
    indicatorView.isHidden = true
    saveLabel.isHidden = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
      guard let self else {
        return
      }
      saveView.isHidden = true
      backImageView.isHidden = false
      homeImageView.isHidden = false
      retakeView.isHidden = false
      shareView.isHidden = false
    })
  }
  
  private func errorDownload() {
    downloadImageView.isHidden = false
    backImageView.isHidden = false
    homeImageView.isHidden = false
    retakeView.isHidden = false
    shareView.isHidden = false
    let alertController = UIAlertController(title: "Your video could not be saved", message: nil, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Try later", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func toHome() {
    LoadingManager.shared.hide()
    clean()
    guard
      let navigationController,
      let rootVC = navigationController.viewControllers.first as? RootVC
    else {
      return
    }
    navigationController.popToViewController(rootVC, animated: false)
  }
  
  private func back() {
    LoadingManager.shared.hide()
    self.yesHandler = { [weak self] in
      guard let self, let navigationController else {
        return
      }
      let viewControllers = navigationController.viewControllers.prefix(1)
      let recordVC = RecordVC()
      navigationController.viewControllers = viewControllers + [recordVC]
    }
    if downloadImageView.isHidden {
      clean()
      yesHandler?()
    } else {
      discardView.isHidden = false
      shareView.isHidden = true
      retakeView.isHidden = true
    }
  }
  
  private func retake() {
    LoadingManager.shared.hide()
    clean()
    guard let navigationController else {
      return
    }
    let viewControllers = navigationController.viewControllers.prefix(1)
    let recordVC = RecordVC()
    navigationController.viewControllers = viewControllers + [recordVC]
  }
  
  private func clean() {
    pauseVideo()
    self.videoLayer = nil
    self.player = nil
    self.recordURL = nil
  }
}
