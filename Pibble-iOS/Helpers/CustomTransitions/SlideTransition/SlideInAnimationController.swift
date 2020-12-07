//
//  SlideInAnimationController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class SlideInAnimationController: NSObject, AnimatedTransitioningProtocol {
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
    dimView.alpha = 0.0
    
    fromView.addSubview(dimView)
    
    container.addSubview(toView)
    toView.frame.origin.x = fromView.bounds.width
    
    toView.addShadow(shadowColor: UIColor.black,
                                          offSet: CGSize(width: -3, height: 0),
                                          opacity: 0.3,
                                          radius: 3.0)
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext),
                   delay: 0.0,
                   options: .curveEaseInOut,
                   animations: {
          dimView.alpha = 0.2
          fromView.frame.origin.x = -fromView.bounds.width * 0.3
          toView.frame.origin.x = 0.0
                    
    }) { (_) in
      let success = !transitionContext.transitionWasCancelled
      if !success {
        toView.removeFromSuperview()
        
      }
      toView.layer.shadowOpacity = 0.0
      dimView.removeFromSuperview()
      transitionContext.completeTransition(success)
    }
  }
}
