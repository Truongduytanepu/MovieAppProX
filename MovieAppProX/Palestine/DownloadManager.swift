//
//  DownloadManager.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import Foundation
import RealmSwift

class DownloadManager {
  static let shared = DownloadManager()
  
  private let maxThread = 4
  private let timeInterval = 0.1
  private var queue = [BaseObject]()
  private var threads = [Thread]()
  private var isLoading = false
  private var timer: Timer?
}

extension DownloadManager {
  func load(_ objects: [BaseObject]) {
    self.queue += objects
    guard !isLoading else {
      return
    }
    fire()
  }
  
  func loadPriority(_ object: BaseObject) {
    guard let firstIndex = queue.firstIndex(where: { $0.id == object.id }) else {
      return
    }
    queue.remove(at: firstIndex)
    queue.insert(object, at: 0)
    if threads.count == maxThread {
      let lastThread = threads.first
      lastThread?.cancel()
    }
  }
}

extension DownloadManager {
  private func invalidate() {
    timer?.invalidate()
    self.timer = nil
    self.isLoading = false
  }
  
  private func fire() {
    invalidate()
    self.isLoading = true
    self.timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                      target: self,
                                      selector: #selector(addThread),
                                      userInfo: nil,
                                      repeats: true)
  }
  
  @objc private func addThread() {
    guard NetworkMonitor.shared.isConnected else {
      return
    }
    guard threads.count < maxThread else {
      return
    }
    guard !queue.isEmpty else {
      if threads.isEmpty {
        invalidate()
      }
      return
    }
    let object = queue.removeFirst()
    let thread = Thread(id: object.id)
    thread.load(object: object) { [weak self] in
      guard let self else {
        return
      }
      threads.removeAll { $0.id == thread.id }
    } errored: { [weak self] in
      guard let self else {
        return
      }
      threads.removeAll { $0.id == thread.id }
      queue.append(object)
    }
    threads.append(thread)
  }
}
