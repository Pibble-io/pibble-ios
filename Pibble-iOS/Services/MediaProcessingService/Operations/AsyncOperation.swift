//
//  AsyncOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 17.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
  
  /// State for this operation.
  
  @objc fileprivate enum OperationState: Int {
    case ready
    case executing
    case finished
  }
  
  /// Concurrent queue for synchronizing access to `state`.
  
  fileprivate let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)
  
  /// Private backing stored property for `state`.
  
  fileprivate var _state: OperationState = .ready
  
  /// Threadsafe state of the operation
  
  @objc fileprivate dynamic var state: OperationState {
    get { return stateQueue.sync { _state } }
    set { stateQueue.sync(flags: .barrier) { _state = newValue } }
  }
  
  // MARK: - Various `Operation` properties
  
  override var isReady: Bool {
    return state == .ready && super.isReady
  }
  
  final override var isExecuting: Bool {
    return state == .executing
  }
  
  final override var isFinished: Bool {
    return state == .finished
  }
 
  override var isAsynchronous: Bool {
    return true
  }
  
  // KVN for dependent properties
  
  override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
    if ["isReady", "isFinished", "isExecuting"].contains(key) {
      return [#keyPath(state)]
    }
    
    return super.keyPathsForValuesAffectingValue(forKey: key)
  }
  
  // Start
  
  final override func start() {
    if isCancelled {
      finish()
      return
    }
    
    state = .executing
    main()
  }
  
  /// Subclasses must implement this to perform their work and they must not call `super`. The default implementation of this function throws an exception.
  
  override func main() {
    fatalError("Subclasses must implement `main`.")
  }
  
  /// Call this function to finish an operation that is currently executing
  
  final func finish() {
    state = .finished 
  }
}
