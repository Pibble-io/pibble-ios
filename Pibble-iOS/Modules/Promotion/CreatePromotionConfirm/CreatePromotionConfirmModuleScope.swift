//
//  CreatePromotionConfirmModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum CreatePromotionConfirm {
  enum PromotionDraftDestination {
    case profile(UserProtocol, PromotionActionTypeProtocol)
    case url(URL, PromotionActionTypeProtocol)
  }
  
  struct PromotionDraftModel {
    let destination: PromotionDraftDestination
    let totalBudget: BalanceProtocol
    let duration: Int
  }
  
  enum CreatePromotionConfirmError: Error, PibbleErrorProtocol {
    case destinationMissing
    case budgetMissing
    case durationMissing
    
    var description: String {
      switch self {
      case .destinationMissing:
        return CreatePromotionConfirm.Strings.Errors.destinationMissing.localize()
      case .budgetMissing:
        return CreatePromotionConfirm.Strings.Errors.budgetMissing.localize()
      case .durationMissing:
        return CreatePromotionConfirm.Strings.Errors.durationMissing.localize()
      }
    }
  }
  
  struct DraftViewModel: CreatePromotionConfirmDraftViewModelProtocol {
    let destination: String
    let action: String
    let budget: String
    
    init(draft: PromotionDraftModel) {
      let budgetValue = String(format: "%.0f", draft.totalBudget.value)
      
      let durationString = "\(draft.duration) \(CreatePromotionConfirm.Strings.days.localize())"
      let budgetString = "\(budgetValue) \(draft.totalBudget.currency.symbol)"
      budget = "\(budgetString) / \(durationString)"
      
      switch draft.destination {
      case .profile(let user, let action):
        destination = "@\(user.userName)"
        self.action = action.actionTitle
      case .url(let url, let action):
        destination = url.absoluteString
        self.action = action.actionTitle
      }
    }
  }
}

extension CreatePromotionConfirm {
  enum Strings: String, LocalizedStringKeyProtocol {
    enum Errors: String, LocalizedStringKeyProtocol {
      case destinationMissing = "Destination is not set"
      case budgetMissing = "Budget is not set"
      case durationMissing = "Duration is not set"
    }
    
    case days = "Days"
    
    case headerSubtitle = "Your post will reach estimated % - % people. Once your promotion starts, you can pause spending anytime."
    
    enum Alerts: String, LocalizedStringKeyProtocol {
      case ok = "Ok"
      case cancel = "Cancel"
      
      enum PromotionConfirm: String, LocalizedStringKeyProtocol {
        case title = "Would you like to  checkout % to start your promotion now?"
        case message = "% of your budget is allocated to the system right now so you can increase your impression immediately. % of your budget will be rewarded for users who have engaged in your post during the promotion period."
      }
      
      enum PromotionCreationSuccess: String, LocalizedStringKeyProtocol  {
        case title = "Thank you"
        case message = "Your payment was successful."
      }
    }
  }
}
