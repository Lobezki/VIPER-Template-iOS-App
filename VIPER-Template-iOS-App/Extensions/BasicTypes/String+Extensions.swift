//
//  String+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

extension String {
  
  //  MARK: Variables
  
  var isPlain: Bool {
    return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  var intValue: Int {
    return (self as NSString).integerValue
  }
  
  var floatValue: Float {
    return (self as NSString).floatValue
  }
  
  //  MARK: Initializations
  
  init(key: String) {
    self = NSLocalizedString(key, comment: "")
  }
  
  init?(htmlEncodedString: String?) {
    guard let data = htmlEncodedString?.data(using: .utf8) else {
      return nil
    }
    
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    
    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      return nil
    }
    
    self.init(attributedString.string)
  }
  
  //  MARK: Functions
  
  func applyPatternOnNumbers(pattern: String) -> String {
    var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
    for index in 0 ..< pattern.count {
      guard index < pureNumber.count else { return pureNumber }
      let stringIndex = String.Index(utf16Offset: index, in: self)
      let patternCharacter = pattern[stringIndex]
      guard patternCharacter != "#" else { continue }
      pureNumber.insert(patternCharacter, at: stringIndex)
    }
    return pureNumber
  }
  
  func replace(_ dictionary: [String: String]) -> String{
        var result = String()
        var i = -1
        for (of , with): (String, String)in dictionary{
            i += 1
            if i<1{
                result = self.replacingOccurrences(of: of, with: with)
            }else{
                result = result.replacingOccurrences(of: of, with: with)
            }
        }
      return result
   }
  
  func isBackSpaceDetected() -> Bool {
      let char = self.cString(using: .utf8)!
      let isBackSpace = strcmp(char, "\\b")
      
      if (isBackSpace == -92) {
          return true
      }
      return false
  }
}
