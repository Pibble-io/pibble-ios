//
//  MediaUploadOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 17.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol Uploadable {
  var fileURL: URL { get }
  var additionalFileUrl: URL? { get }
}

class MediaUploadOperation<T: Uploadable>: AsyncOperation, ChainingOperationProtocol {
  fileprivate let uploadService: MediaUploadServiceProtocol
  fileprivate let postUUID: String
  fileprivate let mediaUUID: String
  fileprivate let isDigitalGood: Bool
  
  fileprivate var _input: Result<T, MediaProcessingPipelineError>?
  fileprivate var _output: Result<UploadedMediaProtocol, MediaProcessingPipelineError>?
  
  fileprivate let propertyQueue = DispatchQueue(label: "MediaUploadOperation.rw.state", attributes: .concurrent)
  
  var input: Result<T, MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _input } }
    set { propertyQueue.sync(flags: .barrier) { _input = newValue } }
  }
  
  var output: Result<UploadedMediaProtocol, MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _output } }
    set { propertyQueue.sync(flags: .barrier) { _output = newValue } }
  }
  
  init(postUUID: String, mediaUUID: String, uploadService: MediaUploadServiceProtocol, isDigitalGood: Bool) {
    self.uploadService = uploadService
    self.postUUID = postUUID
    self.mediaUUID = mediaUUID
    self.isDigitalGood = isDigitalGood
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
    
    let url: URL?
    let additionalFileUrl: URL?
   
    switch input {
    case .success(let inputUrl):
      url = inputUrl.fileURL
      additionalFileUrl = inputUrl.additionalFileUrl
    case .failure(let err):
      url = nil
      additionalFileUrl = nil
      output = Result(error: .underlyingError(err))
    }
    
    guard let fileUrl = url else {
      finish()
      return
    }
    
    AppLogger.debug("uploadService started: \(fileUrl)")
    uploadService.uploadFile(fileUrl,
                             originalMediaFileURL: additionalFileUrl,
                             asDigitalGood: isDigitalGood,
                             postUUID: postUUID,
                             mediaUUID: mediaUUID,
                             callbackQueue: DispatchQueue.global(qos: .utility)) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      guard !strongSelf.isCancelled else {
        strongSelf.finish()
        return
      }
      
      switch $0 {
      case .success(let uploadedMedia):
        AppLogger.debug("uploadService finished: \(fileUrl)")
        strongSelf.output = Result(value: uploadedMedia)
      case .failure(let error):
        AppLogger.error("uploadService finished: \(error.localizedDescription)")
        strongSelf.output = Result(error: .underlyingError(error))
      }
      
      strongSelf.finish()
    }
  }
}
