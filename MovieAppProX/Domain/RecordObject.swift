//
//  RecordObject.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import Foundation
import RealmSwift

class RecordObject: BaseObject {
  @Persisted var thumbnailFilename: String
  @Persisted var creationDate: Date
  @Persisted var duration: Double
  
  convenience init(filename: String, duration: Double, thumbnailFilename: String) {
    self.init()
    self.id = UUID().uuidString
    self.creationDate = Date()
    self.duration = duration
    self.filename = filename
    self.thumbnailFilename = thumbnailFilename
  }
}
