//
//  PromotionDestinationPickViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 23/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: PromotionDestinationPickView Class
final class PromotionDestinationPickViewController: ViewController {
  @IBOutlet weak var userProfileDestinationSelectionImageView: UIImageView!
  
  @IBOutlet weak var urlDestinationSelectionImageView: UIImageView!
  
  @IBOutlet weak var urlDestinationPickedWebSiteLabel: UILabel!
  
  @IBOutlet weak var urlDestinationPickedActionTitleLabel: UILabel!
  
  @IBOutlet weak var urlDestinationPickedInfoContaninerView: UIView!
  
  @IBOutlet weak var nextButton: UIButton!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func userProfileDestinationSelectAction(_ sender: Any) {
    presenter.handleUserProfileDestinationSelection()
  }
  
  @IBAction func urlDestinationSelectAction(_ sender: Any) {
    presenter.handleUrlDestinationSelection()
  }
  
  @IBAction func nextStepAction(_ sender: Any) {
    presenter.handleNextStepAction()
  }
}

//MARK: - PromotionDestinationPickView API
extension PromotionDestinationPickViewController: PromotionDestinationPickViewControllerApi {
  func setNextStepButtonEnabled(_ enabled: Bool) {
    nextButton.isEnabled = enabled
  }
  
  func setSelectedUrlDestination(_ urlDestination: (urlTitle: String, actionTitle: String)?) {
    guard let urlDestination = urlDestination else {
      urlDestinationPickedInfoContaninerView.isHidden = true
      return
    }
    
    urlDestinationPickedInfoContaninerView.isHidden = false
    urlDestinationPickedActionTitleLabel.text = urlDestination.actionTitle
    urlDestinationPickedWebSiteLabel.text = urlDestination.urlTitle
  }
  
  func setUserdestinationSelected(_ selected: Bool) {
    userProfileDestinationSelectionImageView.image = selected ?
      UIImage(imageLiteralResourceName: "PromotionDestinationPick-SelectionImage-selected"):
      UIImage(imageLiteralResourceName: "PromotionDestinationPick-SelectionImage")
  }
  
  func setURLdestinationSelected(_ selected: Bool) {
    urlDestinationSelectionImageView.image = selected ?
      UIImage(imageLiteralResourceName: "PromotionDestinationPick-SelectionImage-selected"):
      UIImage(imageLiteralResourceName: "PromotionDestinationPick-SelectionImage")
  }
}

// MARK: - PromotionDestinationPickView Viper Components API
fileprivate extension PromotionDestinationPickViewController {
  var presenter: PromotionDestinationPickPresenterApi {
    return _presenter as! PromotionDestinationPickPresenterApi
  }
}
