//
//  MoyaResponseExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Moya

extension Response {
  func filterNoUnauthorizedError() -> Bool {
    return statusCode != 401
  }
  
  func filterInternalServerError() -> Bool {
    return statusCode != 500
  }
  
  func filterNotAllowedError() -> Bool {
    return statusCode != 405
  }
  
  func filterUnprocessableEntity() -> Bool {
    return statusCode != 422
  }
  
  func parseResponse<T: Decodable>(decoder: JSONDecoder, type: T.Type) -> T? {
    do {
      let _ = try decoder.decode(type, from: data)
    } catch {
      AppLogger.error(error)
    }
    
    return try? decoder.decode(type, from: data)
  }
  
  func handleResponseFor<T: Decodable>(target: CoderConfigProtocol.Type, type: T.Type) -> Result<T, PibbleError> {
    return handleResponse(decoder: target.responseDecoder)
  }
  
  func handleResponse<T: Decodable>(decoder: JSONDecoder) -> Result<T, PibbleError> {
    if let error = handleResponse() {
      return Result(error: error)
    }
    
    guard let result = parseResponse(decoder: decoder, type: T.self) else {
      return Result(error: .parsingError)
    }
    
    return Result(value: result)
  }
  
  func handleResponse() -> PibbleError? {
    guard filterNoUnauthorizedError() else {
      return .notAuthorizedError
    }
    
    guard filterInternalServerError() else {
      return .internalServerError
    }
    
    guard filterNotAllowedError() else {
      return .notAllowedError
    }
    
    guard filterUnprocessableEntity() else {
      let messageEntity = try? map(PibbleBackend.Responses.ErrorMessages.self)
      let message = try? mapString(atKeyPath: PibbleBackend.Responses.Error.messageKey)
      let responseString = try? mapString()
      let messageEntityMessages = messageEntity?.messages.map { $0.message }.joined(separator: ". ")
      
      let errorMessage = messageEntityMessages ?? message ?? responseString ?? PibbleBackend.Responses.Error.defaultServerError
      return .unprocessableEntityError(errorMessage)
    }
    
    guard let _ = try? filterSuccessfulStatusCodes() else {
      let message = try? mapString(atKeyPath: PibbleBackend.Responses.Error.messageKey)
      let responseString = try? mapString()
      return .serverErrorWithMessage(message ?? responseString ?? PibbleBackend.Responses.Error.defaultServerError)
    }
    
    return nil
  }
}
