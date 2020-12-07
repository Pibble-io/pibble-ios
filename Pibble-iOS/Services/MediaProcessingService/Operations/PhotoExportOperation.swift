//
//  PhotoExportOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PhotoExportOperation: Operation, ChainingOperationProtocol {
  fileprivate let exportService: MediaLibraryExportServiceProtocol
  
  var input: Result<ImageAsset, MediaProcessingPipelineError>?
  var output: Result<ExportedLibraryAsset, MediaProcessingPipelineError>?
  
  init(exportService: MediaLibraryExportServiceProtocol) {
    self.exportService = exportService
  }
  
  override func main() {
    if isCancelled {
      return
    }
    
    guard let input = input else {
      output = Result(error: .operationInputNotFound)
      return
    }
    
    let image: ImageAsset?
    
    switch input {
    case .success(let inputImage):
      image = inputImage
    case .failure(let err):
      image = nil
      output = Result(error: .underlyingError(err))
    }
    
    guard let inputImage = image else {
      return
    }
    
    let name = UUID().uuidString
    let originalImageName = "\(name)_original"
    
    if isCancelled {
      return
    }
    
    guard let resizedImage = exportService.resizeImageWithCurrentExportSettings(image: inputImage.underlyingAsset, cropPerCent: UIEdgeInsets.zero) else {
      output = Result(error: .photoResizeError)
      return
    }

    guard let url = exportService.saveAsJPGWithCurrentExportSettings(image: resizedImage, name: name) else {
      output = Result(error: .photoSaveError)
      return
    }
    
    guard inputImage.shouldUseAsDigitalGood else {
      output = Result(value: .photo(url, original: nil))
      return
    }
    
    guard let originalImageUrl = exportService.saveAsJPGWithoutComression(image: inputImage.underlyingAsset, name: originalImageName) else {
      output = Result(error: .photoSaveError)
      return
    }
    
    output = Result(value: .photo(url, original: originalImageUrl))
  }
}
