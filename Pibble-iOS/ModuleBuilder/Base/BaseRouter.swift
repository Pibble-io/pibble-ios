//
//  Router.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol RouterProtocol: class {
  var _presenter: PresenterProtocol! { get set }
  var _viewController: BaseViewController! { get }
}

extension RouterProtocol {
  func routeToRoot(animated: Bool = true) {
    guard let navigationController = _viewController.navigationController,
      navigationController.viewControllers.count > 1 else {
        _viewController.dismiss(animated: animated)
        return
    }
    
    _viewController.navigationController?.popToRootViewController(animated: animated)
  }
  
  func dismissPresented(animated: Bool = true) {
    guard let navigationController = _viewController.navigationController,
      navigationController.viewControllers.count > 1,
      navigationController.viewControllers.last != _viewController else {
        _viewController.presentedViewController?.dismiss(animated: animated)
        return
    }
    
    _viewController.navigationController?.popViewController(animated: animated)
  }
  
  func dismiss(withPop: Bool = true, removeFromParentIfPossible: Bool = false, animated: Bool = true) {
    if removeFromParentIfPossible && _viewController.parent != nil {
      removeFromContainerView(animated: animated)
      return
    }
    
    guard let navigationController = _viewController.navigationController,
      navigationController.viewControllers.count > 1 else {
        _viewController.dismiss(animated: animated)
        return
    }
    
    guard withPop else {
      _viewController.dismiss(animated: animated)
      return
    }
    
    _viewController.navigationController?.popViewController(animated: animated)
  }
  
  func show(inWindow window: UIWindow?, embedInNavController: Bool = false, makeKeyAndVisible: Bool = true, animated: Bool = true) {
    
    let targetVC = embedInNavController ? embedInNavigationController() : _viewController
    guard animated, let existingWindow = window else {
      window?.rootViewController = targetVC
      if makeKeyAndVisible {
        window?.makeKeyAndVisible()
      }
      return
    }
    
    let currentVC = window?.rootViewController
    
    UIView.transition(with: existingWindow,
                      duration: 0.3,
                      options: .transitionCrossDissolve,
                      animations: {
                        
                        currentVC?.dismiss(animated: false) {
                          currentVC?.view.removeFromSuperview()
                        }
                        window?.rootViewController = targetVC
    }) { (_) in
      if makeKeyAndVisible {
        window?.makeKeyAndVisible()
      }
    }
  }
  
  func present(withDissolveFrom: UIViewController, embedInNavController: Bool = false, animated: Bool = true) {
    let viewController = embedInNavController ? embedInNavigationController() : _viewController
    guard let vc = viewController else {
      return
    }
    
    vc.modalPresentationStyle = .custom
    vc.modalTransitionStyle = .crossDissolve
    withDissolveFrom.present(vc, animated: animated)
  }
  
  func present(withFlipFrom: UIViewController, embedInNavController: Bool = false, animated: Bool = true) {
    let viewController = embedInNavController ? embedInNavigationController() : _viewController
    guard let vc = viewController else {
      return
    }
    
    vc.modalTransitionStyle = .flipHorizontal
    withFlipFrom.present(vc, animated: animated)
  }
  
  func present(withCoverFrom: UIViewController, embedInNavController: Bool = false, animated: Bool = true) {
    let viewController = embedInNavController ? embedInNavigationController() : _viewController
    guard let vc = viewController else {
      return
    }
    
    vc.modalTransitionStyle = .coverVertical
    withCoverFrom.present(vc, animated: animated)
  }
  
  func presentFromRootWithPush(animated: Bool = true) {
    guard let root = UIApplication.topViewController() else {
      return
    }
    
    guard let navController = root.navigationController else {
      AppLogger.critical("\(ModuleBuilderError.navigationControllerNotFound): \(type(of: root))")
      root.present(_viewController, animated: animated)
      return
    }
    
    navController.pushViewController(_viewController, animated: animated)
  }
  
  func present(withCursomTransitionFrom: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate, embedInNavController: Bool = false, animated: Bool = true) {
    let viewController = embedInNavController ? embedInNavigationController() : _viewController
    guard let vc = viewController else {
      return
    }
    
    vc.transitioningDelegate = transitioningDelegate
    withCursomTransitionFrom.present(vc, animated: animated)
  }
  
  func present(withPushfrom: UIViewController, animated: Bool = true) {
    guard let navController = withPushfrom.navigationController else {
      AppLogger.critical("\(ModuleBuilderError.navigationControllerNotFound): \(type(of: withPushfrom))")
      withPushfrom.present(_viewController, animated: animated)
      return
    }
    navController.pushViewController(_viewController, animated: animated)
  }
  
  func present(from: UIViewController, embedInNavController: Bool = false, animated: Bool = true) {
    let viewController = embedInNavController ? embedInNavigationController() : _viewController
    guard let vc = viewController else {
      return
    }
    from.present(vc, animated: animated)
  }
  
  func removeFromContainerView(animated: Bool = false) {
    guard animated else {
      _presenter._viewController.beginAppearanceTransition(false, animated: animated)
      _presenter._viewController.willMove(toParent: nil)
      
      _presenter._viewController.view.removeFromSuperview()
      _presenter._viewController.removeFromParent()
      _presenter._viewController.endAppearanceTransition()
      
      return
    }
    _presenter._viewController.beginAppearanceTransition(false, animated: animated)
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?._presenter._viewController.view.alpha = 0.0
    }) { [weak self] (_) in
      self?._presenter._viewController.willMove(toParent: nil)
      self?._presenter._viewController.view.removeFromSuperview()
      self?._presenter._viewController.removeFromParent()
      self?._presenter._viewController.endAppearanceTransition()
    }
  }
  
  func show(from parentViewController: UIViewController, insideView targetView: UIView, embedInNavController: Bool = false) {
    addAsChildView(ofViewController: parentViewController, insideContainer: targetView, embedInNavController: embedInNavController)
  }
}

class BaseRouter: RouterProtocol {
  weak var _presenter: PresenterProtocol!
  
  var _viewController: BaseViewController! {
    return _presenter._viewController
  }
}

//MARK: - Embed view in navigation controller

extension RouterProtocol {
  fileprivate func getNavigationController() -> UINavigationController? {
    if let nav = _viewController.navigationController {
      return nav
    } else if let parent = _viewController.parent {
      if let parentNav = parent.navigationController {
        return parentNav
      }
    }
    return nil
  }
  
  func embedInNavigationController() -> UINavigationController {
    guard let existingNavigationController = getNavigationController() else {
      let newNavigationController = NavigationController(rootBaseViewController: _viewController)
      return newNavigationController
    }
    
    return existingNavigationController
  }
}

//MARK: - Embed view in a container view

extension RouterProtocol {
  func addAsChildView(ofViewController parentViewController: UIViewController, insideContainer containerView: UIView, embedInNavController: Bool = false) {
    guard let viewController = _viewController else {
      return
    }

    let childViewController = embedInNavController ?
      NavigationController(rootBaseViewController: viewController) :
    viewController
    
    childViewController.beginAppearanceTransition(true, animated: false)
    
    parentViewController.addChild(childViewController)
    childViewController.view.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(childViewController.view)
    stretchToBounds(containerView, view: childViewController.view)
    childViewController.didMove(toParent: parentViewController)
    
    childViewController.endAppearanceTransition()
  }
  
  fileprivate func stretchToBounds(_ containerView: UIView, view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      view.topAnchor.constraint(equalTo: containerView.topAnchor),
      view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
      ])
    
    //
    //    let pinDirections: [NSLayoutAttribute] = [.top, .bottom, .left, .right]
    //    let pinConstraints = pinDirections.map { direction -> NSLayoutConstraint in
    //      return NSLayoutConstraint(item: view, attribute: direction, relatedBy: .equal,
    //                                toItem: holderView, attribute: direction, multiplier: 1.0, constant: 0)
    //    }
    //    holderView.addConstraints(pinConstraints)
  }
}

extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
