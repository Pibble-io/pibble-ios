//
//  VideoResizeOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 04.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol ResizableVideoFile: Uploadable {
  var fileURL: URL { get }
  var crop: UIEdgeInsets { get }
}

class VideoResizeOperation<T: ResizableVideoFile>: AsyncOperation, ChainingOperationProtocol {
  fileprivate let exportService: MediaLibraryExportServiceProtocol
  
  fileprivate var _input: Result<T, MediaProcessingPipelineError>?
  fileprivate var _output: Result<URL, MediaProcessingPipelineError>?
  
  fileprivate let propertyQueue = DispatchQueue(label: "VideoResizeOperation.rw.state", attributes: .concurrent)
  
  var input: Result<T, MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _input } }
    set { propertyQueue.sync(flags: .barrier) { _input = newValue } }
  }
  
  var output: Result<URL, MediaProcessingPipelineError>? {
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
    
    let assetURL: URL?
    let assetCrop: UIEdgeInsets?
    
    switch input {
    case .success(let operationInput):
      assetURL = operationInput.fileURL
      assetCrop = operationInput.crop
    case .failure(let err):
      assetURL = nil
      assetCrop = nil
      output = Result(error: .underlyingError(err))
    }
    
    guard let url = assetURL, let crop = assetCrop else {
      finish()
      return
    }
    
    exportService.resizeVideoAt(url, cropPerCent: crop) { [weak self]  in
      guard let strongSelf = self else {
        return
      }
      strongSelf.output = $0
      strongSelf.finish()
    }
  }

}
