//
//  AppUsageProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol ApplicationStateCoordinatorDelegateProtocol: class {
  func routeToWelcomeScreen()
  func routeToLoginScreen()
  func routeToSignUpScreen() 
  func routeToMainScreen()
  func routeToOnboardingScreen()
  
}

protocol ApplicationStateCoordinatorServiceProtocol: class {
  var shouldShowWelcome: Bool { get }
  var delegate: ApplicationStateCoordinatorDelegateProtocol? { get set }
  func handleApplicationDidFinishLaunching()
  func subscribeToApplicatonStates()
  func unsubscribeToApplicatonStates()
}
