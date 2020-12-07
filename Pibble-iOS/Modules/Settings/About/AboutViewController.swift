//
//  AboutViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: AboutView Class
final class AboutViewController: ViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
}

//MARK: - AboutView API
extension AboutViewController: AboutViewControllerApi {
  func reloadData() {
    tableView.reloadData()
  }
  
}

// MARK: - AboutView Viper Components API
fileprivate extension AboutViewController {
  var presenter: AboutPresenterApi {
    return _presenter as! AboutPresenterApi
  }
}


//MARK:- UITableViewDataSource, UITableViewDelegate

extension AboutViewController: UITableViewDataSource, UITableViewDelegate {
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
    let viewModel = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: AboutTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}

//MARK:- Helpers

extension AboutViewController {
  fileprivate func setupView() {
    tableView.registerCell(AboutTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
  }
}

fileprivate enum UIConstants {
  static let itemCellsEstimatedHeight: CGFloat = 60.0
}
