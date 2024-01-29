//
//  Attachment.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

struct FileAttachment {
  let data: Data
  let type: Attachment
  var response: AttachmentResponse?
}

enum Attachment {
  case cImage, pdf, uImage
  
  var name: String {
    switch self {
    case .uImage:
      return "image"
    default: return "file"
    }
  }
  
  var mimeType: String {
    switch self {
    case .cImage, .uImage:
      return "image/png"
    case .pdf:
      return "multipart/form-data"
    }
  }
  
  var fileName: String {
    switch self {
    case .cImage, .uImage:
      return "avatar.png"
    case .pdf:
      return "document.pdf"
    }
  }
}

struct AttachmentResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case url
    case shortURL
    case width
    case height
    case fileName
    case fileSize
  }
  
  let id: Int
  let url: String
  let shortURL: String
  let width: Int?
  let height: Int?
  let fileName: String
  let fileSize: String
}
