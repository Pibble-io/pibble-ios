//
//  StringTrimmingExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

extension String {
  func trimmed() -> String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  func cleanedFromExtraNewLines() -> String {
    var trimmed = trimmingCharacters(in: CharacterSet.newlines)
    
    while let rangeToReplace = trimmed.range(of: "\n\n") {
      trimmed.replaceSubrange(rangeToReplace, with: "\n")
    }
    
    return trimmed
  }
  
  func replaceNewLinesWith(_ string: String) -> String {
    var trimmed = trimmingCharacters(in: CharacterSet.newlines)
    
    while let rangeToReplace = trimmed.range(of: "\n") {
      trimmed.replaceSubrange(rangeToReplace, with: string)
    }
    
    return trimmed
  }
}
