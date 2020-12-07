//
//  FadeAnimation.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class FadeAnimationController: NSObject, AnimatedTransitioningProtocol {
  var interactiveTransitioning: GestureInteractionController?
  fileprivate let presenting: Bool
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }
    
    let container = transitionContext.containerView
    if presenting {
      container.addSubview(toView)
      toView.alpha = 0.0
    } else {
      container.insertSubview(toView, belowSubview: fromView)
    }
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
      if self.presenting {
        toView.alpha = 1.0
      } else {
        fromView.alpha = 0.0
      }
    }) { _ in
      let success = !transitionContext.transitionWasCancelled
      if !success {
        toView.removeFromSuperview()
      }
      transitionContext.completeTransition(success)
    }
  }
  
  init(presenting: Bool) {
    self.presenting = presenting
  }
}
