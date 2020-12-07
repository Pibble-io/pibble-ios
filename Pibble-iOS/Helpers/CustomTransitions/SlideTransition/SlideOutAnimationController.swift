//
//  SlideOutAnimationController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, AnimatedTransitioningProtocol {
  var interactiveTransitioning: GestureInteractionController?
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }
    
    let container = transitionContext.containerView
    
    let dimView = UIView(frame: container.bounds)
    dimView.backgroundColor = UIColor.black
    dimView.alpha = 0.2
    toView.addSubview(dimView)
    
    container.insertSubview(toView, belowSubview: fromView)
    fromView.frame.origin.x = 0.0
    toView.frame.origin.x = -toView.bounds.width * 0.3
    
    fromView.addShadow(shadowColor: UIColor.black,
                     offSet: CGSize(width: -3, height: 0),
                     opacity: 0.3,
                     radius: 3.0)
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext),
                   delay: 0.0,
                   options: .curveEaseInOut,
                   animations: {
      fromView.frame.origin.x = toView.bounds.width
      toView.frame.origin.x = 0.0
      dimView.alpha = 0.0
                    
    }) { (_) in
      let success = !transitionContext.transitionWasCancelled
      if !success {
        toView.removeFromSuperview()
      }
      
      fromView.layer.shadowOpacity = 0.0
      dimView.removeFromSuperview()
      transitionContext.completeTransition(success)
    }
  }
}
