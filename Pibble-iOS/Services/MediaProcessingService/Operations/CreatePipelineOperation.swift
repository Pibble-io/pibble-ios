//
//  CreatePipelineOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
/*
class CreatePipelineOperation: Operation, ChainingOperationProtocol {
  fileprivate let uploadService: MediaUploadServiceProtocol
  fileprivate let mediaLibraryExportService: MediaLibraryExportServiceProtocol
  fileprivate let media: MediaType
  
  fileprivate var _input: Result<(String, String), MediaProcessingPipelineError>?
  fileprivate var _output: Result<MediaProcessingPipeline, MediaProcessingPipelineError>?
  
  fileprivate let propertyQueue = DispatchQueue(label: "MediaUploadOperation.rw.state", attributes: .concurrent)
  
  var input: Result<(String, String), MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _input } }
    set { propertyQueue.sync(flags: .barrier) { _input = newValue } }
  }
  
  var output: Result<MediaProcessingPipeline, MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _output } }
    set { propertyQueue.sync(flags: .barrier) { _output = newValue } }
  }
  
  init(media: MediaType, uploadService: MediaUploadServiceProtocol, mediaLibraryExportService: MediaLibraryExportServiceProtocol) {
    self.uploadService = uploadService
    self.mediaLibraryExportService = mediaLibraryExportService
    self.media = media
  }
  
  override func main() {
    if isCancelled {
      return
    }
    
    guard let input = input else {
      output = Result(error: .operationInputNotFound)
      return
    }
    
    let uuids: (postUUID: String, mediaUUID: String)?
    
    switch input {
    case .success(let inputUUIDs):
      uuids = inputUUIDs
    case .failure(let err):
      uuids = nil
      output = Result(error: .underlyingError(err))
    }
    
    guard let inputUUIDs = uuids else {
      return
    }
    
    if isCancelled {
      return
    }
    
    let pipeline = MediaProcessingPipeline(media,
                                           postUUID: inputUUIDs.postUUID,
                                           mediaUUID: inputUUIDs.mediaUUID,
                                           uploadService: uploadService,
                                           mediaLibraryExportService: mediaLibraryExportService)
    output = Result(value: pipeline)
  }
}
*/
