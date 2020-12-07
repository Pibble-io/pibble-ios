//
//  CreatePromotionConfirmViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: CreatePromotionConfirmView Class
final class CreatePromotionConfirmViewController: ViewController {
  
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var headerContainerView: UIView!
  @IBOutlet weak var promotionInfoContainerView: UIView!
  
  @IBOutlet weak var promotionPreviewButtonContainerView: UIView!
  
  
  
  @IBOutlet weak var promotionDestinationLabel: UILabel!
  
  @IBOutlet weak var promotionActionLabel: UILabel!
  
  @IBOutlet weak var promotionBudgetLabel: UILabel!
  @IBOutlet weak var headerSubtitleLabel: UILabel!
  
  @IBOutlet weak var createPromotionButton: UIButton!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func previewAction(_ sender: Any) {
    presenter.handlePreviewAction()
  }
  
  @IBAction func termsAction(_ sender: Any) {
  }
  
  @IBAction func advertiseGuideAction(_ sender: Any) {
  }
  
  @IBAction func createPromotionAction(_ sender: Any) {
    presenter.handleCreatePromotionAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
  }
}

//MARK: - CreatePromotionConfirmView API
extension CreatePromotionConfirmViewController: CreatePromotionConfirmViewControllerApi {
  func showConfirmationAlertWith(_ title: String, message: String) {let okAction = UIAlertAction(title: CreatePromotionConfirm.Strings.Alerts.ok.localize(), style: .default) { [weak self] (action) in
    
    self?.presenter.handleCreatePromotionConfirmAction()
    }
    
    let canceAction = UIAlertAction(title: CreatePromotionConfirm.Strings.Alerts.cancel.localize(), style: .cancel) {(action) in
      
    }
    
    let actions: [UIAlertAction] = [canceAction, okAction]
    showAlertWith(title, message: message, actions: actions, preferredStyle: .alert)
  }
  
  func showPromotionCreationSuccessfulAlert() {
    let title = CreatePromotionConfirm.Strings.Alerts.PromotionCreationSuccess.title.localize()
    let message = CreatePromotionConfirm.Strings.Alerts.PromotionCreationSuccess.message.localize()
    
    let okAction = UIAlertAction(title: CreatePromotionConfirm.Strings.Alerts.ok.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handlePromotionCreationFinishAction()
    }
    
    let actions: [UIAlertAction] = [okAction]
    showAlertWith(title, message: message, actions: actions, preferredStyle: .alert)
  }
  
  func setPromotionViewModel(_ vm: CreatePromotionConfirmDraftViewModelProtocol?, animated: Bool) {
    promotionDestinationLabel.text = vm?.destination ?? ""
    promotionActionLabel.text = vm?.action ?? ""
    promotionBudgetLabel.text = vm?.budget ?? ""
    
    let hidden = vm == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    guard animated else {
      promotionInfoContainerView.alpha = alpha
      promotionInfoContainerView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.promotionInfoContainerView.alpha = alpha
      self?.promotionInfoContainerView.isHidden = hidden

      self?.stackView.layoutIfNeeded()
    }
  }
  
  func setHeaderSubtitle(_ text: String, animated: Bool) {
    headerSubtitleLabel.text = text
    guard animated else {
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.stackView.layoutIfNeeded()
    }
  }
  
  func setPromotionDestination(_ text: String) {
    promotionDestinationLabel.text = text
  }
  
  func setPromotionAction(_ text: String) {
    promotionActionLabel.text = text
  }
  
  func setPromotionBudget(_ text: String) {
    promotionBudgetLabel.text = text
  }
}

//MARK:- Helpers

extension CreatePromotionConfirmViewController {
  fileprivate func setupAppearance() {
    createPromotionButton.layer.cornerRadius = UIConstants.createPromoionButtonCornerRadius
    createPromotionButton.clipsToBounds = true
  }
}

// MARK: - CreatePromotionConfirmView Viper Components API
fileprivate extension CreatePromotionConfirmViewController {
  var presenter: CreatePromotionConfirmPresenterApi {
    return _presenter as! CreatePromotionConfirmPresenterApi
  }
}

fileprivate enum UIConstants {
  static let createPromoionButtonCornerRadius: CGFloat = 4.0
}
