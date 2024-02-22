//
//  MPVolumeViewExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import MediaPlayer

extension MPVolumeView {
  static func setVolume(_ volume: Float) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      slider?.value = volume
    }
  }
}
