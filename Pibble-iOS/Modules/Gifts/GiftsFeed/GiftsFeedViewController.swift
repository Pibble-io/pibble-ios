//
//  GiftsFeedViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import WebKit

//MARK: GiftsFeedView Class
final class GiftsFeedViewController: ViewController {
  
  @IBOutlet weak var navigationBarTitleLabel: UILabel!
  
  @IBOutlet weak var webViewContainer: UIView!

  @IBOutlet weak var searchButton: UIButton!
  
  var webView: WKWebView!
  
  override func loadView() {
    super.loadView()
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.uiDelegate = self
    webViewContainer.addSubview(webView)
    
  }
  
  @IBAction func searchAction(_ sender: Any) {
    presenter.handleSearchAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleExitAction()
  }
  
  @IBAction func backAction(_ sender: Any) {
    guard webView.canGoBack else {
      presenter.handleHideAction()
      return
    }
    
    webView.goBack()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = webViewContainer.bounds
  }
}

extension GiftsFeedViewController: WKUIDelegate {
  
}

//MARK: - GiftsFeedView API
extension GiftsFeedViewController: GiftsFeedViewControllerApi {
  func setSearchButtonHidden(_ hidden: Bool) {
    searchButton.isHidden = hidden
  }
  
  func setNavigationBarTitle(_ title: String) {
    navigationBarTitleLabel.text = title
  }
  
  func setWebViewUrl(_ url: URL) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}

// MARK: - GiftsFeedView Viper Components API
fileprivate extension GiftsFeedViewController {
  var presenter: GiftsFeedPresenterApi {
    return _presenter as! GiftsFeedPresenterApi
  }
}
