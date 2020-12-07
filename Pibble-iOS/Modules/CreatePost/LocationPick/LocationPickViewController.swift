//
//  LocationPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: LocationPickView Class
final class LocationPickViewController: ViewController {
  @IBOutlet weak var inputTextField: UITextField!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var inputTextBackgroundView: UIView!
  
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
 
  //MARK:- IBActions
  
  @IBAction func cancelSearchTypeAction(_ sender: Any) {
    view.endEditing(true)
    inputTextField.text = ""
    presenter.handleInputTextChange(inputTextField.text ?? "")
  }
  
  @IBAction func textFiendEditChangeAction(_ sender: Any) {
    presenter.handleInputTextChange(inputTextField.text ?? "")
  }
  @IBAction func doneAction(_ sender: Any) {
    presenter.handleDoneAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeKeyboardNotications()
    inputTextField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeKeyboardNotications()
  }
}

//MARK: - LocationPickView API
extension LocationPickViewController: LocationPickViewControllerApi {
  func reloadLocationsCollection() {
    tableView.reloadData()
  }
}

// MARK: - LocationPickView Viper Components API
fileprivate extension LocationPickViewController {
    var presenter: LocationPickPresenterApi {
        return _presenter as! LocationPickPresenterApi
    }
}

//MARK:- Helpers

extension LocationPickViewController {
  func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func setupAppearance() {
   inputTextBackgroundView.layer.cornerRadius = inputTextBackgroundView.bounds.height * 0.5
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 70.0
    
    tableView.layer.cornerRadius = UIConstants.CornerRadius.tableView
    tableView.clipsToBounds = true
  }
}

//MARK:- UITableViewDelegate, UITableViewDataSource

extension LocationPickViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.handleSelectionAt(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModelType = presenter.itemViewModelFor(indexPath)
    switch viewModelType {
    case .location(let vm):
      let id = LocationSuggestionTableViewCell.identifier
      let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! LocationSuggestionTableViewCell
      cell.setViewModel(vm)
      return cell
    }
  }
  
}

extension LocationPickViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.tableView.contentInset.bottom = 0.0
    }) { (_) in  }
  }
   
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.tableView.contentInset.bottom = bottomInsets
    }) { (_) in  }
  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 150.0
    static let inputTextViewMinHeight: CGFloat = 70.0
  }
  
  enum CornerRadius {
    static let tableView: CGFloat = 10.0
  }
}

