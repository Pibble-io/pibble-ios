//
//  MediaDetailViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import AVKit

//MARK: MediaDetailView Class
final class MediaDetailViewController: ViewController {
  @IBOutlet weak var hideButton: UIButton!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var imageContainerView: UIView!
  
  @IBOutlet weak var imageContainerLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageContainerBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageContainerRightConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageContainerTopConstraint: NSLayoutConstraint!
  
  
  @IBOutlet weak var imageContainerWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageContainerHeightConstraint: NSLayoutConstraint!
  
  fileprivate var videoLayer: AVPlayerLayer?
  fileprivate weak var downloadingStatusAlert: UIAlertController?
  fileprivate weak var progressView: UIProgressView?
  
  fileprivate var isImageDownloaded = false
  fileprivate var viewModel: MediaDetailMediaViewModelProtocol?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    modalPresentationCapturesStatusBarAppearance = true
    setupView()
  }
  
  
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateMinZoomScaleForSize(view.bounds.size)
    
    guard imageContainerView.bounds.height > view.bounds.height && isCurrentImagePortrait else {
      let zoomScale = view.bounds.height / imageContainerView.bounds.height
      scrollView.setZoomScale(zoomScale, animated: false)
      
      let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
      let centerOffsetY: CGFloat = (scrollView.contentSize.height - scrollView.frame.size.height) / 2
      let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
      scrollView.setContentOffset(centerPoint, animated: false)
      return
    }
    
    //webtoons presentation
    
    scrollView.setZoomScale(scrollView.bounds.width / imageContainerView.bounds.width , animated: false)
    
    let centerOffsetX = (scrollView.contentSize.width - scrollView.frame.size.width) / 2
    let centerOffsetY: CGFloat = 0.0
    let centerPoint = CGPoint(x: centerOffsetX, y: centerOffsetY)
    scrollView.setContentOffset(centerPoint, animated: false)
  }
}

//MARK: - MediaDetailView API
extension MediaDetailViewController: MediaDetailViewControllerApi {
  fileprivate func updateConstraintsForSize(_ size: CGSize) {
    let yOffset = max(0, (size.height - imageContainerView.frame.height) / 2)
    
    imageContainerTopConstraint.constant = yOffset
    imageContainerBottomConstraint.constant = yOffset
    
    let xOffset = max(0, (size.width - imageContainerView.frame.width) / 2)
    imageContainerLeftConstraint.constant = xOffset
    imageContainerRightConstraint.constant = xOffset
  }
  
  fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
    let widthScale = size.width / imageContainerView.bounds.width
    let heightScale = size.height / imageContainerView.bounds.height
    let minScale = min(widthScale, heightScale)
    
    scrollView.minimumZoomScale = minScale
    scrollView.zoomScale = minScale
  }
  
  func presentDownloadingStatusAlert() {
    guard !isImageDownloaded else {
      return
    }
    
    let alert = UIAlertController(title: MediaDetail.Strings.Alerts.downloading.localize(), message: "", safelyPreferredStyle: .alert)
    alert.view.tintColor = UIColor.bluePibble
    
    let progressBar = UIProgressView(progressViewStyle: .default)
    progressBar.setProgress(0.0, animated: false)
    progressBar.frame = CGRect(x: 0, y: 62, width: 270, height: 0)
    
    progressBar.trackTintColor = UIColor.lightGray
    progressBar.progressTintColor = UIColor.bluePibble
    alert.view.addSubview(progressBar)
    
    let cancel = UIAlertAction(title: MediaDetail.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleHideAction()
    }
    
    alert.addAction(cancel)
    
    progressView = progressBar
    
    downloadingStatusAlert = alert
    present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.bluePibble
  }
  
  func setMediaViewModel(_ vm: MediaDetailMediaViewModelProtocol) {
    
    if vm.isLandscape {
       //we limit landscape container contraints to screen height
      let ratio = vm.contentSize.height / vm.contentSize.width
      imageContainerHeightConstraint.constant = view.bounds.height
      imageContainerWidthConstraint.constant = imageContainerHeightConstraint.constant * ratio
      
      imageView.center = CGPoint(x: imageContainerWidthConstraint.constant / 2, y:imageContainerHeightConstraint.constant / 2)
      imageView.bounds.size = CGSize(width: imageContainerHeightConstraint.constant, height: imageContainerWidthConstraint.constant)
      imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
    } else {
      //we limit portrait container contraints to screen width
      let ratio = vm.contentSize.height / vm.contentSize.width
      imageContainerWidthConstraint.constant = view.bounds.width
      imageContainerHeightConstraint.constant = imageContainerWidthConstraint.constant * ratio
      
      imageView.center = CGPoint(x: imageContainerWidthConstraint.constant / 2, y:imageContainerHeightConstraint.constant / 2)
      imageView.bounds.size = CGSize(width: imageContainerWidthConstraint.constant, height: imageContainerHeightConstraint.constant)
      imageView.transform = CGAffineTransform.identity
    }
    
    switch vm.contentType {
    case .image:
      imageView.setCachedImageOrDownload(vm.urlString, progressBlock: { [weak self] (ready, total) in
        let progress = Float(ready) / Float(total)
        self?.progressView?.setProgress(progress, animated: true)
      }) { [weak self] (_) in
        self?.isImageDownloaded = true
        self?.downloadingStatusAlert?.dismiss(animated: true)
      }
    case .video:
      imageView.image = nil
      imageView.setCachedImageOrDownload(vm.thumbnailImageUrlString)
      let newVideoLayer = AVPlayerLayer(urlString: vm.urlString)
      
      videoLayer?.removeFromSuperlayer()
      videoLayer = newVideoLayer
      guard let video = videoLayer else {
        return
      }
      
      video.frame.size = imageView.bounds.size
      
      videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      imageView.layer.addSublayer(video)
    case .unknown:
      break
    }
  }
  
}

// MARK: - MediaDetailView Viper Components API
fileprivate extension MediaDetailViewController {
  var presenter: MediaDetailPresenterApi {
    return _presenter as! MediaDetailPresenterApi
  }
}


//MARK:- Helpers

extension MediaDetailViewController {
  fileprivate var isCurrentImagePortrait: Bool {
    return imageView.transform.isIdentity
  }
  
  
  fileprivate func setupView() {
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 3.0
    scrollView.contentSize = imageView.bounds.size
    scrollView.delegate = self
  }
}

extension MediaDetailViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageContainerView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    updateConstraintsForSize(view.bounds.size)
  }
}


extension CGRect {
  var centralPoint: CGPoint {
    return CGPoint(x: size.width / 2, y: size.height / 2)
  }
}
