//
//  Music.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 28/11/2023.
//

import Foundation

struct Music: Codable {
  let id: String
  let name: String
  let audioURL: String
  let description: String
  let thumbnailURL: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case audioURL = "url"
    case description
    case thumbnailURL = "thumb"
  }
}
