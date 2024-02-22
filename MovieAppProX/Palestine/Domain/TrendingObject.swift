//
//  TrendingObject.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import Foundation
import RealmSwift

class TrendingObject: BaseObject {
  @Persisted var name: String
  @Persisted var videoURL: String
  @Persisted var describe: String
  @Persisted var thumbnailURL: String
  @Persisted var like: Int
  @Persisted var musicId: String?
  
  convenience init(_ trending: Trending) {
    self.init()
    self.id = trending.id
    self.dataURL = trending.videoURL
    self.name = trending.name
    self.videoURL = trending.videoURL
    self.describe = trending.description
    self.thumbnailURL = trending.thumbnailURL
    self.like = trending.like
    self.musicId = trending.music?.id
  }
}
