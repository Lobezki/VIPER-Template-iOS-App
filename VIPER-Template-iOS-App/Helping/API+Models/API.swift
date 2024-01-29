//
//  API.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

private enum Base {
  static var url = "https://api.unsplash.com"
  static var clientId = "?client_id=4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"
}

private enum Requests {
  static var photos = "photos"
  static var search = "search/photos"
}

private enum Parameters {
  static func photos(_ page: Int, perPage: Int) -> String {
    return [Base.clientId, DefaultParameters.page(page), DefaultParameters.perPage(perPage)].joined(separator: "&")
  }
  
  static func search(searchQuery query: String) -> String {
    return [Base.clientId, "query=\(query)"].joined(separator: "&")
  }
}

private enum DefaultParameters {
  static func page(_ page: Int) -> String {
    return "page=\(page)"
  }
  static func perPage(_ count: Int) -> String {
    return "per_page=\(count)"
  }
}

enum API {
  static func photos(forPage page: Int, perPage: Int = 30) -> String {
    return [Base.url, Requests.photos, Parameters.photos(page, perPage: perPage)].joined(separator: "/")
  }
  
  static func search(byQuery query: String) -> String {
    return [Base.url, Requests.search, Parameters.search(searchQuery: query)].joined(separator: "/")
  }
}
