//
//  GalleryManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 29/11/2023.
//

import UIKit

class GalleryManager {
  static let shared = GalleryManager()
  
  @Published private(set) var records = [RecordObject]()
  @Published private(set) var playings = [RecordObject]()
  @Published private(set) var cacheSelecteds = [RecordObject]()
}

extension GalleryManager {
  func fetch() {
    self.records = RealmService.shared.fetch(ofType: RecordObject.self).reversed()
  }
  
  func save(filename: String, duration: Double, thumbnailFilename: String) {
    RealmService.shared.add(RecordObject(filename: filename,
                                         duration: duration,
                                         thumbnailFilename: thumbnailFilename))
    fetch()
  }
  
  func isSelected(_ record: RecordObject) -> Bool {
    return cacheSelecteds.contains { $0.id == record.id }
  }
  
  func choose(_ record: RecordObject) {
    if isSelected(record) {
      LogEventManager.shared.log(event: .galleryClickEscape)
      cacheSelecteds.removeAll { $0.id == record.id }
    } else {
      LogEventManager.shared.log(event: .galleryClickSelectDetail)
      cacheSelecteds.append(record)
    }
  }
  
  func cleanCache() {
    cacheSelecteds.removeAll()
  }
  
  func deleteSelected() {
    records.removeAll { record in
      return isSelected(record)
    }
    cacheSelecteds.forEach { record in
      RealmService.shared.delete(record)
    }
    cleanCache()
  }
  
  func deleteAll() {
    records.forEach { record in
      RealmService.shared.delete(record)
    }
    records.removeAll()
  }
  
  func delete(_ record: RecordObject) {
    playings.removeAll { $0.id == record.id }
    records.removeAll { $0.id == record.id }
    RealmService.shared.delete(record)
  }
  
  func play(_ record: RecordObject) {
    self.playings = records
    guard let firstIndex = playings.firstIndex(where: { $0.id == record.id }) else {
      return
    }
    let recordObject = playings.remove(at: firstIndex)
    playings.insert(recordObject, at: 0)
  }
}
