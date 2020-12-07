//
//  DelayBlockObject.swift
//  Pibble
//
//  Created by Kazakov Sergey on 21.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

class DelayBlockObject: NSObject {
  fileprivate var performBlock: (() -> Void)?
  
  func cancel() {
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.performDelayBlock), object: nil)
  }
  
  func scheduleAfter(delay: TimeInterval, block: (() -> Void)?) {
    performBlock = block
    perform(#selector(self.performDelayBlock), with: nil, afterDelay: delay)
  }
  
  @objc func performDelayBlock() {
    performBlock?()
  }
}
