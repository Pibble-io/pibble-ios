//
//  UserDescriptionPickerInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - UserDescriptionPickerInteractor Class
final class UserDescriptionPickerInteractor: Interactor {
  fileprivate(set) var userDescription = ""
  
  fileprivate var pickedInputs: [UserDescriptionPicker.Inputs: String] = [:]
  let descriptionLimit = 200
  let otherInputsLimitLimit = 100
}

// MARK: - UserDescriptionPickerInteractor API
extension UserDescriptionPickerInteractor: UserDescriptionPickerInteractorApi {
  fileprivate func inputTextFor(_ input: UserDescriptionPicker.Inputs) -> String {
    return pickedInputs[input] ?? ""
  }
  
  var userProfile: UserProfileProtocol {
    let profile = UserDescriptionPicker.UserProfile(userProfileDescription: inputTextFor(.description),
                                                    userProfileFirstName: inputTextFor(.firstName),
                                                    userProfileLastName: inputTextFor(.lastName),
                                                    userProfileSiteName: inputTextFor(.website))
    return profile
  }
  
  func setInputText(_ text: String, forInput: UserDescriptionPicker.Inputs) {
    setInputText(text, forInput: forInput, forcePresent: false)
  }
  
  fileprivate func setInputText(_ text: String, forInput: UserDescriptionPicker.Inputs, forcePresent: Bool) {
    switch forInput {
    case .description:
      let cutText = text.cleanedFromExtraNewLines().cutToLength(descriptionLimit)
      pickedInputs[forInput] = cutText
      if cutText != text || forcePresent {
        presenter.presentText(cutText, forInput: forInput)
      }
      presenter.presentDescriptionText(count: cutText.count, countLimit: descriptionLimit)
    case .firstName:
      let cutText = text.cleanedFromExtraNewLines().cutToLength(otherInputsLimitLimit)
      pickedInputs[forInput] = cutText
      if cutText != text || forcePresent {
        presenter.presentText(cutText, forInput: forInput)
      }
      
    case .lastName:
      let cutText = text.cleanedFromExtraNewLines().cutToLength(otherInputsLimitLimit)
      pickedInputs[forInput] = cutText
      if cutText != text || forcePresent {
        presenter.presentText(cutText, forInput: forInput)
      }
    case .website:
      let cutText = text.cleanedFromExtraNewLines().cutToLength(otherInputsLimitLimit)
      pickedInputs[forInput] = cutText
      if cutText != text || forcePresent {
        presenter.presentText(cutText, forInput: forInput)
      }
    }
  }
  
  func setInitialProfile(_ profile: UserProfileProtocol) {
    setInputText(profile.userProfileDescription, forInput: .description, forcePresent: true)
    setInputText(profile.userProfileFirstName, forInput: .firstName, forcePresent: true)
    setInputText(profile.userProfileLastName, forInput: .lastName, forcePresent: true)
    setInputText(profile.userProfileSiteName, forInput: .website, forcePresent: true)
  }
  
//  func setInitialInputText(_ text: String, forInput: UserDescriptionPicker.Inputs) {
//    setInputText(text, forInput: forInput)
//  }
  
  func validateIntputs() {
    pickedInputs.forEach {
      switch $0.key {
      case .description:
        guard $0.value.count <= descriptionLimit else {
          presenter.handleError(UserDescriptionPicker.ValidationError.lengthLimit($0.key, descriptionLimit))
          return
        }
        
        guard $0.value.count > 0 else {
          presenter.handleError(UserDescriptionPicker.ValidationError.empty($0.key))
          return
        }
      case .firstName:
        guard $0.value.count <= otherInputsLimitLimit else {
          presenter.handleError(UserDescriptionPicker.ValidationError.lengthLimit($0.key, otherInputsLimitLimit))
          return
        }
      case .lastName:
        guard $0.value.count <= otherInputsLimitLimit else {
          presenter.handleError(UserDescriptionPicker.ValidationError.lengthLimit($0.key, otherInputsLimitLimit))
          return
        }
      case .website:
        guard $0.value.count <= otherInputsLimitLimit else {
          presenter.handleError(UserDescriptionPicker.ValidationError.lengthLimit($0.key, otherInputsLimitLimit))
          return
        }
        
        guard $0.value.count == 0 || "http://\($0.value)".isValidUrl else {
          presenter.handleError(UserDescriptionPicker.ValidationError.wrongURL)
          return
        }
      }
    }
    
    presenter.presentValidationSuccess()
  }
  
}

// MARK: - Interactor Viper Components Api
private extension UserDescriptionPickerInteractor {
  var presenter: UserDescriptionPickerPresenterApi {
    return _presenter as! UserDescriptionPickerPresenterApi
  }
}

fileprivate extension String {
  func cutToLength(_ length: Int) -> String {
    guard self.count > length else {
      return self
    }
    
    let indexEndOfText = index(self.startIndex, offsetBy: length)
    return String(self[..<indexEndOfText])
  }
}

