//
//  MediaProcessingPipelineError.swift
//  Pibble
//
//  Created by Kazakov Sergey on 18.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum MediaProcessingPipelineError: PibbleErrorProtocol {
  case uploadError(PibbleErrorProtocol)
  case mediaLibraryExportError(Error)
  case photoExportError(Error)
  case photoSaveError
  case videoExportSessionError
  case assetTypeError
  case noAssetResourceError
  case unSupportedAssetTypeError
  
  case photoResizeError
  case operationInputNotFound
  case underlyingError(PibbleErrorProtocol)
  case videoResizeError
  case couldNotObtainMediaToken
  
  var description: String {
    switch self {
    case .uploadError(let err):
      return err.description
    case .underlyingError(let err):
      return err.description
    case .operationInputNotFound:
      return ErrorStrings.MediaProcessingPipelineError.operationInputNotFound.localize()
    case .mediaLibraryExportError(let err):
      return ErrorStrings.MediaProcessingPipelineError.mediaLibraryExportError.localize(value: err.localizedDescription)
    case .photoExportError(let err):
      return ErrorStrings.MediaProcessingPipelineError.photoExportError.localize(value: err.localizedDescription)
    case .photoResizeError:
      return ErrorStrings.MediaProcessingPipelineError.photoResizeError.localize()
    case .videoExportSessionError:
      return ErrorStrings.MediaProcessingPipelineError.videoExportSessionError.localize()
    case .assetTypeError:
      return ErrorStrings.MediaProcessingPipelineError.assetTypeError.localize()
    case .noAssetResourceError:
      return ErrorStrings.MediaProcessingPipelineError.noAssetResourceError.localize()
    case .unSupportedAssetTypeError:
      return ErrorStrings.MediaProcessingPipelineError.unSupportedAssetTypeError.localize()
    case .videoResizeError:
      return ErrorStrings.MediaProcessingPipelineError.videoResizeError.localize()
    case .couldNotObtainMediaToken:
      return ErrorStrings.MediaProcessingPipelineError.couldNotObtainMediaToken.localize()
    case .photoSaveError:
      return ErrorStrings.MediaProcessingPipelineError.photoSaveError.localize()
    }
  }
}

extension ErrorStrings {
  enum MediaProcessingPipelineError: String, LocalizedStringKeyProtocol {
    case operationInputNotFound = "Operation input not found"
    case mediaLibraryExportError = "Media library export error: %"
    case photoExportError = "Image export error: %"
    case photoResizeError = "Image resize error"
    case videoExportSessionError = "Video export session error"
    case assetTypeError = "Wrong asset type"
    case noAssetResourceError = "No asset resource found"
    case unSupportedAssetTypeError = "Asset type is not supported"
    case videoResizeError = "Video resize error"
    case couldNotObtainMediaToken = "Could not obtain uuid"
    case photoSaveError = "Could not save image"
  }
}
