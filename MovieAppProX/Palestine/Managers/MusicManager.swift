//
//  MusicManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 26/11/2023.
//

import Foundation
import Combine

class MusicManager {
  static let shared = MusicManager()
  
  @Published private(set) var playings = [MusicObject]()
  @Published private(set) var cacheSelectedMusic: MusicObject?
  @Published private(set) var isLoading = false
  @Published private(set) var selectedMusic: MusicObject?
}

extension MusicManager {
  func fetch() {
    self.isLoading = true
    playings.removeAll()
    clean()
    Task {
      do {
        let musicResponse = try await APIManager.shared.getMusic()
        await moveToPlaying(musics: musicResponse.musics)
        self.isLoading = false
      } catch {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
          guard let self else {
            return
          }
          self.fetch()
        }
      }
    }
  }
  
  func moveToCache() {
    self.cacheSelectedMusic = selectedMusic
  }
  
  func save() {
    self.selectedMusic = cacheSelectedMusic
    clean()
  }
  
  func choose(music: MusicObject) {
    if isSelected(music: music) {
      self.cacheSelectedMusic = nil
    } else if music.isDownloaded() {
      self.cacheSelectedMusic = music
    }
  }
  
  func change(musicId: String) {
    self.selectedMusic = playings.first(where: { $0.id == musicId })
  }
  
  func changeDefault() {
    self.selectedMusic = playings.first
  }
  
  func remove() {
    self.selectedMusic = nil
    self.cacheSelectedMusic = nil
  }
  
  func isSelected(music: MusicObject) -> Bool {
    return cacheSelectedMusic?.id == music.id
  }
  
  func clean() {
    self.cacheSelectedMusic = nil
  }
}

extension MusicManager {
  @MainActor
  private func moveToPlaying(musics: [Music]) {
    var playings = [MusicObject]()
    var awaitDownload = [MusicObject]()
    musics.forEach { music in
      if let musicObject = RealmService.shared.getById(ofType: MusicObject.self, id: music.id) {
        playings.append(musicObject)
      } else {
        let musicObject = MusicObject(music)
        playings.append(musicObject)
        awaitDownload.append(musicObject)
      }
    }
    self.playings = playings
    DownloadManager.shared.load(awaitDownload)
  }
}
