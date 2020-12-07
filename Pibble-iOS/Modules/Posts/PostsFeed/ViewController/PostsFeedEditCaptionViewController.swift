//
//  PostsFeedEditCaptionViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedEditCaptionViewController: PostsFeedBaseContentViewController {
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func editDoneAction(_ sender: Any) {
    presenter.handeEditDoneAction()
  }
}

//MARK:- Overrides

extension PostsFeedEditCaptionViewController {
  override func showLocationOptionsActionSheet() {
    presentEditLocationOptionsActionSheet()
  }
  
  override func scrollTo(_ indexPath: IndexPath, animated: Bool) {
    tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
  }
}


//MARK:- Helpers
extension PostsFeedEditCaptionViewController {
  fileprivate func presentEditLocationOptionsActionSheet() {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let remove = UIAlertAction(title: PostsFeed.Strings.EditAlerts.removeLocationAction.localize(), style: .destructive) { [weak self] (action) in
      self?.presenter.handleCurrentItemRemoveLocationAction()
    }
    
    let change = UIAlertAction(title: PostsFeed.Strings.EditAlerts.changeLocationAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemEditLocationAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.EditAlerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertController.addAction(remove)
    alertController.addAction(change)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 200
    static let inputTextViewMinHeight: CGFloat = 43
  }
}
