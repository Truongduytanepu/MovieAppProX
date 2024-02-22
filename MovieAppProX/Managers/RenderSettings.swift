//
//  RenderSettings.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import Foundation
import AVFoundation

struct RenderSetting {
  let duration = 30.0
  let fps = 24
  let quality = 0.5
  let size = CGSize(width: 1080.0, height: 1920.0)
  let type: AVFileType = .mp4
  private let fileExtension = "mp4"
  private let filename = "RecordOutput"
}

extension RenderSetting {
  func getOutputURL() -> URL? {
    return FileHelper.shared.getCacheURL(fileName: "\(filename).\(fileExtension)")
  }
}
