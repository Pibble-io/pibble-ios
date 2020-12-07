//
//  UserInterface+ErrorHandling.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol ErrorHandlerProtocol: class {
  func handledError(_ error: Error) -> Bool
}

extension BaseViewController: ErrorHandlerProtocol {
  static var errorHandlerAlertTitle = "Error"
  
  func handleErrorSilently(_ error: Error) -> Bool {
    AppLogger.error(error.localizedDescription)
    return true
  }
  
  func handledError(_ error: Error) -> Bool {
    if let globalErrorHandler = BaseViewController.globalErrorHandler,
      globalErrorHandler.handledError(error) {
      return true
    }
    
    if let instanceErrorHandler = errorHandler,
      instanceErrorHandler.handledError(error) {
      return true
    }
    
    presentAlertWithError(error)
    return true
  }
  
  @objc func shouldPresentAlertFor(_ error: Error) -> Bool {
    return true
//    guard let pibbleError = error as? PibbleError else {
//      return true
//    }
//    
//    switch pibbleError {
//    case .underlying(_):
//      return true
//    case .methodNotImplemented:
//      return false
//    case .requestError(_):
//      return false
//    case .fileProcessingError(_):
//      return true
//    case .notAuthorizedError:
//      return false
//    case .internalServerError:
//      return false
//    case .unprocessableEntityError(_):
//      return true
//    case .serverErrorWithMessage(_):
//      return true
//    case .parsingError:
//      return true
//    case .socketEventParsingError(_):
//      return true
//    case .decodableMapping(_):
//      return false
//    case .objectDeallocated:
//      return false
//    case .wrondVericationCode:
//       return true
//    case .mapKitSearchError(_):
//       return true
//    case .googlePlaceSearchError(_):
//       return true
//    case .missingAttribute(_):
//      return true
//    }
    
  }
  
  fileprivate func presentAlertWithError(_ error: Error) {
    guard shouldPresentAlertFor(error) else {
      return
    }
    
    let alert = UIAlertController(title: BaseViewController.errorHandlerAlertTitle, message: error.localizedDescription, safelyPreferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Ok", style: .cancel)
    alert.addAction(confirmAction)
    
    present(alert, animated: true)
  }
}
