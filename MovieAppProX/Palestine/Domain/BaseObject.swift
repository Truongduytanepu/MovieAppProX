//
//  BaseObject.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import Foundation
import RealmSwift

class BaseObject: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var dataURL: String
  @Persisted var filename: String?
  
  func isDownloaded() -> Bool {
    return filename != nil
  }
}
