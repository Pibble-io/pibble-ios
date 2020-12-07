//
//  UserInterface.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol: class {
  var _presenter: PresenterProtocol! { get set }
}

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {
  
  var navigationController: UINavigationController
  
  init(controller: UINavigationController) {
    self.navigationController = controller
  }
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return navigationController.viewControllers.count > 1
  }
  
  // This is necessary because without it, subviews of your top controller can
  // cancel out your gesture recognizer on the edge.
//  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    return true
//  }
}

class NavigationController: UINavigationController {
  
  convenience init(rootBaseViewController: BaseViewController) {
    self.init(rootViewController: rootBaseViewController)
    delegate = rootBaseViewController
  }
  
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return delegate?.navigationControllerSupportedInterfaceOrientations?(self) ?? .portrait
  }
}

class BaseViewController: UIViewController, ViewControllerProtocol {
  fileprivate var popRecognizer: InteractivePopRecognizer?
  
  static weak var globalErrorHandler: ErrorHandlerProtocol?
  weak var errorHandler: ErrorHandlerProtocol?
  
  var transitionsController = TransitionsController()
  
  var shouldHandleSwipeToPopGesture: Bool {
    return false
  }
  
  var _presenter: PresenterProtocol!
  
  required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _presenter.viewDidLoad()
  }
  
  override var shouldAutomaticallyForwardAppearanceMethods: Bool {
    return false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    children.forEach {
      $0.beginAppearanceTransition(true, animated: animated)
    }
    
    navigationController?.isNavigationBarHidden = true
    _presenter.viewWillAppear()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    children.forEach {
      $0.endAppearanceTransition()
    }
    
    if shouldHandleSwipeToPopGesture {
      setInteractiveGestureRecognizer()
    }
    _presenter.viewDidAppear()
    isVisible = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    children.forEach {
      $0.beginAppearanceTransition(false, animated: animated)
    }
    _presenter.viewWillDisappear()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    children.forEach {
      $0.endAppearanceTransition()
    }
    _presenter.viewDidDisappear()
    isVisible = false
  }
  
//  override func willMove(toParent parent: UIViewController?) {
//    super.willMove(toParent: parent)
//    if parent == nil {
//      _presenter.viewWillDisappear()
//    }
//  }
  
//  override func didMove(toParent parent: UIViewController?) {
//    super.didMove(toParent: parent)
//    if parent == nil {
//      _presenter.viewDidDisappear()
//    }
//  }
  
  override var shouldAutorotate: Bool {
    return false
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  fileprivate func setInteractiveGestureRecognizer() {
    guard let controller = navigationController else {
      return
    }
    
    popRecognizer = InteractivePopRecognizer(controller: controller)
    controller.interactivePopGestureRecognizer?.delegate = popRecognizer
  }
  
  fileprivate(set) var isVisible: Bool = false
}

extension BaseViewController: UINavigationControllerDelegate {
  func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
    let orientations = navigationController.topViewController?.supportedInterfaceOrientations
    
    return orientations ?? supportedInterfaceOrientations
  }
 
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    guard let controller = animationController as? AnimatedTransitioningProtocol,
        let interactiveTransitioning = controller.interactiveTransitioning,
        interactiveTransitioning.interactionInProgress
    else {
        return nil
    }
    
    return interactiveTransitioning
//    return (animationController as? AnimatedTransitioningProtocol)?.interactiveTransitioning
  }
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .none:
      return nil
    case .push:
      return (toVC as? BaseViewController)?.transitionsController.presentationAnimator
    case .pop:
      return (fromVC as? BaseViewController)?.transitionsController.dismissalAnimator
    }

  }
}

protocol AnimatedTransitioningProtocol: UIViewControllerAnimatedTransitioning {
  var interactiveTransitioning: GestureInteractionController? { get set }
}

class TransitionsController: NSObject, UIViewControllerTransitioningDelegate {
  var presentationAnimator: AnimatedTransitioningProtocol?
  var dismissalAnimator: AnimatedTransitioningProtocol?
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return presentationAnimator
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return dismissalAnimator
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return presentationAnimator?.interactiveTransitioning
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return dismissalAnimator?.interactiveTransitioning
  }
}
