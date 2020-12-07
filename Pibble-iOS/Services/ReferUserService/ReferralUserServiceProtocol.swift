//
//  ReferralUserServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 18/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol ReferralUserServiceProtocol {
  var referralBonus: ReferralBonus { get }
  
  func registerUnderRefferal(referralId: String, complete: @escaping CompleteHandler)
  func getRegisteredReferralUsers(page: Int, perPage: Int, complete: @escaping
    ResultCompleteHandler<([PartialUserProtocol], PaginationInfoProtocol), PibbleError>)
  func getReferralUserId(complete: @escaping ResultCompleteHandler<String?, PibbleError>) 
}
