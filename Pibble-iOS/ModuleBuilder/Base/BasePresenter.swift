//
//  Presenter.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol PresenterProtocol: class {
  var _interactor: InteractorProtocol! { get set }
  var _viewController: BaseViewController! { get set }
  var _router: RouterProtocol! { get set }

  func viewDidLoad()
  func viewWillAppear()
  func viewDidAppear()
  func viewWillDisappear()
  func viewDidDisappear()
  
  func didBecomeActive()
  
  func willBecomeActive()
  
  func presentInitialState()
  func handleError(_ error: Error)
  func handleErrorSilently(_ error: Error)
}

class BasePresenter: PresenterProtocol {
  var _interactor: InteractorProtocol!
  weak var _viewController: BaseViewController!
  var _router: RouterProtocol!
  
  fileprivate(set) var isPresented: Bool = false
  
  
  
  func viewDidLoad() {
    
  }
  
  func viewWillAppear() {
    
  }
  
  func didBecomeActive() {
   
  }
  
  func willBecomeActive() {
    
  }
  
  func willResignActive() {
    
  }
  
  func viewDidAppear() {
    isPresented = true
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationWillBecomeActive),
      name: UIApplication.didBecomeActiveNotification,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationDidBecomeActive),
      name: NSNotification.Name.applicationDidBecomeActiveCustomNotification,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationWillResignActive),
      name: UIApplication.willResignActiveNotification,
      object: nil)
  }
  
  @objc fileprivate func applicationWillResignActive() {
    willResignActive()
  }
  
  @objc fileprivate func applicationWillBecomeActive() {
    willBecomeActive()
  }
  
  @objc fileprivate func applicationDidBecomeActive() {
    didBecomeActive()
  }
  
  func viewWillDisappear() {
    isPresented = false
    
    NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.applicationDidBecomeActiveCustomNotification, object: nil)
    
    NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
  }
  
  func viewDidDisappear() {
    
  }
  
  func presentInitialState() {
    
  }
  
  func handleErrorSilently(_ error: Error) {
    guard let vc = _viewController,
      vc.handleErrorSilently(error) else {
        AppLogger.error("unhandled error \(error.localizedDescription)")
        return
    }
  }
  func handleError(_ error: Error) {
    guard let vc = _viewController,
      vc.handledError(error) else {
      AppLogger.error("unhandled error \(error.localizedDescription)")
      return
    }
  }
}


extension NSNotification.Name {
  static let applicationDidBecomeActiveCustomNotification: NSNotification.Name = NSNotification.Name("applicationDidBecomeActiveCustomNotification")
  
}

