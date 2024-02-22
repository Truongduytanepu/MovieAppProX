//
//  CameraManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import UIKit
import AVFoundation
import Combine

class CameraManager: NSObject {
  static let shared = CameraManager()
  
  enum CameraError: Error {
    case setup
    case position
    case flash
  }
  
  @Published private(set) var captureImage: UIImage?
  private let queue = DispatchQueue(label: "Capture")
  private var captureSession: AVCaptureSession?
  private var captureDevice: AVCaptureDevice?
  private var captureDeviceInput: AVCaptureDeviceInput?
  private var statePosition: AVCaptureDevice.Position = .front
}

extension CameraManager {
  func start() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      capture()
    case .notDetermined:
      request()
    default:
      denied()
    }
  }
  
  func switchPosition() {
    do {
      self.statePosition = statePosition == .front ? .back : .front
      self.captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: statePosition)
      guard let captureDevice else {
        throw CameraError.position
      }
      let newCaptureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
      
      guard let captureSession else {
        throw CameraError.position
      }
      captureSession.beginConfiguration()
      if let captureDeviceInput {
        captureSession.removeInput(captureDeviceInput)
      }
      captureSession.addInput(newCaptureDeviceInput)
      captureSession.commitConfiguration()
      
      self.captureDeviceInput = newCaptureDeviceInput
    } catch let error {
      showError(error)
    }
  }
  
  func stopCamera() {
    captureSession?.stopRunning()
    self.captureSession = nil
    self.captureDevice = nil
    self.captureDeviceInput = nil
  }
}

extension CameraManager {
  private func denied() {
    DispatchQueue.main.async {
      guard
        let topVC = UIApplication.topViewController(),
        let settingURL = URL(string: UIApplication.openSettingsURLString)
      else {
        return
      }
      let message = "The app needs access to the camera to function. Please grant camera access in the settings"
      let alert = UIAlertController(title: "Camera Access",
                                    message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Setting", style: .destructive, handler: { _ in
        UIApplication.shared.open(settingURL)
        topVC.pop(animated: false)
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        topVC.pop(animated: false)
      }))
      topVC.present(alert, animated: true)
    }
  }
  
  private func request() {
    LogEventManager.shared.log(event: .cameraClickAllowAccess)
    Global.shared.setShowAppOpen(allow: false)
    AVCaptureDevice.requestAccess(for: .video) { [weak self] status in
      guard let self = self else {
        return
      }
      switch status {
      case true:
        LogEventManager.shared.log(event: .cameraClickAllowAccessReal)
        capture()
      default:
        LogEventManager.shared.log(event: .requestCameraFail)
        denied()
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        Global.shared.setShowAppOpen(allow: true)
      })
    }
  }
  
  private func showError(_ error: Error) {
    switch error {
    case CameraError.setup:
      DispatchQueue.main.async {
        guard let topVC = UIApplication.topViewController() else {
          return
        }
        let message = "Unable to start using the camera. Try later"
        let alert = UIAlertController(title: "Camera Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
          guard let self else {
            return
          }
          stopCamera()
          topVC.pop(animated: false)
        }))
        topVC.present(alert, animated: true)
      }
    default: 
      return
    }
  }
  
  private func capture() {
    do {
      self.captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: statePosition)
      guard let captureDevice else {
        throw CameraError.setup
      }
      
      self.captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
      guard let captureDeviceInput else {
        throw CameraError.setup
      }
      
      self.captureSession = AVCaptureSession()
      guard let captureSession else {
        throw CameraError.setup
      }
      captureSession.addInput(captureDeviceInput)
      
      let captureVideoDataOutput = AVCaptureVideoDataOutput()
      captureSession.addOutput(captureVideoDataOutput)
      captureVideoDataOutput.setSampleBufferDelegate(self, queue: queue)
      
      DispatchQueue.global(qos: .userInitiated).async {
        captureSession.startRunning()
      }
    } catch let error {
      showError(error)
    }
  }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
  func fileOutput(_ output: AVCaptureFileOutput,
                  didStartRecordingTo fileURL: URL,
                  from connections: [AVCaptureConnection]
  ) {}
  
  func captureOutput(_ output: AVCaptureOutput,
                     didOutput sampleBuffer: CMSampleBuffer,
                     from connection: AVCaptureConnection
  ) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    guard let captureDevice else {
      return
    }
    let orientation: CGImagePropertyOrientation = captureDevice.position == .front ? .leftMirrored : .right
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(orientation)
    self.captureImage = UIImage(ciImage: ciImage)
  }
}
