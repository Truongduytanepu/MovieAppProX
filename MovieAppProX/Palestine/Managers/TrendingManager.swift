//
//  TrendingManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import Foundation
import Combine

class TrendingManager {
  static let shared = TrendingManager()
  
  @Published private(set) var trendings = [Trending]()
  @Published private(set) var playings = [TrendingObject]()
  @Published private(set) var isLoading = false
}

extension TrendingManager {
  func fetch() {
    self.isLoading = true
    trendings.removeAll()
    Task {
      do {
        let trendingResponse = try await APIManager.shared.getTrending()
        self.trendings = trendingResponse.trendings
        self.isLoading = false
        await moveToPlaying()
      } catch {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
          guard let self else {
            return
          }
          fetch()
        }
      }
    }
  }
  
  func play(_ trending: Trending) {
    guard let firstIndex = playings.firstIndex(where: { $0.id == trending.id }) else {
      return
    }
    let trendingObject = playings.remove(at: firstIndex)
    playings.insert(trendingObject, at: 0)
    if !trendingObject.isDownloaded() {
      DownloadManager.shared.loadPriority(trendingObject)
    }
  }
  
  func willPlay(_ trendingObject: TrendingObject) {
    if !trendingObject.isDownloaded() {
      DownloadManager.shared.loadPriority(trendingObject)
    }
  }
}

extension TrendingManager {
  @MainActor
  private func moveToPlaying() {
    var downloaded = [TrendingObject]()
    var awaitDownload = [TrendingObject]()
    trendings.forEach { trending in
      if let trendingObject = RealmService.shared.getById(ofType: TrendingObject.self, id: trending.id) {
        downloaded.append(trendingObject)
      } else {
        awaitDownload.append(TrendingObject(trending))
      }
    }
    let awaitDownloadShuffled = awaitDownload.shuffled()
    self.playings = downloaded.shuffled() + awaitDownloadShuffled
    DownloadManager.shared.load(awaitDownloadShuffled)
  }
}
