//
//  MediaHelper.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import UIKit
import AVFoundation

class MediaHelper {
  static let shared = MediaHelper()
}

extension MediaHelper {
  func renderVideoWithAudio(videoURL: URL, audioURL: URL, completion: @escaping ((URL) -> Void), errored: Handler?) {
    // Create AVAsset from video URL
    let videoAsset = AVURLAsset(url: videoURL)
    
    // Create AVAsset from audio URL
    let audioAsset = AVURLAsset(url: audioURL)
    
    // Create AVMutableComposition for combining video and audio
    let composition = AVMutableComposition()
    
    // Add video track to composition
    guard let videoTrack = composition.addMutableTrack(withMediaType: .video,
                                                       preferredTrackID: kCMPersistentTrackID_Invalid) else {
      errored?()
      return
    }
    
    do {
      // Extract video track from video asset
      guard let track = videoAsset.tracks(withMediaType: .video).first else {
        errored?()
        return
      }
      try videoTrack.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration), of: track, at: .zero)
    } catch {
      errored?()
      return
    }
    
    // Add audio track to composition
    guard let audioTrack = composition.addMutableTrack(withMediaType: .audio,
                                                       preferredTrackID: kCMPersistentTrackID_Invalid) else {
      errored?()
      return
    }
    
    do {
      // Extract audio track from audio asset
      try audioTrack.insertTimeRange(CMTimeRangeMake(start: .zero, duration: videoAsset.duration),
                                     of: audioAsset.tracks(withMediaType: .audio)[0],
                                     at: .zero)
    } catch {
      errored?()
      return
    }
    
    // Create AVAssetExportSession for exporting the final composition
    guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
      errored?()
      return
    }
    let fileName = "\(UUID().uuidString).mp4"
    guard let cacheURL = FileHelper.shared.getCacheURL(fileName: fileName) else {
      errored?()
      return
    }
    
    exportSession.outputURL = cacheURL
    exportSession.outputFileType = .mp4
    exportSession.shouldOptimizeForNetworkUse = true
    
    // Export the composition with the audio
    exportSession.exportAsynchronously {
      switch exportSession.status {
      case .completed:
        completion(cacheURL)
      default:
        errored?()
      }
    }
  }
  
  func getVideoThumbnail(url: URL, completed: @escaping ((UIImage?) -> Void)) {
    DispatchQueue.global(qos: .background).async {
      do {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                     actualTime: nil)
        completed(UIImage(cgImage: cgImage))
      } catch {
        completed(nil)
      }
    }
  }
}
