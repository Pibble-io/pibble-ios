//
//  MosaicGridLayout.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

final class MosaicGridLayout: SquareMosaicLayout, SquareMosaicDataSource {
  
  convenience init() {
    self.init(direction: SquareMosaicDirection.vertical)
    self.dataSource = self
  }
  
  func layoutPattern(for section: Int) -> SquareMosaicPattern {
    return FMMosaicLayoutCopyPattern()
  }
}

fileprivate class FMMosaicLayoutCopyPattern: SquareMosaicPattern {
  
  func patternBlocks() -> [SquareMosaicBlock] {
    return [
      MosaicGridLayoutLineBlock(),
      MosaicGridLayoutBigRightBlock(),
      MosaicGridLayoutLineBlock(),
      MosaicGridLayoutBigLeftBlock()
    ]
  }

  func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
    switch position {
    case .after:
      return 0.0
    case .before:
      return 0.0
    case .between:
      return 1.0
    }
  }
}

fileprivate class MosaicGridLayoutBigLeftBlock: SquareMosaicBlock {
  fileprivate let separator: CGFloat = 1.0
  
  func blockFrames() -> Int {
    return 3
  }
  
  func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
    let min = side / 3.0
    let max = side - min + separator
    var frames = [CGRect]()
    frames.append(CGRect(x: 0, y: origin, width: max, height: max))
    frames.append(CGRect(x: min * 2 + separator * 2 , y: origin, width: min, height: min))
    frames.append(CGRect(x: min * 2 + separator * 2, y: origin + min + separator, width: min, height: min))
    return frames
  }
}

fileprivate class MosaicGridLayoutLineBlock: SquareMosaicBlock {
  fileprivate let separator: CGFloat = 1.0
  
  func blockFrames() -> Int {
    return 3
  }
  
  func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
    let min = side / 3.0
    var frames = [CGRect]()
    frames.append(CGRect(x: 0, y: origin, width: min, height: min))
    frames.append(CGRect(x: min + separator, y: origin, width: min, height: min))
    frames.append(CGRect(x: (min + separator) * 2, y: origin, width: min, height: min))
    return frames
  }
}

fileprivate class MosaicGridLayoutBigRightBlock: SquareMosaicBlock {
  fileprivate let separator: CGFloat = 1.0
  
  func blockFrames() -> Int {
    return 3
  }
  
  func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
    let min = side / 3.0
    let max = side - min + separator
    var frames = [CGRect]()
    frames.append(CGRect(x: 0, y: origin, width: min, height: min))
    frames.append(CGRect(x: 0, y: origin + min + separator, width: min, height: min))
    frames.append(CGRect(x: min + separator, y: origin, width: max, height: max))
    return frames
  }
}
