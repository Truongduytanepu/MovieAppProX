//
//  APIService.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 24/10/2023.
//

import Foundation

enum APIService {
  case trending
  case music
  case filter
  
  var domain: String {
    switch self {
    default:
      return URLs.domain
    }
  }
  
  var path: String? {
    switch self {
    case .trending:
      return "/now/v1/trending"
    case .music:
      return "/now/v1/music"
    case .filter:
      return "/now/v1/trendingType"
    }
  }
  
  var method: String {
    switch self {
    default:
      return "GET"
    }
  }
  
  var params: [String: String?] {
    let params: [String: String?] = [:]
    switch self {
    default:
      break
    }
    return params
  }
  
  var headers: [String: String?] {
    var headers: [String: String?] = [:]
    switch self {
    default:
      headers["Content-Type"] = "application/json"
    }
    return headers
  }
}

extension APIService {
  func request(body: Data? = nil) -> URLRequest? {
    guard
      let url = URL(string: domain),
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    else {
      return nil
    }
    if let path {
      urlComponents.path = path
    }
    urlComponents.queryItems = params.map({
      return URLQueryItem(name: $0, value: $1)
    })
    
    guard let urlRequest = urlComponents.url else {
      return nil
    }
    var request = URLRequest(url: urlRequest)
    request.httpMethod = method
    
    headers.forEach {
      request.setValue($1, forHTTPHeaderField: $0)
    }
    
    if let body {
      request.httpBody = body
    }
    
    return request
  }
}
