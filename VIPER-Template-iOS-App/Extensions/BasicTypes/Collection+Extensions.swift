//
//  Collection+Extensions.swift
//  VIPER-Template-iOS-App
//
//  Created by Kirill Surelo on 04.02.2023.
//

import Foundation

extension Collection {
  @inlinable
  public __consuming func split(maxSplits: Int = Int.max, omittingEmptySubsequences: Bool = true, includeSeparator: Bool = false, whereSeparator isSeparator: (Element) throws -> Bool) rethrows -> [SubSequence] {
    var result: [SubSequence] = []
    var subSequenceStart: Index = startIndex

    func appendSubsequence(end: Index) -> Bool {
      if subSequenceStart == end && omittingEmptySubsequences {
        return false
      }
      result.append(self[subSequenceStart..<end])
      return true
    }

    if maxSplits == 0 || isEmpty {
      _ = appendSubsequence(end: endIndex)
      return result
    }

    var subSequenceEnd = subSequenceStart
    let cachedEndIndex = endIndex
    while subSequenceEnd != cachedEndIndex {
      if try isSeparator(self[subSequenceEnd]) {
        let didAppend = appendSubsequence(end: subSequenceEnd)
        if includeSeparator {
          subSequenceStart = subSequenceEnd
          formIndex(after: &subSequenceEnd)
        } else {
          formIndex(after: &subSequenceEnd)
          subSequenceStart = subSequenceEnd
        }

        if didAppend && result.count == maxSplits {
          break
        }
        continue
      }
      formIndex(after: &subSequenceEnd)
    }

    if subSequenceStart != cachedEndIndex || !omittingEmptySubsequences {
        result.append(self[subSequenceStart..<cachedEndIndex])
    }

    return result
  }
}

public extension MutableCollection {
  subscript(safe index: Index) -> Element? {
    get {
      return indices.contains(index) ? self[index] : nil
    }
    set(newValue) {
      if let newValue = newValue, indices.contains(index) {
        self[index] = newValue
      }
    }
  }
}
