//
//  RenderManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 01/12/2023.
//

import UIKit

typealias ProgressHandler = ((Double) -> Void)
typealias FinishHandler = ((URL?, Data?) -> Void)

final class RenderManager {
  private let renderSetting: RenderSetting
  private let videoWriter: VideoWriter
  private var captureView: UIView?
  private var lastFrameData: Data?
  private var progressHandler: ProgressHandler?
  private var stopHandler: Handler?
  private var finishHandler: FinishHandler?
  private var source: DispatchSourceTimer?
  private var queue: DispatchQueue?
  private var currentFrame: Int64 = 0
  
  init(captureView: UIView) {
    self.renderSetting = RenderSetting()
    self.videoWriter = VideoWriter(renderSetting: renderSetting)
    self.captureView = captureView
  }
  
  deinit {
    self.captureView = nil
    self.finishHandler = nil
    self.source = nil
    self.queue = nil
  }
}

extension RenderManager {
  func render(progress: ProgressHandler? = nil, stop: Handler?, finish: FinishHandler?) {
    self.progressHandler = progress
    self.stopHandler = stop
    self.finishHandler = finish
    self.queue = DispatchQueue(label: "com.core.render",
                               qos: .userInitiated,
                               autoreleaseFrequency: .workItem,
                               target: DispatchQueue.global())
    self.source = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(), queue: queue)
    source?.schedule(deadline: .now(),
                     repeating: 1.0 / Double(renderSetting.fps),
                     leeway: .nanoseconds(0))
    
    var count = 0
    let maxFrame = Int(renderSetting.duration * Double(renderSetting.fps))
    
    source?.setEventHandler {
      guard count <= maxFrame - 1 else {
        self.stop()
        return
      }
      count += 1
      self.progressHandler?(Double(count) / Double(maxFrame))
              
      DispatchQueue.main.sync { [weak self] in
        guard let self else {
          return
        }
        writing()
      }
    }
    
    source?.setCancelHandler {
      self.videoWriter.finish {
        DispatchQueue.main.async { [weak self] in
          guard let self else {
            return
          }
          finishHandler?(renderSetting.getOutputURL(), lastFrameData)
        }
      }
    }
    
    source?.resume()
  }
  
  func stop() {
    source?.cancel()
    DispatchQueue.main.async { [weak self] in
      guard let self else {
        return
      }
      stopHandler?()
    }
  }
}

extension RenderManager {
  @objc private func writing() {
    guard let captureView else {
      return
    }
    guard let image = image(from: captureView) else {
      return
    }
    videoWriter.writeFrame(image: image, frame: currentFrame)
    self.currentFrame += 1
  }

  private func image(from view: UIView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
    defer {
      UIGraphicsEndImageContext()
    }
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
      return nil
    }
    guard let data = image.jpegData(compressionQuality: renderSetting.quality) else {
      return nil
    }
    self.lastFrameData = data
    return UIImage(data: data)
  }
}
