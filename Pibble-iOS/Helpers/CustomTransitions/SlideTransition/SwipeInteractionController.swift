
//
//  PostsFeedGridContentViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//


import UIKit

class PanGestureSlideInteractionController: UIPercentDrivenInteractiveTransition, GestureInteractionController {
  fileprivate(set) var interactionInProgress = false
  fileprivate var shouldCompleteTransition = false
  fileprivate var prevTranslation = CGPoint.zero
  
  weak var delegate: GestureInteractionControllerDelegateProtocol?
  fileprivate let isRightEdge: Bool
  
  init(isRightEdge: Bool) {
    self.isRightEdge = isRightEdge
    super.init()
    completionSpeed = 0.5
    completionCurve = .easeInOut
  }
  
 func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    // Translation should be set to zero at topmost handler
    let translationDelta = gestureRecognizer.translation(in: gestureRecognizer.view)
    let direction: CGFloat = isRightEdge ? -1.0 : 1.0
    
    prevTranslation = CGPoint(x: prevTranslation.x + translationDelta.x, y: prevTranslation.y + translationDelta.y)
    let viewWidth = gestureRecognizer.view?.bounds.width ?? prevTranslation.x
  
    var progress = direction * prevTranslation.x / viewWidth
    progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
  
    switch gestureRecognizer.state {
    case .began:
      interactionInProgress = true
      delegate?.handlePresentActionWith(self)
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
    case .cancelled:
      prevTranslation = CGPoint.zero
      interactionInProgress = false
      cancel()
    case .ended:
      prevTranslation = CGPoint.zero
      interactionInProgress = false
      if shouldCompleteTransition {
        finish()
      } else {
        cancel()
      }
    default:
      break
    }
  }
}

