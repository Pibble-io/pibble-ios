//
//  GestureInteractionControllerDelegateProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

protocol GestureInteractionController: UIViewControllerInteractiveTransitioning {
  var interactionInProgress: Bool { get }
}

protocol GestureInteractionControllerDelegateProtocol: class {
  func handlePresentActionWith(_ transition: GestureInteractionController)
}
