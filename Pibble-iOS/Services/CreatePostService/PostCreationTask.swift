//
//  PostCreationTask.swift
//  Pibble
//
//  Created by Sergey Kazakov on 30/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol PostCreationTaskDelegate: class {
  func taskStateChanged(_ task: PostCreationTask)
  func createPostHandler(_ task: PostCreationTask, post: PartialPostingProtocol)
}

enum PostCreationTaskState {
  case initial
  case gettingPostUUID
  case gettingMediaUUIDs
  case postAndMediaUUIDObtaned
  case processingAndUploading
  case cancelled
  case processingAndUploadingComplete
  case failed(Error)
  
  var postCreationStatus: PostCreationStatus {
    switch self {
    case .initial:
      return .preparing
    case .gettingPostUUID:
      return .preparing
    case .gettingMediaUUIDs:
      return .preparing
    case .postAndMediaUUIDObtaned:
      return .preparing
    case .processingAndUploading:
      return .uploading
    case .cancelled:
      return .cancelled
    case .processingAndUploadingComplete:
      return .completed
    case .failed(_):
      return .failed
    }
  }
  
  var progress: Float {
    switch self {
    case .initial:
      return 0.0
    case .gettingPostUUID:
      return 0.7
    case .gettingMediaUUIDs:
      return 0.7
    case .postAndMediaUUIDObtaned:
      return 0.7
    case .processingAndUploading:
      return 0.7
    case .cancelled:
      return 1.0
    case .processingAndUploadingComplete:
      return 1.0
    case .failed(_):
      return 1.0
    }
  }
}

class PostCreationTask {
  fileprivate let mediaProcessingSchedulerService: MediaProcessingSchedulerServiceProtocol
  fileprivate let postingService: PostingServiceProtocol
  
  fileprivate let mediaLibraryExportService: MediaLibraryExportServiceProtocol
  fileprivate let mediaUploadService: MediaUploadServiceProtocol
  
  weak var delegate: PostCreationTaskDelegate?
  
  let identifier: String
  let postDraft: MutablePostDraftProtocol
  
  fileprivate(set) var finishPreprocessingOperation: Operation?
  fileprivate var postCreationUtilsOperations: [(OperationTypes, op: Operation)] = []
  fileprivate var mediaProcessingOperations: [(OperationTypes, op: Operation)] = []
  
  fileprivate var completeBlockOperation: (OperationTypes, Operation)?
  
  var progress: Float {
    return state.progress
  }
  
  fileprivate(set) var state: PostCreationTaskState {
    get {
      return _state
    }
    
    set {
      if case PostCreationTaskState.failed = _state {
        return
      }
      
      if case PostCreationTaskState.cancelled = _state {
        return
      }
      
      _state = newValue
    }
  }
  
  fileprivate var _state: PostCreationTaskState  = .initial {
    didSet {
      AppLogger.debug(_state)
      postDraft.progress = progress
      postDraft.creationTaskState = _state
      delegate?.taskStateChanged(self)
    }
  }
  
  init(draft: MutablePostDraftProtocol,
       mediaProcessingSchedulerService: MediaProcessingSchedulerServiceProtocol,
       postService: PostingServiceProtocol,
       mediaLibraryExportService: MediaLibraryExportServiceProtocol,
       mediaUploadService: MediaUploadServiceProtocol) {
    self.mediaProcessingSchedulerService = mediaProcessingSchedulerService
    self.mediaUploadService = mediaUploadService
    self.mediaLibraryExportService = mediaLibraryExportService
    self.postingService = postService
    self.identifier = draft.postDraftId
    self.postDraft = draft
    createOperationsFor(task: self, draft: draft, errorHandler: self.handleError)
  }
  
  func schedule() {
    self.state = .gettingPostUUID
    mediaProcessingSchedulerService.scheduleOperations(postCreationUtilsOperations)
  }
  
  func handleError(_ error: Error) {
    AppLogger.error(error)
    state = .failed(error)
  }
  
  func cancel() {
    finishPreprocessingOperation?.completionBlock = {}
    postCreationUtilsOperations.forEach {
      $0.op.cancel()
    }
    
    mediaProcessingOperations.forEach {
      $0.op.cancel()
    }
    state = .cancelled
  }
  
  func schedulePostCreationForDraft(_ draft: MutablePostDraftProtocol) {
    guard let operation = finishPreprocessingOperation else {
      return
    }
    
    guard operation.isFinished else {
      operation.completionBlock = { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.createPostingUsingDraft(draft, errorHandler: strongSelf.handleError)
      }
      return
    }
    
    createPostingUsingDraft(draft, errorHandler: handleError)
  }
}

extension PostCreationTask {
  fileprivate func createUUIDPostOperations(draft: MutablePostDraftProtocol, errorHandler: @escaping ErrorHandler) -> (postUUID: PostGetUUIDOperation, mediaUUIDs: [(MediaGetUUIDOperation, MediaType)]) {
    let getPostUUIDOperation: PostGetUUIDOperation = PostGetUUIDOperation(postingService: postingService)
    
    var getMediaUUIDOperations: [MediaGetUUIDOperation] = []
    
    draft.attachedMedia.forEach { _ in
      let getMediaUUIDOperation: MediaGetUUIDOperation = MediaGetUUIDOperation(uploadService: mediaUploadService)
      getMediaUUIDOperation.addDependency(getPostUUIDOperation)
      
      if let last = getMediaUUIDOperations.last {
        getMediaUUIDOperation.addDependency(last)
      }
      
      getMediaUUIDOperations.append(getMediaUUIDOperation)
    }
    
    return(getPostUUIDOperation, Array(zip(getMediaUUIDOperations, draft.attachedMedia)))
  }
  
  fileprivate func scheduleOperations(_ operations: [(OperationTypes, Operation)]) {
    mediaProcessingSchedulerService.scheduleOperations(operations)
  }
  
  fileprivate func createPostingUsingDraft(_ draft: MutablePostDraftProtocol, errorHandler: @escaping ErrorHandler) {
    let service = postingService
    
    service.createPost(postDraft: draft) { [weak self] in
      switch $0 {
      case .success(let post):
        AppLogger.debug("posting success")
        guard let strongSelf = self else {
          return
        }
        strongSelf.delegate?.createPostHandler(strongSelf, post: post)
        guard let promotion = draft.promotionDraft else {
          return
        }
        
        service.createPromotionFor(postId: post.identifier, promotionConfig: promotion, complete: {
          
          switch $0 {
          case .success(_):
            AppLogger.debug("promotion posting success")
          case .failure(let err):
            errorHandler(err)
            AppLogger.error("promotion posting failed \(err.localizedDescription)")
          }
          
        })
        
      case .failure(let err):
        errorHandler(err)
        AppLogger.error("posting failed \(err.localizedDescription)")
      }
    }
  }
  
  fileprivate func createSchedulingMediaProcessingOperationFor(task: PostCreationTask, getPostUUIDOperation: PostGetUUIDOperation, getMediaUUIDOperation: MediaGetUUIDOperation, media: MediaType, errorHandler: @escaping ErrorHandler) -> Operation {
    
    let createMediaProcessingOperation = BlockOperation() { [unowned getPostUUIDOperation, unowned getMediaUUIDOperation, weak self] in
      
      guard let strongSelf = self else {
        return
      }
      
      guard let getPostUUIDOutput = getPostUUIDOperation.output,
        let getMediaUUIDOutput = getMediaUUIDOperation.output,
        case let Result.success(postUUID) = getPostUUIDOutput,
        case let Result.success(mediaUUID) = getMediaUUIDOutput else {
          errorHandler(MediaProcessingPipelineError.couldNotObtainMediaToken)
          return
      }
      
      let mediaProcessingPipelineOperations = strongSelf.operationsToCompletePipeline(media: media, postUUID: postUUID, mediaUUID: mediaUUID, errorHandler: errorHandler)
      
      task.mediaProcessingOperations.append(contentsOf: mediaProcessingPipelineOperations)
      strongSelf.scheduleOperations(mediaProcessingPipelineOperations)
    }
    
    createMediaProcessingOperation.addDependency(getPostUUIDOperation)
    createMediaProcessingOperation.addDependency(getMediaUUIDOperation)
    
    return createMediaProcessingOperation
  }
  
  fileprivate func addMediaProcessingSchedulingCompleteOperation(task: PostCreationTask) -> Operation {
    let completeBlockCreationOperation = BlockOperation() { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      let completeBlockOperation:(OperationTypes, Operation) = (.mainQueueUtils, BlockOperation() {
        AppLogger.debug("task finished")
        task.state = .processingAndUploadingComplete
      })
      
      task.postCreationUtilsOperations.forEach {
        completeBlockOperation.1.addDependency($0.op)
      }
      
      task.mediaProcessingOperations.forEach {
        completeBlockOperation.1.addDependency($0.op)
      }
      
      task.state = .processingAndUploading
      task.completeBlockOperation = completeBlockOperation
      strongSelf.scheduleOperations([completeBlockOperation])
      
      AppLogger.debug("completeBlock created")
    }
    
    return completeBlockCreationOperation
  }
  
  fileprivate func createOperationsFor(task: PostCreationTask, draft: MutablePostDraftProtocol, errorHandler: @escaping ErrorHandler) {
    let uuidOperations = createUUIDPostOperations(draft: draft, errorHandler: errorHandler)
    let getPostUUIDOperation = uuidOperations.postUUID
    var mediaProcessingSchedulingOperations: [Operation] = []
    
    uuidOperations.mediaUUIDs.forEach {
      let op = createSchedulingMediaProcessingOperationFor(task: task,
                                                           getPostUUIDOperation: getPostUUIDOperation,
                                                           getMediaUUIDOperation: $0.0, media: $0.1, errorHandler: errorHandler)
      mediaProcessingSchedulingOperations.append(op)
      //trigger state update
      $0.0.completionBlock = {
        let state = task.state
        task.state = state
      }
    }
    
    let getPostUUIDCompleteOperation = BlockOperation() {
      AppLogger.debug("getPostUUIDCompleteOperation")
      guard let output = uuidOperations.postUUID.output else {
        return
      }
      
      switch output {
      case .success(let postUUID):
        draft.postUUID = postUUID
        task.state = .gettingMediaUUIDs
      case .failure(let error):
        errorHandler(error)
      }
    }
    
    getPostUUIDCompleteOperation.addDependency(getPostUUIDOperation)
    
    uuidOperations.mediaUUIDs.forEach {
      $0.0.addDependency(getPostUUIDCompleteOperation)
    }
    
    let gettingUUIDsCompleteBlockOperation = BlockOperation() {
      task.state = .postAndMediaUUIDObtaned
      draft.media = []
      draft.attachedMedia.forEach {
        var media = $0
        media.shouldUseAsDigitalGood = draft.shouldUseMediaAsDigitalGood
      }
      
      for op in uuidOperations.mediaUUIDs {
        guard let output = op.0.output else {
          continue
        }
        
        switch output {
        case .success(let mediaUUID):
          draft.media.append(mediaUUID)
        case .failure(let error):
          errorHandler(error)
        }
      }
    }
    
    uuidOperations.mediaUUIDs.forEach {
      gettingUUIDsCompleteBlockOperation.addDependency($0.0)
    }
    
    gettingUUIDsCompleteBlockOperation.addDependency(uuidOperations.postUUID)
    
    mediaProcessingSchedulingOperations.forEach {
      $0.addDependency(gettingUUIDsCompleteBlockOperation)
    }
    
    task.finishPreprocessingOperation = gettingUUIDsCompleteBlockOperation
    
    var postCreationUtilsOperations: [Operation] =  []
    
    postCreationUtilsOperations.append(contentsOf: uuidOperations.mediaUUIDs.map { $0.0 })
    postCreationUtilsOperations.append(uuidOperations.postUUID)
    postCreationUtilsOperations.append(getPostUUIDCompleteOperation)
    postCreationUtilsOperations.append(gettingUUIDsCompleteBlockOperation)
    postCreationUtilsOperations.append(contentsOf: mediaProcessingSchedulingOperations)
    
    let mediaProcessingSchedulingCompleteOperation = addMediaProcessingSchedulingCompleteOperation(task: task)
    
    mediaProcessingSchedulingOperations.forEach {
      mediaProcessingSchedulingCompleteOperation.addDependency($0)
    }
    
    postCreationUtilsOperations.append(mediaProcessingSchedulingCompleteOperation)
    
    task.postCreationUtilsOperations = postCreationUtilsOperations.map { (.mainQueueUtils, $0)}
  }
  
  fileprivate func operationsToCompletePipeline(media: MediaType,  postUUID: String, mediaUUID: String, errorHandler: @escaping ErrorHandler) -> [(OperationTypes, Operation)] {
    switch media {
    case .video(let videoAssetURL):
      return operationsToCompleteVideoProcessing(ExportedLibraryAsset(rawVideoURL: videoAssetURL), isOriginalMedia: media.shouldUseAsDigitalGood, postUUID: postUUID, mediaUUID: mediaUUID, errorHandler: errorHandler)
    case .image(let imageAsset):
      return operationsToCompleteForImage(imageAsset, postUUID: postUUID, mediaUUID: mediaUUID, errorHandler: errorHandler)
    case .libraryMediaItem(let libraryAsset):
      return operationsToCompleteForAsset(libraryAsset, postUUID: postUUID, mediaUUID: mediaUUID, errorHandler: errorHandler)
    }
  }
  
  fileprivate func operationsToCompleteForImage(_ image: ImageAsset, postUUID: String, mediaUUID: String, errorHandler: @escaping ErrorHandler) -> [(OperationTypes, Operation)] {
    var operations: [(OperationTypes, Operation)] = []
    
    let exportOperation = PhotoExportOperation(exportService: mediaLibraryExportService)
    exportOperation.input = Result(value: image)
    
    let uploadOperation = MediaUploadOperation<ExportedLibraryAsset>(postUUID: postUUID, mediaUUID: mediaUUID, uploadService: mediaUploadService, isDigitalGood: image.shouldUseAsDigitalGood)
    
    let exportComplete = uploadOperation.addChainOperation(after: exportOperation) {(res) in
      AppLogger.debug("exportComplete")
    }
    
    exportOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    uploadOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    
    operations.append((.mediaExport, exportOperation))
    operations.append((.mainQueueUtils, exportComplete))
    operations.append((.upload, uploadOperation))
    
    let uploadComplete = uploadOperation.addChainingCompleteOperation {(uploadedMedia) in
      AppLogger.debug("uploadComplete")
    }
    
    operations.append((.mainQueueUtils, uploadComplete))
    
    return operations
  }
  
  fileprivate func operationsToCompleteForImageAsset(_ asset: LibraryAsset, postUUID: String, mediaUUID: String, errorHandler: @escaping ErrorHandler) -> [(OperationTypes, Operation)] {
    
    guard asset.underlyingAsset.mediaType == .image else {
      return []
    }
    
    var operations: [(OperationTypes, Operation)] = []
    
    let exportOperation = MediaLibraryExportOperation(exportService: mediaLibraryExportService)
    exportOperation.input = Result(value: asset)
    
    let uploadOperation = MediaUploadOperation<ExportedLibraryAsset>(postUUID: postUUID, mediaUUID: mediaUUID, uploadService: mediaUploadService, isDigitalGood: asset.shouldUseAsDigitalGood)
    
    let exportComplete = uploadOperation.addChainOperation(after: exportOperation) { (res) in
      
    }
    
    let uploadComplete = uploadOperation.addChainingCompleteOperation { (uploadedMedia) in
      
    }
    
    exportOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    uploadOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    
    operations.append((.mediaExport, exportOperation))
    operations.append((.mainQueueUtils, exportComplete))
    operations.append((.upload, uploadOperation))
    operations.append((.mainQueueUtils, uploadComplete))
    
    return operations
  }
  
  fileprivate func operationsToCompleteForVideoAsset(_ asset: LibraryAsset, postUUID: String, mediaUUID: String, errorHandler: @escaping ErrorHandler) -> [(OperationTypes, Operation)] {
    
    guard asset.underlyingAsset.mediaType == .video else {
      return []
    }
    
    var operations: [(OperationTypes, Operation)] = []
    
    let exportOperation = MediaLibraryExportOperation(exportService: mediaLibraryExportService)
    exportOperation.input = Result(value: asset)
    
    let uploadOperation = MediaUploadOperation<URL>(postUUID: postUUID, mediaUUID: mediaUUID, uploadService: mediaUploadService, isDigitalGood: asset.shouldUseAsDigitalGood)
    let videoResizeOperation = VideoResizeOperation<ExportedLibraryAsset>(exportService: mediaLibraryExportService)
    
    let exportComplete = videoResizeOperation.addChainOperation(after: exportOperation) { (res) in
      AppLogger.debug("exportComplete")
    }
    
    let resizeComplete = uploadOperation.addChainOperation(after: videoResizeOperation) { (url) in
      AppLogger.debug("resizeComplete")
    }
    
    let uploadComplete = uploadOperation.addChainingCompleteOperation { (uploadedMedia) in
      AppLogger.debug("uploadComplete")
    }
    
    exportOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    videoResizeOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    uploadOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    
    
    operations.append((.mediaExport, exportOperation))
    operations.append((.mediaProcessing, videoResizeOperation))
    operations.append((.mainQueueUtils, exportComplete))
    operations.append((.mainQueueUtils, resizeComplete))
    operations.append((.upload, uploadOperation))
    operations.append((.mainQueueUtils, uploadComplete))
    
    return operations
  }
  
  fileprivate func operationsToCompleteForAsset(_ asset: LibraryAsset, postUUID: String, mediaUUID: String, errorHandler: @escaping ErrorHandler) -> [(OperationTypes, Operation)] {
    switch asset.underlyingAsset.mediaType {
    case .unknown:
      return []
    case .image:
      return operationsToCompleteForImageAsset(asset, postUUID: postUUID, mediaUUID: mediaUUID, errorHandler: errorHandler)
    case .video:
      return operationsToCompleteForVideoAsset(asset, postUUID: postUUID, mediaUUID: mediaUUID, errorHandler: errorHandler)
    case .audio:
      return []
    }
  }
  
  fileprivate func operationsToCompleteVideoProcessing(_ rawVideoFileURL: ExportedLibraryAsset, isOriginalMedia: Bool, postUUID: String, mediaUUID: String, errorHandler: @escaping ErrorHandler) -> [(OperationTypes, Operation)] {
    var operations: [(OperationTypes, Operation)] = []
    
    let videoResizeOperation = VideoResizeOperation<ExportedLibraryAsset>(exportService: mediaLibraryExportService)
    videoResizeOperation.input = Result(value: rawVideoFileURL)
    
    let uploadOperation = MediaUploadOperation<URL>(postUUID: postUUID, mediaUUID: mediaUUID, uploadService: mediaUploadService, isDigitalGood: isOriginalMedia)
    
    let videoResizeComplete = uploadOperation.addChainOperation(after: videoResizeOperation) { (url) in
      AppLogger.debug("videoResizeComplete")
    }
    
    videoResizeOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    uploadOperation.addErrorHandlerAsCompleteBlock(errorHandler)
    
    operations.append((.mediaProcessing, videoResizeOperation))
    operations.append((.mainQueueUtils, videoResizeComplete))
    operations.append((.upload, uploadOperation))
    
    let uploadComplete = uploadOperation.addChainingCompleteOperation { (uploadedMedia) in
      AppLogger.debug("uploadComplete")
    }
    
    operations.append((.mainQueueUtils, uploadComplete))
    return operations
  }
}
