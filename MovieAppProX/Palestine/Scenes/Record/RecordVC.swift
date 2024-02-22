//
//  RecordVC.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import UIKit
import AdMobManager
import SDWebImage
import MarqueeLabel
import NVActivityIndicatorView
import KDCircularProgress
import TrackingSDK

class RecordVC: BaseViewController {
  @IBOutlet weak var progressView: KDCircularProgress!
  @IBOutlet weak var recordView: UIView!
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var presentCameraImageView: UIImageView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var backImageView: UIImageView!
  @IBOutlet weak var musicView: UIView!
  @IBOutlet weak var musicLabel: MarqueeLabel!
  @IBOutlet weak var removeMusicImageView: UIImageView!
  @IBOutlet weak var countDownImageView: UIImageView!
  @IBOutlet weak var countDownView: UIView!
  @IBOutlet weak var countDownLabel: UILabel!
  @IBOutlet weak var countDown0sView: UIView!
  @IBOutlet weak var countDown3sView: UIView!
  @IBOutlet weak var countDown5sView: UIView!
  @IBOutlet weak var countDown10sView: UIView!
  @IBOutlet weak var countDown15sView: UIView!
  @IBOutlet weak var countDown0sLabel: UILabel!
  @IBOutlet weak var countDown3sLabel: UILabel!
  @IBOutlet weak var countDown5sLabel: UILabel!
  @IBOutlet weak var countDown10sLabel: UILabel!
  @IBOutlet weak var countDown15sLabel: UILabel!
  @IBOutlet weak var stopView: UIView!
  @IBOutlet weak var recordControlView: UIView!
  @IBOutlet weak var filterStackView: UIStackView!
  @IBOutlet weak var switchCameraImageView: UIImageView!
  @IBOutlet weak var filterView: UIView!
  @IBOutlet weak var filterImageView: UIImageView!
  @IBOutlet weak var filterLabel: UILabel!
  @IBOutlet weak var melonSeeds1ImageView: UIImageView!
  @IBOutlet weak var melonSeeds2ImageView: UIImageView!
  @IBOutlet weak var melonSeeds3ImageView: UIImageView!
  @IBOutlet weak var melonSeeds4ImageView: UIImageView!
  @IBOutlet weak var startPointView: UIView!
  @IBOutlet weak var endPointView: UIView!
  @IBOutlet weak var gifImageView: UIImageView!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var indicatorLoadingView: NVActivityIndicatorView!
  @IBOutlet weak var topGradientView: UIView!
  @IBOutlet weak var bottomGradientView: UIView!
  @IBOutlet weak var pointImageView: UIImageView!
  @IBOutlet weak var creditView: UIView!
  @IBOutlet weak var creditLabel: UILabel!
  @IBOutlet weak var saveLabel: UILabel!
  @IBOutlet weak var customBannerAdView: CustomBannerAdView!
  
  private let timeInterval = 0.1
  private var timer: Timer?
  private var currentTime = Double.infinity
  private var countDownTyle: CountDownType = .cd0s
  private var issuggest = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    RecordManager.shared.createThread(bind: recordView)
    CameraManager.shared.start()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    pushTracking()
    LoadingManager.shared.remove()
  }
  
  override func setProperties() {
    saveLabel.text = AppText.LanguageKeys.saving.localized
    
    indicatorLoadingView.startAnimating()
    
    progressView.progress = 0.0
    progressView.startAngle = -85
    progressView.progressThickness = 0.3
    progressView.trackThickness = 0.3
    progressView.trackColor = UIColor.clear
    progressView.clockwise = true
    progressView.set(colors: UIColor(rgb: 0xD7F2FD))
  }
  
  override func setColor() {
    let gradientImage = UIImage.gradientImage(bounds: stopView.bounds,
                                              colors: [
                                                UIColor(rgb: 0x79BEDB),
                                                UIColor(rgb: 0x7D94FB)
                                              ],
                                              startPoint: .zero,
                                              endPoint: CGPoint(x: 0.0, y: 1.0))
    let gradientColor = UIColor(patternImage: gradientImage)
    stopView.backgroundColor = gradientColor
    
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
    CameraManager.shared.$captureImage
      .receive(on: DispatchQueue.main)
      .sink { [weak self] captureImage in
        guard let self, let captureImage else {
          return
        }
        presentCameraImageView.image = captureImage
      }.store(in: &subscriptions)
    
    RecordManager.shared.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self else {
          return
        }
        stopView.isHidden = state != .recording
        recordControlView.isHidden = state == .save
        filterStackView.isHidden = state != .notRunning
        countDownImageView.isHidden = state != .notRunning
        countDownLabel.isHidden = state != .notRunning
        switchCameraImageView.isHidden = state != .notRunning
        loadingView.isHidden = state != .save
        filterView.isHidden = state != .recording
        canvasView.isHidden = state != .recording
        gifImageView.isHidden = state != .recording
        backImageView.isHidden = state != .notRunning
        musicView.isHidden = state != .notRunning
        canvasView.setDraw(enable: state == .recording)
        creditView.isHidden = state != .notRunning
      }.store(in: &subscriptions)
    
    canvasView.$lastPoint
      .receive(on: DispatchQueue.main)
      .sink { [weak self] lastPoint in
        guard let self, let lastPoint else {
          return
        }
        pointImageView.isHidden = true
        animation(touchPoint: lastPoint)
      }.store(in: &subscriptions)
    
    RecordManager.shared.$progress
      .receive(on: DispatchQueue.main)
      .sink { [weak self] progress in
        guard let self else {
          return
        }
        progressView.progress = progress
      }.store(in: &subscriptions)
    
    MusicManager.shared.$selectedMusic
      .receive(on: DispatchQueue.main)
      .sink { [weak self] selectedMusic in
        guard let self else {
          return
        }
        if let selectedMusic {
          musicLabel.text = selectedMusic.name
          removeMusicImageView.image = AppIcon.image(icon: .deselectMusic)
          removeMusicImageView.isUserInteractionEnabled = true
        } else {
          musicLabel.text = AppText.LanguageKeys.addSong.localized
          removeMusicImageView.image = AppIcon.image(icon: .selectMusic)
          removeMusicImageView.isUserInteractionEnabled = false
        }
      }.store(in: &subscriptions)
    
    FilterManager.shared.$selectedFilter
      .receive(on: DispatchQueue.main)
      .sink { [weak self] selectedFilter in
        guard let self else {
          return
        }
        if let selectedFilter {
          filterStackView.isHidden = false
          filterLabel.text = selectedFilter.name
          filterImageView.sd_setImage(with: selectedFilter.thumbnailURL.getCleanedURL(),
                                      placeholderImage: AppIcon.image(icon: .normal))
        } else {
          filterStackView.isHidden = true
        }
      }.store(in: &subscriptions)
    
    CreditManager.shared.$remainingFree
      .receive(on: DispatchQueue.main)
      .sink { [weak self] remainingFree in
        guard let self else {
          return
        }
        creditLabel.text = String(remainingFree)
      }.store(in: &subscriptions)
    
    if issuggest {
      DispatchQueue.main.async { [weak self] in
        guard let self else {
          return
        }
        let suggestView = SuggestView()
        suggestView.frame = view.frame
        view.addSubview(suggestView)
      }
    }
    
    if AdMobManager.shared.status(type: .onceUsed(.banner), name: AppText.AdName.collapsibleDefault) == true {
      customBannerAdView.load(name: AppText.AdName.collapsibleDefault)
    } else {
      customBannerAdView.isHidden = true
    }
  }
  
  @IBAction func onTapBack(_ sender: Any) {
    LogEventManager.shared.log(event: .cameraClickEscape)
    RecordManager.shared.cancel()
    let back = {
      guard
        let topVC = UIApplication.topViewController(),
        let navigationController = topVC.navigationController,
        let rootVC = navigationController.viewControllers.first as? RootVC
      else {
        return
      }
      navigationController.popToViewController(rootVC, animated: false)
    }
    LoadingManager.shared.show()
    AdMobManager
      .shared
      .show(type: .interstitial,
            name: AppText.AdName.interstitialCameraBack,
            rootViewController: self,
            didFail: back,
            didHide: back)
  }
  
  @IBAction func onTapCountDown(_ sender: Any) {
    if countDownView.isHidden {
      LogEventManager.shared.log(event: .cameraClickClock)
    }
    countDownView.isHidden.toggle()
  }
  
  @IBAction func onTap0s(_ sender: Any) {
    changeCountDown(tyle: .cd0s)
  }
  
  @IBAction func onTap3s(_ sender: Any) {
    changeCountDown(tyle: .cd3s)
  }
  
  @IBAction func onTap5s(_ sender: Any) {
    changeCountDown(tyle: .cd5s)
  }
  
  @IBAction func onTap10s(_ sender: Any) {
    changeCountDown(tyle: .cd10s)
  }
  
  @IBAction func onTap15s(_ sender: Any) {
    changeCountDown(tyle: .cd15s)
  }
  
  @IBAction func onTapChangeMusic(_ sender: Any) {
    if MusicManager.shared.selectedMusic == nil {
      LogEventManager.shared.log(event: .cameraClickAddSound)
    }
    hideCountDown()
    MusicManager.shared.moveToCache()
    push(to: MusicVC(), animated: false)
  }
  
  @IBAction func onTapRemoveMusic(_ sender: Any) {
    LogEventManager.shared.log(event: .cameraClickRemove)
    hideCountDown()
    MusicManager.shared.remove()
  }
  
  @IBAction func onTapRotateCamera(_ sender: Any) {
    LogEventManager.shared.log(event: .cameraClickChange)
    hideCountDown()
    CameraManager.shared.switchPosition()
  }
  
  @IBAction func onTapChangeFilter(_ sender: Any) {
    LogEventManager.shared.log(event: .cameraClickFilter)
    hideCountDown()
    push(to: FilterVC(), animated: false)
  }
  
  @IBAction func onTapStartRecord(_ sender: Any) {
    LogEventManager.shared.log(event: .cameraClickVideo)
    view.layoutIfNeeded()
    guard !CreditManager.shared.isLimit() else {
      showLimitCredit()
      return
    }
    hideCountDown()
    if RecordManager.shared.state == .notRunning {
      if countDownTyle == .cd0s {
        RecordManager.shared.start()
      } else {
        startCountDown()
      }
    } else {
      RecordManager.shared.stop()
    }
  }
  
  @IBAction func onTapCredit(_ sender: Any) {
    LogEventManager.shared.log(event: .cameraClickUses)
    let rewardView = RewardView()
    rewardView.frame = view.frame
    view.addSubview(rewardView)
  }
}

extension RecordVC {
  func suggest() {
    self.issuggest = true
  }
}

extension RecordVC {
  private func changeCountDown(tyle: CountDownType) {
    self.countDownTyle = tyle
    hideCountDown()
    countDownLabel.text = "\(Int(tyle.time ?? 0.0))s"
    
    countDown0sView.backgroundColor = tyle == .cd0s ? UIColor(rgb: 0xFFFFFF) : .clear
    countDown0sLabel.textColor = tyle == .cd0s ? UIColor(rgb: 0x000000) : UIColor(rgb: 0xFFFFFF)
    
    countDown3sView.backgroundColor = tyle == .cd3s ? UIColor(rgb: 0xFFFFFF) : .clear
    countDown3sLabel.textColor = tyle == .cd3s ? UIColor(rgb: 0x000000) : UIColor(rgb: 0xFFFFFF)
    
    countDown5sView.backgroundColor = tyle == .cd5s ? UIColor(rgb: 0xFFFFFF) : .clear
    countDown5sLabel.textColor = tyle == .cd5s ? UIColor(rgb: 0x000000) : UIColor(rgb: 0xFFFFFF)
    
    countDown10sView.backgroundColor = tyle == .cd10s ? UIColor(rgb: 0xFFFFFF) : .clear
    countDown10sLabel.textColor = tyle == .cd10s ? UIColor(rgb: 0x000000) : UIColor(rgb: 0xFFFFFF)
    
    countDown15sView.backgroundColor = tyle == .cd15s ? UIColor(rgb: 0xFFFFFF) : .clear
    countDown15sLabel.textColor = tyle == .cd15s ? UIColor(rgb: 0x000000) : UIColor(rgb: 0xFFFFFF)
  }
  
  private func hideCountDown() {
    countDownView.isHidden = true
  }
  
  private func animation(touchPoint: CGPoint) {
    let minSpace = 20.0
    if melonSeeds1ImageView.center.distance(to: touchPoint) <= minSpace, !melonSeeds1ImageView.isHidden {
      melonSeeds1ImageView.isHidden = true
      canvasView.addMelonSeeds()
    }
    if melonSeeds2ImageView.center.distance(to: touchPoint) <= minSpace, !melonSeeds2ImageView.isHidden {
      melonSeeds2ImageView.isHidden = true
      canvasView.addMelonSeeds()
    }
    if melonSeeds3ImageView.center.distance(to: touchPoint) <= minSpace, !melonSeeds3ImageView.isHidden {
      melonSeeds3ImageView.isHidden = true
      canvasView.addMelonSeeds()
    }
    if melonSeeds4ImageView.center.distance(to: touchPoint) <= minSpace, !melonSeeds4ImageView.isHidden {
      melonSeeds4ImageView.isHidden = true
      canvasView.addMelonSeeds()
    }
    if startPointView.center.distance(to: touchPoint) <= minSpace {
      startPointView.isHidden = false
    }
    if endPointView.center.distance(to: touchPoint) <= minSpace, endPointView.isHidden {
      endPointView.isHidden = false
      canvasView.addMelonSeeds()
      filterView.isHidden = true
      canvasView.animation(completion: animation)
    }
  }
  
  private func animation() {
    canvasView.isHidden = true
    if let gifPath = Bundle.main.path(forResource: "zoom", ofType: "gif") {
      let url = URL(fileURLWithPath: gifPath)
      gifImageView.sd_setImage(with: url)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
      guard let self else {
        return
      }
      if let gifPath = Bundle.main.path(forResource: "shake", ofType: "gif") {
        let url = URL(fileURLWithPath: gifPath)
        gifImageView.sd_setImage(with: url)
      }
    }
  }
  
  private func startCountDown() {
    guard let time = countDownTyle.time else {
      return
    }
    updateCountDownUI()
    invalidate()
    self.currentTime = time
    fire()
  }
  
  private func fire() {
    self.timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                      target: self,
                                      selector: #selector(countDown),
                                      userInfo: nil,
                                      repeats: true)
  }
  
  private func invalidate() {
    self.currentTime = Double.infinity
    timer?.invalidate()
    self.timer = nil
  }
  
  @objc private func countDown() {
    self.currentTime -= timeInterval
    currentTimeLabel.text = "\(Int(currentTime) + 1)"
    currentTimeLabel.isHidden = false
    guard currentTime <= 0.0 else {
      return
    }
    currentTimeLabel.isHidden = true
    invalidate()
    RecordManager.shared.start()
  }
  
  private func updateCountDownUI() {
    creditView.isHidden = true
    backImageView.isHidden = true
    countDownImageView.isHidden = true
    recordControlView.isHidden = true
    switchCameraImageView.isHidden = true
    filterStackView.isHidden = true
    musicView.isHidden = true
    countDownLabel.isHidden = true
  }
  
  private func showLimitCredit() {
    let rewardView = RewardView()
    rewardView.frame = view.frame
    view.addSubview(rewardView)
  }
  
  private func pushTracking() {
    guard
      let push = Global.shared.pushTrackingConfig,
      push.status,
      push.camera,
      TrackingSDK.shared.status()
    else {
      return
    }
    let trackingPopupView = TrackingPopupView()
    trackingPopupView.frame = view.frame
    view.addSubview(trackingPopupView)
  }
}
