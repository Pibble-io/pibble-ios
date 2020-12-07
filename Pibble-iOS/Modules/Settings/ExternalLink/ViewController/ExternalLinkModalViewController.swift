//
//  ExternalLinkModalViewController.swift
//  Pibble
//
//  Created by Sergey Kazakov on 22/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import WebKit

//MARK: ExternalLinkView Class
final class ExternalLinkModalViewController: ViewController {
  @IBOutlet weak var navigationBarTitleLabel: UILabel!
  @IBOutlet weak var webViewTitleLabel: UILabel!
  
  @IBOutlet weak var bottomSlideOutContainerView: UIView!
  @IBOutlet weak var bottomSlideOutContentView: UIView!
  
  @IBOutlet weak var backgroundDimView: UIView!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var webViewContainer: UIView!
  var webView: WKWebView!
  @IBOutlet weak var webViewCollapsedConstraint: NSLayoutConstraint!
  @IBOutlet weak var webViewExtendedConstraint: NSLayoutConstraint!
  
  fileprivate var webViewTitleObserver: NSKeyValueObservation?
  
  deinit {
    webViewTitleObserver = nil
  }
  
  
  override func loadView() {
    super.loadView()
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.uiDelegate = self
    webView.allowsLinkPreview = true
    webView.allowsBackForwardNavigationGestures = true
    webViewContainer.addSubview(webView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
    setWebViewHidden(true, animated: false) {}
    webViewTitleLabel.text = ""
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setWebViewHidden(false, animated: true) {}
  }
  
  @IBAction func hideAction(_ sender: Any) {
    setWebViewHidden(true, animated: true) { [weak self]  in
      self?.presenter.handleHideAction()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = webViewContainer.bounds
  }
}

extension ExternalLinkModalViewController: WKUIDelegate {
  
}

//MARK: - ExternalLinkView API
extension ExternalLinkModalViewController: ExternalLinkViewControllerApi {
  func setNavigationBarTitle(_ title: String) {
    navigationBarTitleLabel.text = title
  }
  
  func setWebViewUrl(_ url: URL) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}

// MARK: - ExternalLinkView Viper Components API
fileprivate extension ExternalLinkModalViewController {
  var presenter: ExternalLinkPresenterApi {
    return _presenter as! ExternalLinkPresenterApi
  }
}

extension ExternalLinkModalViewController {
  fileprivate func setWebViewHidden(_ hidden: Bool, animated: Bool, complete: @escaping () -> Void) {
    let alpha: CGFloat = hidden ? 0.0 : 0.4
   
    guard animated else {
      webViewExtendedConstraint.priority = hidden ? .defaultLow : .defaultHigh
      webViewCollapsedConstraint.priority = !hidden ? .defaultLow : .defaultHigh
      
      backgroundDimView.alpha = alpha
      complete()
      return
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.webViewExtendedConstraint.priority = hidden ? .defaultLow : .defaultHigh
      self?.webViewCollapsedConstraint.priority = !hidden ? .defaultLow : .defaultHigh
      
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
    bottomSlideOutContentView.layer.cornerRadius = 17.0
    bottomSlideOutContentView.clipsToBounds = true 
    
    setBackgroundImageView()
    
    webViewTitleObserver = webView.observe(\WKWebView.title) { [weak self] (object, observedChange) in
      self?.webViewTitleLabel.text = object.title ?? ""
    }
  }
}
