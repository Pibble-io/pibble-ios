//
//  DescriptionPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - DescriptionPickInteractor Class
final class DescriptionPickInteractor: Interactor {
  fileprivate let attribute = DescriptionPick.DraftPostingAttributes()
}

// MARK: - DescriptionPickInteractor API
extension DescriptionPickInteractor: DescriptionPickInteractorApi {
  func setInitialAttributes(_ description: PostAttributesProtocol) {
    attribute.postCaption = description.postCaption
    presenter.presentCurrentText(attribute.postCaption )
  }
  
  var postingAttributes: PostAttributesProtocol {
    return attribute
  }

  func setAttributesText(_ text: String) {
    attribute.postCaption = text.cleanedFromExtraNewLines()
  }
}

// MARK: - Interactor Viper Components Api
private extension DescriptionPickInteractor {
    var presenter: DescriptionPickPresenterApi {
        return _presenter as! DescriptionPickPresenterApi
    }
}
