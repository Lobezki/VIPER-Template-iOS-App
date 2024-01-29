//
//  NetworkingManager.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

protocol JSONEncodable: Codable {
  func toJSONData() -> Data?
}

extension JSONEncodable {
  func toJSONData() -> Data? {
    return try? JSONEncoder().encode(self)
  }
}

@frozen enum Header {
  case host
  case contentLength
  case contentType
  case apiKey
  case apiUser(String)
  case multipart
  case bearer(String)
  case application(String)
  
  var rawValue: (header: String, value: String?) {
    switch self {
    case .contentType:
      return ("Content-Type", "application/json")
    case .contentLength:
      return ("Content-Length", nil)
    case .apiKey:
      return ("Api-Key", "example-api-key-string")
    case .apiUser(let user):
      return ("Api-Username", user)
    case .host:
      return ("Host", "")
    case .multipart:
      return ("Content-Type", "multipart/form-data")
    case .bearer(let token):
      return ("Authorization", "Bearer \(token)")
    case .application(let applicationType):
      return ("Application", applicationType)
    }
  }
}

@frozen enum HTTPMethod: String {
  case get
  case post
  case put
  case patch
  case update
  case delete
  
  var rawValue: String {
    return String(describing: self).uppercased()
  }
}

@frozen enum DataTaskResult<ResultType: Codable> {
  case success(ResultType)
  case error(DataTaskError<ResultType>)
}

@frozen enum DataTaskError<DecodeType>: Error {
  case genericError(Error)
  case invalidURL(String)
  case invalidRequestBody(Decodable)
  case dataIsEmpty
  case cannotObtainData(Int)
  case invalidDecoding(Data, DecodeType)
  
  var localizedDescription: String {
    let headMsg = "Error:"
    var errMsg = ""
    
    switch self {
    case .genericError(let error):
      errMsg = error.localizedDescription
    case .invalidURL(let urlStr):
      errMsg = [urlStr, "cannot be convertet to URL"].joined(separator: " ")
    case .invalidRequestBody(let object):
      errMsg = "Cannot obtain correct data from: \(object)"
    case .dataIsEmpty:
      errMsg = "Request returned empty body"
    case .cannotObtainData(let status):
      errMsg = "Data cannot be obtained because of server status: \(status)"
    case .invalidDecoding(let data, let decodeType):
      errMsg = ["Unable to decode obtined data",
                String(data: data, encoding: .utf8) ?? "",
                "as \(type(of: decodeType))"]
        .joined(separator: " ")
    }
    
    return [headMsg, errMsg].joined(separator: " ")
  }
}

final class NetworkingManager: NSObject {
  private var session: URLSession
  static let shared = NetworkingManager()
  
  override init() {
    let configuration = URLSessionConfiguration.default
    session = URLSession(configuration: configuration)
  }
  
  func startGetTaskWithHTTPRedirection<ObjectType: Codable>(forURL urlStr: String,
                                         headers: [Header] = [],
                                         responseObject: ObjectType.Type,
                                         completion: @escaping (DataTaskResult<ObjectType>) -> Void) {
    guard let url = URL(string: urlStr) else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    headers.forEach { header in
      switch header {
      case .host:
        let host = urlStr.split(separator: "/").map{ String($0) }[1]
        request.addValue(host, forHTTPHeaderField: header.rawValue.header)
      default: request.setValue(header.rawValue.value, forHTTPHeaderField: header.rawValue.header)
      }
    }

    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    
    session.dataTask(with: request) { data, response, error in
      
//      print(request)
//      print("JSON String: \(String(describing: String(data: data!, encoding: .utf8)))")
//      if let response = response as? HTTPURLResponse{
//
//        print(response)
//      }
      
      if let httpResponse = response as? HTTPURLResponse {
           if let link = httpResponse.allHeaderFields["Location"] as? String {
             dispatchMain {
               completion(.success(RedirectUrl(link: link) as! ObjectType))
             }
           }
      }
      
      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let _ = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
    }.resume()
  }
  
  func startGetTask<ObjectType: Codable>(forURL urlStr: String,
                                         headers: [Header] = [],
                                         responseObject: ObjectType.Type,
                                         completion: @escaping (DataTaskResult<ObjectType>) -> Void) {
    guard let url = URL(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    headers.forEach { header in
      switch header {
      case .host:
        let host = urlStr.split(separator: "/").map{ String($0) }[1]
        request.addValue(host, forHTTPHeaderField: header.rawValue.header)
      default: request.setValue(header.rawValue.value, forHTTPHeaderField: header.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in

      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let data = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let object = try decoder.decode(responseObject, from: data)
        dispatchMain {
          completion(.success(object))
        }
      } catch {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
      }
    }.resume()
  }
  
  func startGetTask<ObjectType: Codable>(forURL urlStr: String,
                                         headers: [Header] = [],
                                         appendingComponents components: [String: String],
                                         responseObject: ObjectType.Type,
                                         completion: @escaping (DataTaskResult<ObjectType>) -> Void) {

    guard var urlComp = URLComponents(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    let items = components.map { component -> URLQueryItem in
      return URLQueryItem(name: component.key, value: component.value)
    }
    
    urlComp.queryItems = items
    guard let url = urlComp.url else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    headers.forEach { header in
      switch header {
      case .host:
        let host = urlStr.split(separator: "/").map{ String($0) }[1]
        request.addValue(host, forHTTPHeaderField: header.rawValue.header)
      default: request.setValue(header.rawValue.value, forHTTPHeaderField: header.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in
      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let data = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let object = try decoder.decode(responseObject, from: data)
        dispatchMain {
          completion(.success(object))
        }
      } catch {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
      }
    }.resume()
  }
  
  func startPostTask<ResponseObjectType, ErrorType>(forURL urlStr: String,
                                                    appendingComponents components: [String: String],
                                                    responseObject: ResponseObjectType.Type,
                                                    errorObject: ErrorType.Type?,
                                                    headers: [Header],
                                                    completion: @escaping (DataTaskResult<ResponseObjectType>) -> Void,
                                                    failure: @escaping (DataTaskResult<ErrorType>) -> Void)
  where ResponseObjectType: Codable, ErrorType: Codable {
    guard var urlComp = URLComponents(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    let items = components.map { component -> URLQueryItem in
      return URLQueryItem(name: component.key, value: component.value)
    }
    
    urlComp.queryItems = items
    guard let url = urlComp.url else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    headers.forEach { header in
      switch header {
      case .host:
        let host = urlStr.split(separator: "/").map{ String($0) }[1]
        request.addValue(host, forHTTPHeaderField: header.rawValue.header)
      default: request.setValue(header.rawValue.value, forHTTPHeaderField: header.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in
      let decoder = JSONDecoder()
      
      if let errorObject = errorObject, let data = data {
        do {
          let object = try decoder.decode(errorObject, from: data)
          dispatchMain {
            failure(.success(object))
          }
        } catch {
          dispatchMain {
            failure(.error(.genericError(error)))
          }
        }
      }
      
      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let data = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
      
      do {
        let object = try decoder.decode(responseObject, from: data)
        dispatchMain {
          completion(.success(object))
        }
      } catch {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
      }
    }.resume()
  }
  
  func startPostTask<PostObjectType, ResponseObjectType, ErrorType>(forURL urlStr: String,
                                                                    postObject: PostObjectType,
                                                                    responseObject: ResponseObjectType.Type,
                                                                    errorObject: ErrorType.Type? = nil,
                                                                    headers: [Header] = [.contentType],
                                                                    completion: @escaping (DataTaskResult<ResponseObjectType>) -> Void,
                                                                    failure: ((DataTaskResult<ErrorType>) -> Void)? = nil)
  where PostObjectType: JSONEncodable, ResponseObjectType: Codable, ErrorType: Codable {
    
    guard let url = URL(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    guard let httpBody = postObject.toJSONData() else {
      completion(.error(.invalidRequestBody(postObject)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = httpBody
    
    headers.forEach { item in
      switch item {
      case .contentLength:
        request.setValue("\(httpBody.count)", forHTTPHeaderField: item.rawValue.header)
      case .host:
        let host = urlStr.split(separator: "/").map{ String($0) }[1]
        request.addValue(host, forHTTPHeaderField: item.rawValue.header)
      default:
        request.setValue(item.rawValue.value, forHTTPHeaderField: item.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in
      let decoder = JSONDecoder()
      
      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let data = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
      
      do {
        let object = try decoder.decode(responseObject, from: data)
        dispatchMain {
          completion(.success(object))
        }
      } catch {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
      }
      
      if let errorObject = errorObject {
        do {
          let object = try decoder.decode(errorObject, from: data)
          dispatchMain {
            failure?(.success(object))
          }
        } catch {
          dispatchMain {
            failure?(.error(.genericError(error)))
          }
        }
      }
    }.resume()
  }
  
  func startEmptyRequest<PostObjectType, ErrorType>(forURL urlStr: String,
                                                    method: String = "POST",
                                                    postObject: PostObjectType,
                                                    errorObject: ErrorType.Type? = nil,
                                                    headers: [Header] = [.contentType],
                                                    completion: @escaping (DataTaskResult<Bool>) -> Void,
                                                    failure: ((DataTaskResult<ErrorType>) -> Void)? = nil)
  where PostObjectType: JSONEncodable, ErrorType: Codable {
    
    guard let url = URL(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    guard let httpBody = postObject.toJSONData() else {
      completion(.error(.invalidRequestBody(postObject)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.httpBody = httpBody
    
    headers.forEach { item in
      switch item {
      case .contentLength:
        request.setValue("\(httpBody.count)", forHTTPHeaderField: item.rawValue.header)
      default:
        request.setValue(item.rawValue.value, forHTTPHeaderField: item.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in
      let decoder = JSONDecoder()
      
      if let errorObject = errorObject, let data = data {
        do {
          let object = try decoder.decode(errorObject, from: data)
          dispatchMain {
            failure?(.success(object))
          }
        } catch {
          dispatchMain {
            failure?(.error(.genericError(error)))
          }
        }
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let response = response as? HTTPURLResponse else { return }
      
      dispatchMain {
        switch response.statusCode {
        case 200...399:
          completion(.success(true))
        case 400...600:
          completion(.error(.cannotObtainData(response.statusCode)))
        default: return
        }
      }
    }.resume()
  }
  
  func downloadImage(forURL urlStr: String, completion: @escaping (DataTaskResult<Data>) -> ()) {
    guard let url = URL(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    session.dataTask(with: url) { data, response, error in
      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let data = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
      
      dispatchMain {
        CacheManager.shared.cacheImage(data, byKey: urlStr)
        completion(.success(data))
      }
    }.resume()
  }
  
  func startEmptyRequest<ErrorType>(forURL urlStr: String,
                                                    method: String = "POST",
                                                    errorObject: ErrorType.Type? = nil,
                                                    headers: [Header] = [.contentType],
                                                    completion: @escaping (DataTaskResult<Bool>) -> Void,
                                                    failure: ((DataTaskResult<ErrorType>) -> Void)? = nil)
  where ErrorType: Codable {
    
    guard let url = URL(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    
    headers.forEach { item in
      switch item {
      default:
        request.setValue(item.rawValue.value, forHTTPHeaderField: item.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in
      let decoder = JSONDecoder()
      
      if let errorObject = errorObject, let data = data {
        do {
          let object = try decoder.decode(errorObject, from: data)
          dispatchMain {
            failure?(.success(object))
          }
        } catch {
          dispatchMain {
            failure?(.error(.genericError(error)))
          }
        }
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let response = response as? HTTPURLResponse else { return }
      
      dispatchMain {
        switch response.statusCode {
        case 200...399:
          completion(.success(true))
        case 400...600:
          completion(.error(.cannotObtainData(response.statusCode)))
        default: return
        }
      }
    }.resume()
  }
  
  func uploadFile<ResponseType, ErrorType>(forURL urlStr: String,
                                           components: [String: String] = [:],
                                           fileData: Data,
                                           attachment: Attachment,
                                           method: HTTPMethod = .post,
                                           responseObject: ResponseType.Type,
                                           errorObject: ErrorType.Type,
                                           headers: [Header],
                                           completion: @escaping (DataTaskResult<ResponseType>) -> (),
                                           failure: ((DataTaskResult<ErrorType>) -> Void)? = nil)
  where ResponseType: Codable, ErrorType: Codable {
    let boundary = UUID().uuidString
    guard var urlComp = URLComponents(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    let items = components.map { component -> URLQueryItem in
      return URLQueryItem(name: component.key, value: component.value)
    }
    
    urlComp.queryItems = items
    
    var url: URL?
    if components.isEmpty {
      url = URL(string: urlStr)
    } else {
      url = urlComp.url
    }
    guard let url = url else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    let body = boundaryDataOf(boundary: boundary, fileData: fileData, attachment: attachment)
    request.httpBody = body
    headers.forEach { item in
      switch item {
      case .multipart:
        request.setValue("\(item.rawValue.value ?? ""); boundary=\(boundary)", forHTTPHeaderField: item.rawValue.header)
      case .contentLength:
        request.setValue("\(body.count)", forHTTPHeaderField: item.rawValue.header)
      case .host:
        let host = urlStr.split(separator: "/").map{ String($0) }[1]
        request.addValue(host, forHTTPHeaderField: item.rawValue.header)
      default:
        request.setValue(item.rawValue.value, forHTTPHeaderField: item.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in
      let decoder = JSONDecoder()
      
      if let data = data {
        do {
          let object = try decoder.decode(errorObject, from: data)
          dispatchMain {
            failure?(.success(object))
          }
        } catch {
          dispatchMain {
            failure?(.error(.genericError(error)))
          }
        }
      }
      
      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
      
      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let data = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
      
      do {
        let object = try decoder.decode(responseObject, from: data)
        dispatchMain {
          completion(.success(object))
        }
      } catch {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
      }
    }.resume()
  }
  
  func boundaryDataOf(boundary: String = UUID().uuidString, fileData: Data, attachment: Attachment) -> Data {
    var body = Data()
    
    if let anEncoding = "\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8) {
      body.append(anEncoding)
    }
    if let anEncoding = "Content-Disposition: form-data; name=\"\(attachment.name)\" \r\n\r\n".data(using: String.Encoding.utf8) {
      body.append(anEncoding)
    }
    
    //      if let httpBody = try? JSONEncoder().encode(model) {
    //          body.append(httpBody)
    //      }
    
    if let anEncoding = "\r\n\r\n--\(boundary)".data(using: String.Encoding.utf8) {
      body.append(anEncoding)
    }
    
    
    if let anEncoding = "\r\nContent-Disposition: form-data; name=\"\(attachment.name)\"; filename=\"\(attachment.fileName)\""
        .data(using: String.Encoding.utf8) {
      body.append(anEncoding)
    }
    
    if let anEncoding = "\r\nContent-Type: \(attachment.mimeType)\r\n\r\n".data(using: String.Encoding.utf8) {
      body.append(anEncoding)
    }
    
    body.append(fileData)
    
    if let anEncoding = "\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8) {
      body.append(anEncoding)
    }
    
    return body
  }
  
  func startDataTask<PostObjectType, ResponseObjectType, ErrorType>(forURL urlStr: String,
                                                                    method: HTTPMethod = .get,
                                                                    appendingComponents components: [String: String]? = nil,
                                                                    postObject: PostObjectType,
                                                                    responseObject: ResponseObjectType.Type,
                                                                    errorObject: ErrorType.Type? = nil,
                                                                    headers: [Header] = [.contentType],
                                                                    completion: @escaping (DataTaskResult<ResponseObjectType>) -> Void,
                                                                    failure: ((DataTaskResult<ErrorType>) -> Void)? = nil)
  where PostObjectType: JSONEncodable, ResponseObjectType: Codable, ErrorType: Codable {
//    guard let url = URL(string: urlStr) else {
//      completion(.error(.invalidURL(urlStr)))
//      return
//    }
    guard var urlComp = URLComponents(string: urlStr) else {
      completion(.error(.invalidURL(urlStr)))
      return
    }
    
    if let components = components {
      let items = components.map { component -> URLQueryItem in
        return URLQueryItem(name: component.key, value: component.value)
      }
      
      urlComp.queryItems = items
    }
    
    guard let url = urlComp.url else { return }
    
    guard let httpBody = postObject.toJSONData() else {
      completion(.error(.invalidRequestBody(postObject)))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.httpBody = httpBody
    
    headers.forEach { item in
      switch item {
      case .contentLength:
        request.setValue("\(httpBody.count)", forHTTPHeaderField: item.rawValue.header)
      case .host:
        let host = urlStr.split(separator: "/").map{ String($0) }[1]
        request.addValue(host, forHTTPHeaderField: item.rawValue.header)
      default:
        request.setValue(item.rawValue.value, forHTTPHeaderField: item.rawValue.header)
      }
    }
    
    session.dataTask(with: request) { data, response, error in
      
//      if let jsonResponse = String(data: data!, encoding: String.Encoding.utf8) {
//          print("JSON String: \(jsonResponse)")
//      }
      
      let decoder = JSONDecoder()

      if let error = error, data == nil {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
        return
      }
      
      guard let data = data else {
        dispatchMain {
          completion(.error(.dataIsEmpty))
        }
        return
      }
      
      do {
        let object = try decoder.decode(responseObject, from: data)
        dispatchMain {
          completion(.success(object))
        }
        return
      } catch {
        dispatchMain {
          completion(.error(.genericError(error)))
        }
      }
      
      if let errorObject = errorObject {
        do {
          let object = try decoder.decode(errorObject, from: data)
          dispatchMain {
            failure?(.success(object))
          }
          return
        } catch {
          dispatchMain {
            failure?(.error(.genericError(error)))
          }
        }
      }
      
      if let response = response as? HTTPURLResponse, 400...600 ~= response.statusCode {
        dispatchMain {
          completion(.error(.cannotObtainData(response.statusCode)))
        }
        return
      }
    }.resume()
  }
}

// MARK: - Push to main asyncronyously
fileprivate func dispatchMain(completion: @escaping () -> Void) {
  DispatchQueue.main.async {
    completion()
  }
}

// MARK: - Custom networking errors
enum NetworkError: Error {
  case invalidURL
  case dataIsEmpty
  case invalidBody
}

extension NetworkingManager: URLSessionTaskDelegate, URLSessionDelegate {
  func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {

    if let urlString = request.url?.absoluteString {
      if urlString == "https://example.com" {
        completionHandler(nil)
      } else {
        completionHandler(request)
      }
    }
  }
}
