//
//  ReferUserModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ReferUser {
  struct ReferredUserViewModel: ReferredUserViewModelProtocol {
    let userpicUrlString: String
    let usrepicPlaceholder: UIImage?
    let username: String
    
    init(user: UserProtocol) {
      userpicUrlString = user.userpicUrlString
      usrepicPlaceholder = UIImage.avatarImageForNameString(user.userName)
      username = user.userName
    }
  }
  
  struct ReferralInfoViewModel: ReferralInfoViewModelProtocol {
    let headerTitle: String
    let headerSubtitle: String
    let inviteAmount: String
    let inviteReferralId: String
    
    init(referralBonus: ReferralBonus, currentUser: AccountProfileProtocol) {
      let inviteValue = String(format: "%.0f", referralBonus.inviteReferralBonus.value)
      let inviteString = "\(inviteValue) \(referralBonus.inviteReferralBonus.currency.symbol)"
      headerTitle = Strings.headerTitle.localize(value: inviteString)
      
      let limitValue = String(format: "%.0f", referralBonus.inviteRewardsLimit.value)
      let limitCurrency = referralBonus.inviteRewardsLimit.currency.symbol
      let limitString = "\(limitValue) \(limitCurrency)"
      headerSubtitle = Strings.headerSubtitle.localize(values: inviteString, limitString)
      
      inviteAmount = inviteString
      inviteReferralId = currentUser.referralCode
    }
  }
}


extension ReferUser {
  enum Strings: String, LocalizedStringKeyProtocol {
    case headerTitle = "Invite Friends and get %"
    case headerSubtitle = "For each friends that joins Pibble, we'll give you %. Earn up to a total of % in rewards."
    
    case shareTitle = "This app is amazing. \n Get it at https://www.pibbleapp.io \n Invite ID : %"
    
    case referralRegistrationSuccess = "Thank you for your registration. You earned % and your friend earned %"
    
    case okAlertAction = "Ok"
  }
}
