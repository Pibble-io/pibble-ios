//
//  Module.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

fileprivate let iPadStoryboardSuffix = "Pad"

typealias ModuleComponents = (V: BaseViewController.Type, I: InteractorProtocol, P: PresenterProtocol, R: RouterProtocol)

//MARK: - Module

public struct Module {
  private(set) var view: BaseViewController
  private(set) var interactor: InteractorProtocol
  private(set) var presenter: PresenterProtocol
  private(set) var router: RouterProtocol
  
  static func build<T: ViperModuleProtocol>(_ module: T,
                                   bundle: Bundle = Bundle.main,
                                   deviceType: UIUserInterfaceIdiom? = nil,
                                   components: ModuleComponents) -> Module? {
    
    let viewType = components.V
    guard let V = loadViewFor(viewType, module: module, bundle: bundle, deviceType: deviceType) else {
      let error = ModuleBuilderError.cannotBuildViewFor(storyboardName: storyboardNameFor(module), viewControllerId: viewControllerIdFor(viewType))
      AppLogger.critical(error)
      return nil
    }
    
    let I = components.I
    let P = components.P
    let R = components.R
    
    return build(view: V, interactor: I, presenter: P, router: R)
  }
}

//MARK: - Inject Mock Components for Testing

extension Module {
  mutating func injectMock(view mockView: BaseViewController) {
    view = mockView
    view._presenter = presenter 
    presenter._viewController = view
  }
  
  mutating func injectMock(interactor mockInteractor: InteractorProtocol) {
    interactor = mockInteractor
    interactor._presenter = presenter
    presenter._interactor = interactor
  }
  
  mutating func injectMock(presenter mockPresenter: PresenterProtocol) {
    presenter = mockPresenter
    presenter._viewController = view
    presenter._interactor = interactor
    presenter._router = router
    view._presenter = presenter
    interactor._presenter = presenter
    router._presenter = presenter
  }
  
  mutating func injectMock(router mockRouter: RouterProtocol) {
    router = mockRouter
    router._presenter = presenter
    presenter._router = router
  }
}

//MARK: - Helper Methods
fileprivate extension Module {
  static func viewControllerIdFor<T: BaseViewController>(_ viewType: T.Type) -> String {
    return String(describing: viewType)
  }
  
  static func storyboardNameFor<M: ViperModuleProtocol>(_ module: M) -> String {
    return module.storyboardName.uppercasedFirst
  }
  
  static func loadViewFor<View, Module>(_ viewType: View.Type, module: Module, bundle: Bundle, deviceType: UIUserInterfaceIdiom? = nil) -> View?
    
    where
    Module: ViperModuleProtocol,
    View: BaseViewController {
 
    let viewControllerId = viewControllerIdFor(viewType)
    let storyboardName = storyboardNameFor(module)
      
//      let deviceType = deviceType ?? UIScreen.main.traitCollection.userInterfaceIdiom
//      let isPad = deviceType == .pad
//      if isPad, let tabletView = NSClassFromString(classInBundle + kTabletSuffix)
      
    switch module.viewType {
    case .fromStoryboard:
      let sb = UIStoryboard(name: storyboardName, bundle: bundle)
      return sb.instantiateViewController(withIdentifier: viewControllerId) as? View
    case .fromNib:
      return viewType.init(nibName: storyboardName, bundle: bundle)
    case .fromCode:
      return viewType.init()
    }
  }
  
  static func build(view: BaseViewController, interactor: InteractorProtocol, presenter: PresenterProtocol, router: RouterProtocol) -> Module {
    
    view._presenter = presenter
    
    interactor._presenter = presenter
    
    presenter._router = router
    presenter._interactor = interactor
    presenter._viewController = view
    
    router._presenter = presenter
    
    return Module(view: view, interactor: interactor, presenter: presenter, router: router)
  }
}

