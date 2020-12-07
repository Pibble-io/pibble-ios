//
//  StringURLExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 01/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

extension String {
  var hasHttpPrefix: Bool {
    return hasPrefix("https://") || hasPrefix("http://")
  }
  
  var stringByAddingHttpPrefix: String {
    return "http://\(self)"
  }
  
  var stringByRemovingHttpPrefix: String {
    guard hasHttpPrefix else {
      return self
    }
    
    var stringWithoutHttp = replacingOccurrences(of: "https://", with: "")
    stringWithoutHttp = stringWithoutHttp.replacingOccurrences(of: "http://", with: "")
    return stringWithoutHttp
  }
  
  var isValidUrl: Bool {
    let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
    let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
    let result = urlTest.evaluate(with: self)
    return result
  }
}
