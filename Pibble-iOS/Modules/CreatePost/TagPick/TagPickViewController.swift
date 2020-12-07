//
//  TagPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: TagPickView Class
final class TagPickViewController: ViewController {
  //MARK:- IBOutlets
  @IBOutlet weak var inputTextView: UITextView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var inputTextBackgroundView: UIView!
  
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  //MARK:- IBOutlets LayoutConstraints
  
  @IBOutlet weak var inputTextViewHeightConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
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
    updateEditViewForTextContent()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    inputTextView.becomeFirstResponder()
  }
}

//MARK: - TagPickView API
extension TagPickViewController: TagPickViewControllerApi {
  func setCurrentTagString(_ string: String) {
    inputTextView.text = string
  }
  
  func reloadTagsCollection() {
    tableView.reloadData()
  }
  
}

// MARK: - TagPickView Viper Components API
fileprivate extension TagPickViewController {
    var presenter: TagPickPresenterApi {
        return _presenter as! TagPickPresenterApi
    }
}

//MARK:- Helpers

extension TagPickViewController {
  func setupView() {
    inputTextView.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func setupAppearance() {
    inputTextBackgroundView.clipsToBounds =  true
    inputTextBackgroundView.layer.cornerRadius = UIConstants.CornerRadius.inputTextViewBackground
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 70.0
    
    tableView.layer.cornerRadius = UIConstants.CornerRadius.tableView
    tableView.clipsToBounds = true
  }
}

//MARK:- UITextViewDelegate
extension TagPickViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    updateEditViewForTextContent()
    presenter.handleInputTextChange(textView.text)
  }
  
  fileprivate func updateEditViewForTextContent() {
    let fittingSize = inputTextView.sizeThatFits(CGSize(width: inputTextView.frame.size.width, height: 9999))
   // let viewContentHeightWithoutTextView = 20.0
    let textViewMinHeight = UIConstants.Constraints.inputTextViewMinHeight
    let viewMaxHeight = UIConstants.Constraints.inputTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height)) //+ viewContentHeightWithoutTextView
    let viewContentHeight = min(viewMaxHeight, trueViewHeight)
    
    inputTextViewHeightConstraint.constant = viewContentHeight
    
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
      self?.view.layoutIfNeeded()
      
    }) { (_) in  }
  }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension TagPickViewController: UITableViewDelegate, UITableViewDataSource {
  
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
    let vm = presenter.itemViewModelFor(indexPath)
    let id = TagSuggestionTableViewCell.identifier
    let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TagSuggestionTableViewCell
    cell.setViewModel(vm)
    return cell
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let inputTextViewBackground: CGFloat = 10.0
     static let tableView: CGFloat = 10.0
  }
  
   
  
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 150.0
    static let inputTextViewMinHeight: CGFloat = 70.0
  }
}
