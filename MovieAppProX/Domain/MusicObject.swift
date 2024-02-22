//
//  MusicObject.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import Foundation
import RealmSwift

class MusicObject: BaseObject {
  @Persisted var name: String
  @Persisted var audioURL: String
  @Persisted var describe: String
  @Persisted var thumbnailURL: String
  
  convenience init(_ music: Music) {
    self.init()
    self.id = music.id
    self.dataURL = music.audioURL
    self.name = music.name
    self.audioURL = music.audioURL
    self.describe = music.description
    self.thumbnailURL = music.thumbnailURL
  }
}
