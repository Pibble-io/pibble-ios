//
//  ChainingOperationProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol ChainableOperationProtocol: class {
  associatedtype OutputType
  
  var output: Result<OutputType, MediaProcessingPipelineError>? { get }
}

extension ChainableOperationProtocol where Self: Operation {
  func addErrorHandlerAsCompleteBlock(_ handler: @escaping ErrorHandler) {
    completionBlock = { [weak self] in
      
      guard let strongSelf = self else {
        return
      }
      
      guard let operationOutput = strongSelf.output else {
        return
      }
      
      switch operationOutput {
      case .success:
        break
      case .failure(let error):
        handler(error)
      }
    }
  }
}

protocol ChainingOperationProtocol: ChainableOperationProtocol {
  associatedtype InputType
  associatedtype OutputType
  
  var input: Result<InputType, MediaProcessingPipelineError>? { get set }
  var output: Result<OutputType, MediaProcessingPipelineError>? { get }
}

extension ChainingOperationProtocol where Self: Operation {
  func addChainingCompleteOperation(complete: @escaping (OutputType) -> Void) -> Operation {
    let uploadComplete = BlockOperation { [unowned self] in
      let strongSelf = self
      guard let outputValue = strongSelf.output else {
        return
      }
      
      guard case let Result.success(uploadedMedia) = outputValue else {
        return
      }
      complete(uploadedMedia)
    }
    
    uploadComplete.addDependency(self)
    return uploadComplete
  }
  
  func addChainOperation<T>(after operation: T, complete: @escaping (InputType) -> Void) -> Operation
    where
    T: ChainableOperationProtocol,
    T: Operation,
    Self.InputType == T.OutputType {
      
      let chainingOperation = BlockOperation { [unowned self, unowned operation] in
        let strongSelf = self
        
        guard let outputValue = operation.output else {
          return
        }
        
        strongSelf.input = outputValue
        
        guard case let Result.success(value) = outputValue else {
          return
        }
        
        complete(value)
      }
      
      addDependency(chainingOperation)
      chainingOperation.addDependency(operation)
      
      return chainingOperation
  }
  
  func addCombiningOperation<Op1, Op2>(after operations: (Op1, Op2), complete: @escaping (InputType) -> Void) -> Operation
    where
    Op1: ChainableOperationProtocol & Operation,
    Op2: ChainableOperationProtocol & Operation,
    InputType == (Op1.OutputType, Op2.OutputType) {
      
      let combiningOperation = BlockOperation { [unowned self] in
        let strongSelf = self
        
        switch (operations.0.output, operations.1.output) {
        case let (.some(res1), .some(res2)):
          let output1: Op1.OutputType
          let output2: Op2.OutputType
          
          switch res1 {
          case .success(let out1):
            output1 = out1
          case .failure(let error):
            strongSelf.input = Result(error: error)
            return
          }
          
          switch res2 {
          case .success(let out2):
            output2 = out2
          case .failure(let error):
            strongSelf.input = Result(error: error)
            return
          }
 
          strongSelf.input = Result<InputType, MediaProcessingPipelineError>(value: (output1, output2))
          complete((output1, output2))
        default:
          break
        }
      }
      
      addDependency(combiningOperation)
      combiningOperation.addDependency(operations.0)
      combiningOperation.addDependency(operations.1)
      
      return combiningOperation
  }
}

