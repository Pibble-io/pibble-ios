//
//  PibbleErrors.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 14.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation


enum ErrorStrings: String, LocalizedStringKeyProtocol {
  case errorAlertTitle = "Oh Snap!"
  
  enum PibbleError: String, LocalizedStringKeyProtocol {
    case methodNotImplemented =  "Method not implemented"
    
    case parsingError = "Unexpected server response format"
    
    case objectDeallocated = "Object deallocated"
    case notAllowedError = "Not Allowed Error"
    
    case wrondVericationCode = "Wrond verication code"
    case resendCodeTimeInterval = "Time interval has not passed"
    case mapKitSearchError = "Could not find location: %"
    case googlePlaceSearchError = "Could not find location for: %"
    case notAuthorizedError = "Not Authorized Error"
    case internalServerError = "Internal Server Error"
    
    case missingAttribute = "Missing attribute: '%'"
    
    case socketEventParsingError = "Unexpected socket message format: %"
    case chatRoomsGroupForPostNotFound = "Chat rooms group not found"
  }
}


protocol PibbleErrorProtocol: LocalizedError {
  var description: String { get }
}

extension PibbleErrorProtocol  {
  var errorDescription: String? {
    return description
  }
}

enum PibbleError: PibbleErrorProtocol {
  case underlying(Error)
  
  case methodNotImplemented
  
  case requestError(Error)
  
  case fileProcessingError(Error)
  
  case notAuthorizedError
  
  case internalServerError
  
  case unprocessableEntityError(String)
  
  case serverErrorWithMessage(String)
  
  case parsingError
  
  case socketEventParsingError(Error)
  
  case decodableMapping(Error)
  
  case objectDeallocated
  
  case wrondVericationCode
  
  case resendCodeTimeInterval
  
  case mapKitSearchError(Error)
  
  case googlePlaceSearchError(Error?)
  
  case missingAttribute(String)
  
  case chatRoomsGroupForPostNotFound
  
  case notAllowedError
  
  var description: String {
    switch self {
    case .methodNotImplemented:
      return ErrorStrings.PibbleError.methodNotImplemented.localize()
    case .requestError(let err):
      return err.localizedDescription
    case .serverErrorWithMessage(let msg):
      return msg
    case .parsingError:
      return ErrorStrings.PibbleError.parsingError.localize()
    case .decodableMapping(let err):
      return err.localizedDescription
    case .objectDeallocated:
      return ErrorStrings.PibbleError.objectDeallocated.localize()
    case .underlying(let err):
      return err.localizedDescription
    case .wrondVericationCode:
      return ErrorStrings.PibbleError.wrondVericationCode.localize()
    case .resendCodeTimeInterval:
      return ErrorStrings.PibbleError.resendCodeTimeInterval.localize()
    case .mapKitSearchError(let err):
      return ErrorStrings.PibbleError.mapKitSearchError.localize(value: "\(err.localizedDescription)")
    case .googlePlaceSearchError(let err):
      let error = err?.localizedDescription ?? ""
      return ErrorStrings.PibbleError.googlePlaceSearchError.localize(value: error)
    case .notAuthorizedError:
      return ErrorStrings.PibbleError.notAuthorizedError.localize()
    case .internalServerError:
      return ErrorStrings.PibbleError.internalServerError.localize()
    case .unprocessableEntityError(let errorMessage):
      return errorMessage
    case .missingAttribute(let attributeName):
      return ErrorStrings.PibbleError.missingAttribute.localize(value: attributeName)
    case .fileProcessingError(let err):
      return err.localizedDescription
    case .socketEventParsingError(let err):
      return ErrorStrings.PibbleError.socketEventParsingError.localize(value: err.localizedDescription)
    case .chatRoomsGroupForPostNotFound:
      return ErrorStrings.PibbleError.chatRoomsGroupForPostNotFound.localize()
    case .notAllowedError:
      return ErrorStrings.PibbleError.notAllowedError.localize()
    }
  }
}
