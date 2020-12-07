//
//  LoginServiceProtocol.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 14.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol SignInUserProtocol {
  var login: String { get }
  var password: String { get }
}

protocol SignUpUserProtocol: class {
  var email: String { get }
  var username: String { get }
  var password: String { get }
}

protocol SignUpCountryProtocol: SignUpCountryViewModelProtocol {
  var id: Int { get }
  var phoneCode: String { get }
  var title: String { get }
  var isoCode: String { get }
  var iso3Code: String { get }
}

protocol UserPhoneNumberProtocol {
  var countryId: Int { get }
  var phone: String { get }
}

protocol ResetPasswordEmailProtocol {
  var email: String { get }
}

protocol ChangePasswordProtocol {
  var code: String { get }
  var password: String { get }
}

protocol AuthorizedUserProtocol: Decodable {
  var username: String { get }
  var token: String { get }
}

protocol NotVerifiedAccountProtocol: Decodable {
  var email: String { get }
  var username: String { get }
}


protocol VerifiedCodeProtocol {
  var token: String { get }
}

protocol AuthServiceProtocol: class {
  var presentedOnboarding: Bool { get set }
  var isLoggedIn: Bool { get }
  func signIn(user: SignInUserProtocol, complete: @escaping ResultCompleteHandler<SignInAccount, PibbleError>)
  func signUp(user: SignUpUserProtocol, complete: @escaping ResultCompleteHandler<SignUpAccount, PibbleError>)
  
  func sendVerificationSMSTo(_ phoneNumber: UserPhoneNumberProtocol, complete: @escaping CompleteHandler)
  func sendVerificationEmailTo(_ email: String, complete: @escaping CompleteHandler)
  
  func checkCodeForPhoneNumber(code: String, complete: @escaping CompleteHandler)
  func checkCodeForEmail(code: String, complete: @escaping CompleteHandler)
  
  func confirmAccountCreation(_ complete: @escaping CompleteHandler)
  
  func fetchSignUpCountries(_ complete: @escaping ResultCompleteHandler<[SignUpCountryProtocol], PibbleError>)
  
  func sendResetPasswordTo(_ email: ResetPasswordEmailProtocol, complete: @escaping CompleteHandler)
  func sendResetPasswordTo(_ phoneNumber: UserPhoneNumberProtocol, complete: @escaping CompleteHandler)
  
  var canResendSMSVerificationAfter: Date { get }
  
  var canResendEmailVerificationAfter: Date { get }
  
  var canResendSMSPinCodeResetAfter: Date { get }
  
  var canResendEmailPinCodeResetAfter: Date { get }
  
  func applyTempBanForPinCodeReset()
  func sendResetPinCodeTo(_ email: ResetPasswordEmailProtocol, complete: @escaping CompleteHandler)
  func sendResetPinCodeTo(_ phoneNumber: UserPhoneNumberProtocol, complete: @escaping CompleteHandler)
  
  func resetPasswordCheckSMSCode(code: String, complete: @escaping ResultCompleteHandler<VerifiedCodeProtocol, PibbleError>)
  func resetPasswordCheckEmailCode(code: String, complete: @escaping ResultCompleteHandler<VerifiedCodeProtocol, PibbleError>)
  
  func changePassword(_ password: ChangePasswordProtocol, complete: @escaping CompleteHandler)
  func refreshToken(complete: @escaping CompleteHandler)
  
  func logout()
}
