//
//  APIManager.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import Foundation
import CryptoKit

class APIManager: NSObject {
  static let shared = APIManager()
  
  func getTrending() async throws -> TrendingResponse {
    guard let request = APIService.trending.request() else {
      throw APIError.invalidRequest
    }
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    
    switch httpResponse.statusCode {
    case 200...299:
      break
    default:
      throw APIError.invalidResponse
    }
    
    let decodeData = try JSONDecoder().decode(TrendingResponse.self, from: data)
    return decodeData
  }
  
  func getMusic() async throws -> MusicResponse {
    guard let request = APIService.music.request() else {
      throw APIError.invalidRequest
    }
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }
    
    switch httpResponse.statusCode {
    case 200...299:
      break
    default:
      throw APIError.invalidResponse
    }
    
    let decodeData = try JSONDecoder().decode(MusicResponse.self, from: data)
    return decodeData
  }
  
//  func getFilter() async throws -> FilterResponse {
//    guard let request = APIService.filter.request() else {
//      throw APIError.invalidRequest
//    }
//    let (data, response) = try await URLSession.shared.data(for: request)
//    
//    guard let httpResponse = response as? HTTPURLResponse else {
//      throw APIError.invalidResponse
//    }
//    
//    switch httpResponse.statusCode {
//    case 200...299:
//      break
//    default:
//      throw APIError.invalidResponse
//    }
//    
//    let decodeData = try JSONDecoder().decode(FilterResponse.self, from: data)
//    return decodeData
//  }
    
    func getFilter<T: Codable>(with object: T.self) async throws -> T {
      guard let request = APIService.filter.request() else {
        throw APIError.invalidRequest
      }
      let (data, response) = try await URLSession.shared.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.invalidResponse
      }
      
      switch httpResponse.statusCode {
      case 200...299:
        break
      default:
        throw APIError.invalidResponse
      }
      
        let decodeData = try JSONDecoder().decode(object, from: data)
      return decodeData
    }
}
