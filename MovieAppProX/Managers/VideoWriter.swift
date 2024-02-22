//
//  VideoWriter.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import UIKit
import AVFoundation

class VideoWriter {
  private var renderSetting: RenderSetting
  private var queue: DispatchQueue
  
  private var assetWriter: AVAssetWriter?
  private var assetWriterInput: AVAssetWriterInput?
  private var assetWriterInputPixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
  
  init(renderSetting: RenderSetting) {
    self.renderSetting = renderSetting
    self.queue = DispatchQueue(label: "com.core.writer",
                               qos: .userInitiated,
                               autoreleaseFrequency: .workItem,
                               target: DispatchQueue.global())
  }
}

extension VideoWriter {
  func writeFrame(image: UIImage, frame: Int64) {
    queue.async { [weak self] in
      guard let self else {
        return
      }
      try? setupVideoWriterIfNecessary()
      guard
        let assetWriterInput,
        assetWriterInput.isReadyForMoreMediaData
      else {
        return
      }
      let presentationTime = CMTime(value: CMTimeValue(frame),
                                    timescale: CMTimeScale(renderSetting.fps))
      guard let pixelBuffer = createPixelBuffer(from: image) else {
        return
      }
      guard let assetWriterInputPixelBufferAdaptor else {
        return
      }
      assetWriterInputPixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }
  }
  
  func finish(completion: Handler?) {
    queue.async { [weak self] in
      guard let self else {
        return
      }
      self.assetWriterInput?.markAsFinished()
      self.assetWriter?.finishWriting(completionHandler: {
        self.assetWriterInput = nil
        self.assetWriterInputPixelBufferAdaptor = nil
        DispatchQueue.main.async {
          completion?()
        }
      })
    }
  }
}

extension VideoWriter {
  private func setupVideoWriterIfNecessary() throws {
    guard assetWriter == nil else {
      return
    }
    guard let outputURL = renderSetting.getOutputURL() else {
      return
    }
    
    self.assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: AVFileType.mp4)
    
    guard let assetWriter else {
      return
    }
    let outputSize = renderSetting.size
    let outputSettings: [String: Any] = [
      AVVideoCodecKey: AVVideoCodecType.h264,
      AVVideoWidthKey: outputSize.width,
      AVVideoHeightKey: outputSize.height
    ]
    
    self.assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
    
    if let assetWriterInput {
      assetWriterInput.expectsMediaDataInRealTime = true
      
      let sourcePixelBufferAttributes: [String: Any] = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
        kCVPixelBufferWidthKey as String: outputSize.width,
        kCVPixelBufferHeightKey as String: outputSize.height,
        kCVPixelBufferCGImageCompatibilityKey as String: NSNumber(true),
        kCVPixelBufferCGBitmapContextCompatibilityKey as String: NSNumber(true)
      ]
      
      let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput,
                                                         sourcePixelBufferAttributes: sourcePixelBufferAttributes)
      self.assetWriterInputPixelBufferAdaptor = adaptor
      assetWriter.add(assetWriterInput)
    }
    
    if assetWriter.startWriting() {
      assetWriter.startSession(atSourceTime: CMTime.zero)
    }
  }
  
  private func createPixelBuffer(from image: UIImage) -> CVPixelBuffer? {
    let size = renderSetting.size
    var pixelBufferOut: CVPixelBuffer?
    
    let options = [
      kCVPixelBufferCGImageCompatibilityKey: true,
      kCVPixelBufferCGBitmapContextCompatibilityKey: true
    ] as CFDictionary
    
    let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                     Int(size.width),
                                     Int(size.height),
                                     kCVPixelFormatType_32ARGB,
                                     options,
                                     &pixelBufferOut)
    
    guard status == kCVReturnSuccess else {
      return nil
    }
    
    guard let pixelBuffer = pixelBufferOut else {
      return nil
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, [])
    
    let data = CVPixelBufferGetBaseAddress(pixelBuffer)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bimapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
      .union(.byteOrderDefault)
    
    guard let context = CGContext(data: data,
                                  width: Int(size.width),
                                  height: Int(size.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                  space: rgbColorSpace,
                                  bitmapInfo: bimapInfo.rawValue)
    else {
      return nil
    }
    
    context.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    
    let horizontalRatio = size.width / image.size.width
    let verticalRatio = size.height / image.size.height
    
    //    let aspectRatio = max(horizontalRatio, verticalRatio) // ScaleToFill
    let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
    
    let newSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
    
    let xPoint = newSize.width < size.width ? (size.width - newSize.width) / 2 : 0
    let yPoint = newSize.height < size.height ? (size.height - newSize.height) / 2 : 0
    
    context.concatenate(CGAffineTransform.identity)
    
    guard let cgImage = image.cgImage else {
      return nil
    }
    context.draw(cgImage,
                 in: CGRect(x: xPoint,
                            y: yPoint,
                            width: newSize.width,
                            height: newSize.height))
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
    
    return pixelBuffer
  }
}
