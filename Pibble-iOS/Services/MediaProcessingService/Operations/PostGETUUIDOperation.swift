
//
//  PostGETUUIDOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

class PostGetUUIDOperation: AsyncOperation, ChainableOperationProtocol {
  fileprivate let postingService: PostingServiceProtocol
  
  fileprivate var _output: Result<String, MediaProcessingPipelineError>?
  
  fileprivate let propertyQueue = DispatchQueue(label: "PostGetUUIDOperation.rw.state", attributes: .concurrent)
  
  var output: Result<String, MediaProcessingPipelineError>? {
    get { return propertyQueue.sync { _output } }
    set { propertyQueue.sync(flags: .barrier) { _output = newValue } }
  }
  
  init(postingService: PostingServiceProtocol) {
    self.postingService = postingService
  }
  
  override func main() {
    if isCancelled {
      finish()
      return
    }
    
    AppLogger.debug("get post UUID")
    postingService.createPostUUID(callbackQueue: DispatchQueue.global(qos: .utility)) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      guard !strongSelf.isCancelled else {
        strongSelf.finish()
        return
      }
      
      switch $0 {
      case .success(let uuid):
        AppLogger.debug("get post UUID finished: \(uuid)")
        strongSelf.output = Result(value: uuid)
      case .failure(let error):
        AppLogger.error("get post UUID error: \(error.localizedDescription)")
        strongSelf.output = Result(error: .underlyingError(error))
      }
      
      strongSelf.finish()
    }
  }
}
