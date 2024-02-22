//
//  Trending.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import Foundation

struct Trending: Codable {
  let id: String
  let name: String
  let videoURL: String
  let description: String
  let thumbnailURL: String
  let like: Int
  let music: Music?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case videoURL = "url"
    case description
    case thumbnailURL = "thumb"
    case like
    case music
  }
}
