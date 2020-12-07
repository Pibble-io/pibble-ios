//
//  AppDelegateSetupExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 16.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import DeviceKit
import Fabric
import Crashlytics
import Firebase
import Localize

extension UIDevice {
  static let userAgent: String = {
    let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    let deviceName = UIDevice.current.name
    
    let device = Device()
    let userAgentString = "\(displayName)/\(deviceName)/\(device)"
    let trimmedUserAgentString = userAgentString.components(separatedBy: .whitespacesAndNewlines).joined(separator: "_")
    return trimmedUserAgentString
  }()
}

extension AppDelegate {
  func didFinishLaunchingAnalyticsSetup() {
    Fabric.with([Crashlytics.self])
  }
  
  func didFinishLaunchingAppearanceSetup() {
    window?.tintColor = UIColor.gray191
    window?.backgroundColor = UIColor.bluePibble
    
    
    let localize = Localize.shared
    // Set your localize provider.
    localize.update(provider: .strings)
    // Set your file name
    localize.update(fileName: "Localizable")
    
    localize.update(language: servicesContainer.appSettingsService.appLanguage.languageCode)
    
    AssetsManager.LocalizedAssets.appLanguage = servicesContainer.appSettingsService.appLanguage
    
    #if DEVELOPMENT
    LocalizedStringsHelper().checkAllStrings()
    #endif
  }
  
  func didFinishLaunchingApplicationStateSetup(_ application: UIApplication) {
    ViewController.globalErrorHandler = self
    ViewController.errorHandlerAlertTitle = ErrorStrings.errorAlertTitle.localize()
    
    servicesContainer.applicationStateCoordinatorService.delegate = self
    servicesContainer.applicationStateCoordinatorService.handleApplicationDidFinishLaunching()
    servicesContainer.applicationStateCoordinatorService.subscribeToApplicatonStates()
  }
}

extension AppDelegate: ApplicationStateCoordinatorDelegateProtocol {
  func routeToSignUpScreen() {
    servicesContainer.loginService.logout()
    AppModules
      .Auth
      .registration
      .build()?
      .router.show(inWindow: window, embedInNavController: true, animated: true)
  }
  
  func routeToMainScreen() {
    AppModules
      .Main
      .tabBar
      .build()?
      .router.show(inWindow: window, embedInNavController: true, animated: false)
  }
  
  func routeToOnboardingScreen() {
    AppModules
      .Auth
      .onboarding
      .build()?
      .router.show(inWindow: window, embedInNavController: true, animated: false)
    
  }
  
  func routeToLoginScreen() {
    servicesContainer.loginService.logout()
    AppModules
      .Auth
      .signIn
      .build()?
      .router.show(inWindow: window, embedInNavController: true, animated: true)
  }
  
  func routeToWelcomeScreen() {
    let module = AppModules.Auth.welcomeScreen.build()
    module?.router.show(inWindow: window, embedInNavController: true, animated: true)
  }
}

extension AppDelegate: ErrorHandlerProtocol {
  func handledError(_ error: Error) -> Bool {
    guard let pibbleError = error as? PibbleError else {
      return false
    }
    
    guard case PibbleError.notAuthorizedError = pibbleError else {
      return false
    }
    
    return true
  }
}


