//
//  PromotionUrlDestinationPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PromotionUrlDestinationPick {
  struct ButtonActionViewModel: PromotionUrlDestinationPickButtonActionViewModelProtocol {
    let selectionImage: UIImage
    let isSelected: Bool
    let title: String
    
    init(actionType: PromotionActionTypeProtocol, isSelected: Bool) {
      self.isSelected = isSelected
      title = actionType.actionTitle
      selectionImage = isSelected ?
        UIImage(imageLiteralResourceName: "PromotionDestinaionUrlPick-SelectionImage-selected"):
        UIImage(imageLiteralResourceName: "PromotionDestinaionUrlPick-SelectionImage")
    }
  }
}

