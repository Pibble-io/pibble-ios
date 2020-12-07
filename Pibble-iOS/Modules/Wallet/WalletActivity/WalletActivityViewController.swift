//
//  WalletActivityViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: WalletActivityView Class
final class WalletActivityViewController: ViewController {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var sergmentControlContainerView: UIView!
  
  @IBOutlet weak var segmentSelectionView: UIView!
  @IBOutlet weak var contentContainerView: UIView!
  
  @IBOutlet var segmentButtons: [UIButton]!
  @IBOutlet var selectedSegmentLayoutConstraints: [NSLayoutConstraint]!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func switchSegmentAction(_ sender: UIButton) {
    guard let idx = segmentButtons.index(of: sender) else {
      return
    }
    
    let segment = segments[idx]
    setButtonStateFor(segment)
    presenter.handleSwitchTo(segment)
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewAppearance()
    setButtonStateFor(.brush)
    presenter.handleSwitchTo(.brush)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  //MARK:- Properties
  
  let segments: [WalletActivity.SelectedSegment] = [.brush, .pibble, .etherium, .bitcoin]
}

//MARK: - WalletActivityView API
extension WalletActivityViewController: WalletActivityViewControllerApi {
  var submoduleContainerView: UIView {
    return contentContainerView
  }
  
   
}

// MARK: - WalletActivityView Viper Components API
fileprivate extension WalletActivityViewController {
    var presenter: WalletActivityPresenterApi {
        return _presenter as! WalletActivityPresenterApi
    }
}

extension WalletActivityViewController {
  fileprivate func setupViewAppearance() {
    segmentSelectionView.layer.cornerRadius = 1.0
    segmentSelectionView.clipsToBounds = true
    
    containerView.layer.cornerRadius = 5.0
    containerView.clipsToBounds = true
  }
  
  fileprivate func setButtonStateFor(_ segment: WalletActivity.SelectedSegment) {
    segments.enumerated().forEach {
      let isSelected = $0.element == segment
      selectedSegmentLayoutConstraints[$0.offset].priority = isSelected ? .defaultHigh : .defaultLow
      segmentButtons[$0.offset].isSelected = isSelected
    }
    
    UIView.animate(withDuration: 0.3,
                   delay: 0.0,
                   usingSpringWithDamping: 0.65,
                   initialSpringVelocity: 0.5,
                   options: .curveEaseInOut,
                   animations: { [weak self] in
                    self?.sergmentControlContainerView.layoutIfNeeded()
    }) { (_) in  }
    
  }
}








