//
//  MediaLibraryExportOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

class MediaLibraryExportOperation: AsyncOperation, ChainingOperationProtocol {
  fileprivate let exportService: MediaLibraryExportServiceProtocol
  
  fileprivate var _input: Result<LibraryAsset, MediaProcessingPipelineError>?
  fileprivate var _output: Result<ExportedLibraryAsset, MediaProcessingPipelineError>?
  
  fileprivate let propertyQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)
  
  var input: Result<LibraryAsset, MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _input } }
    set { propertyQueue.sync(flags: .barrier) { _input = newValue } }
  }
  
  var output: Result<ExportedLibraryAsset, MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _output } }
    set { propertyQueue.sync(flags: .barrier) { _output = newValue } }
  }
  
  init(exportService: MediaLibraryExportServiceProtocol) {
    self.exportService = exportService
  }
  
  override func main() {
    if isCancelled {
      finish()
      return
    }
    
    guard let input = input else {
      output = Result(error: .operationInputNotFound)
      finish()
      return
    }
    
    let asset: LibraryAsset?
    
    switch input {
    case .success(let inputAsset):
      asset = inputAsset
    case .failure(let err):
      asset = nil
      output = Result(error: .underlyingError(err))
    }
    
    guard let mediaAsset = asset else {
      finish()
      return
    }
    
    exportService.exportAsset(mediaAsset) { [weak self]  in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let result):
        strongSelf.output = Result(value: result)
      case .failure(let err):
        strongSelf.output = Result(error: .underlyingError(err))
      }
      
      strongSelf.finish()
    }
  }
}


