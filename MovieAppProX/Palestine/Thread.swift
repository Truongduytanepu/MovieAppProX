//
//  Thread.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import Foundation

class Thread {
  private var task: Task<(), Error>?
  private(set) var id: String
  private var errored: Handler?

  init(id: String) {
    self.id = id
  }
}

extension Thread {
  func load(object: BaseObject, completion: Handler?, errored: Handler?) {
    self.errored = errored
    guard let url = object.dataURL.getCleanedURL() else {
      errored?()
      return
    }
    self.task = Task {
      do {
        let data = try await FileHelper.shared.download(url: url)
        let filename = try await FileHelper.shared.saveStorage(folder: .data,
                                                               data: data,
                                                               fileExtension: url.pathExtension)
        DispatchQueue.main.async {
          RealmService.shared.update(object, data: ["filename": filename])
          RealmService.shared.add(object)
        }
        completion?()
      } catch {
        errored?()
      }
    }
  }
  
  func cancel() {
    task?.cancel()
    errored?()
    self.task = nil
  }
}
