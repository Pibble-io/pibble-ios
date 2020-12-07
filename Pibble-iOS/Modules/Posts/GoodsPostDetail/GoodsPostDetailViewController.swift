//
//  GoodsPostDetailViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 30/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: GoodsPostDetailView Class
final class GoodsPostDetailViewController: ViewController {
  @IBOutlet weak var bottomSlideOutContainerView: UIView!
  @IBOutlet weak var bottomSlideOutContentView: UIView!
  
  @IBOutlet weak var backgroundDimView: UIView!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var contentContainerView: UIView!
  
  @IBOutlet weak var contentCollapsedConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentExtendedConstraint: NSLayoutConstraint!
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setContentViewHidden(true, animated: false) {}
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setContentViewHidden(false, animated: true) {}
  }
  
  @IBAction func hideAction(_ sender: Any) {
    setContentViewHidden(true, animated: true) { [weak self]  in
      self?.presenter.handleHideAction()
    }
  }
}

//MARK: - GoodsPostDetailView API
extension GoodsPostDetailViewController: GoodsPostDetailViewControllerApi {
}

// MARK: - GoodsPostDetailView Viper Components API
fileprivate extension GoodsPostDetailViewController {
  var presenter: GoodsPostDetailPresenterApi {
    return _presenter as! GoodsPostDetailPresenterApi
  }
}


extension GoodsPostDetailViewController {
  fileprivate func setContentViewHidden(_ hidden: Bool, animated: Bool, complete: @escaping () -> Void) {
    let alpha: CGFloat = hidden ? 0.0 : 0.4
    
    guard animated else {
      contentExtendedConstraint.priority = hidden ? .defaultLow : .defaultHigh
      contentCollapsedConstraint.priority = !hidden ? .defaultLow : .defaultHigh
      
      backgroundDimView.alpha = alpha
      complete()
      return
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.contentExtendedConstraint.priority = hidden ? .defaultLow : .defaultHigh
      self?.contentCollapsedConstraint.priority = !hidden ? .defaultLow : .defaultHigh
      
      self?.backgroundDimView.alpha = alpha
      self?.bottomSlideOutContainerView.layoutIfNeeded()
    }) { (_) in
      complete()
    }
  }
  
  fileprivate func setBackgroundImageView() {
    backgroundImageView.image = presentingViewController?.view.takeSnapshot()
  }
  
  fileprivate func setupView() {
    
  }
  
  func setupAppearance() {
    bottomSlideOutContentView.layer.cornerRadius = 12.0
    bottomSlideOutContentView.clipsToBounds = true
    
    setBackgroundImageView()
  }
}
