//
//  FileHelper.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 02/11/2023.
//

import UIKit

class FileHelper {
  static let shared = FileHelper()
  
  enum Folder {
    case data
    case gallery
    
    var name: String {
      switch self {
      case .data:
        return "Data"
      case .gallery:
        return "Gallery"
      }
    }
  }
  
  enum FileError: Error {
    case download
    case save

    var description: String! {
      switch self {
      case .download:
        return "Download error!"
      case .save:
        return "Save error!"
      }
    }
  }
  
  func download(url: URL) async throws -> Data {
    do {
      return try Data(contentsOf: url)
    } catch {
      throw FileError.download
    }
  }
  
  func saveCache(data: Data, fileExtension: String) async throws -> String {
    do {
      let fileName = "\(UUID().uuidString).\(fileExtension)"
      guard let cacheURL = getCacheURL(fileName: fileName) else {
        throw FileError.save
      }
      try data.write(to: cacheURL, options: .atomic)
      return fileName
    } catch {
      throw FileError.save
    }
  }
  
  func saveCache(data: Data, to url: URL) async throws {
    do {
      try data.write(to: url, options: .atomic)
    } catch {
      throw FileError.save
    }
  }
  
  func saveStorage(folder: Folder, data: Data, fileExtension: String) async throws -> String {
    do {
      let folderName = folder.name
      guard let folderURL = URL.createFolder(folderName: folderName,
                                             directory: .documentDirectory) else {
        throw FileError.save
      }
      let fileName = "\(UUID().uuidString).\(fileExtension)"
      let fileURL = folderURL.appendingPathComponent(fileName)
      try data.write(to: fileURL, options: .atomic)
      return fileName
    } catch {
      throw FileError.save
    }
  }
  
  func getCacheURL(fileName: String) -> URL? {
    guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                         in: .userDomainMask).first else {
      return nil
    }
    return cachesDirectory.appendingPathComponent(fileName)
  }
  
  func getStorageURL(folder: Folder, fileName: String) -> URL? {
    let folderName = folder.name
    guard let folderURL = URL.createFolder(folderName: folderName,
                                           directory: .documentDirectory) else {
      return nil
    }
    return folderURL.appendingPathComponent(fileName)
  }
  
  func deleteAtURL(url: URL) {
    do {
      try FileManager.default.removeItem(atPath: url.path)
    } catch {}
  }
  
  func deleteCache() {
    guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                         in: .userDomainMask).first else {
      return
    }
    do {
      let directoryContents = try FileManager.default.contentsOfDirectory( at: cachesDirectory,
                                                                           includingPropertiesForKeys: nil,
                                                                           options: [])
      for file in directoryContents {
        do {
          try FileManager.default.removeItem(at: file)
        } catch {}
      }
    } catch {}
  }
}
