//
//  UICollectionViewSquareMosaicProtocols.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - SquareMosaicBlock
typealias Block = SquareMosaicBlock

protocol SquareMosaicBlock {
  
  func blockFrames() -> Int
  func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect]
  func blockRepeated() -> Bool
}

extension SquareMosaicBlock {
  
  func blockRepeated() -> Bool {
    return false
  }
}

enum SquareMosaicBlockSeparatorPosition: Int {
  
  case after, before, between
}

protocol SquareMosaicDataSource: class {
  
  func layoutPattern(for section: Int) -> SquareMosaicPattern
  func layoutSeparatorBetweenSections() -> CGFloat
  func layoutSupplementaryBackerRequired(for section: Int) -> Bool
  func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary?
  func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary?
}

extension SquareMosaicDataSource {
  
  func layoutSeparatorBetweenSections() -> CGFloat {
    return 0
  }
  
  func layoutSupplementaryBackerRequired(for section: Int) -> Bool {
    return false
  }
  
  func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary? {
    return nil
  }
  
  func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary? {
    return nil
  }
}

protocol SquareMosaicDelegate: class {
  
  func layoutContentSizeChanged(to size: CGSize) -> Void
}

enum SquareMosaicDirection: Int {
  
  case horizontal, vertical
}

protocol SquareMosaicPattern {
  
  func patternBlocks() -> [SquareMosaicBlock]
  func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat
}

extension SquareMosaicPattern {
  
  func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
    return 0
  }
}

protocol SquareMosaicSupplementary {
  
  func supplementaryFrame(for origin: CGFloat, side: CGFloat) -> CGRect
  func supplementaryHiddenForEmptySection() -> Bool
}

extension SquareMosaicSupplementary {
  
  func supplementaryHiddenForEmptySection() -> Bool {
    return false
  }
}
