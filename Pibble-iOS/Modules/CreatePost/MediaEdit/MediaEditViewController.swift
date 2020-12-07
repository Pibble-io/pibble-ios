//
//  MediaEditViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: MediaEditView Class
final class MediaEditViewController: ViewController {
  
  @IBOutlet weak var mediaEditModesCollectionView: UICollectionView!
  @IBOutlet weak var previewImageView: UIImageView!
  
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var nextStepButton: UIButton!
  
  @IBAction func nextStepAction(_ sender: Any) {
    presenter.handleNextStepAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  fileprivate var videoLayer: CALayer? {
    didSet {
      if let oldValue = oldValue {
        oldValue.removeFromSuperlayer()
      }
      
      // make the layer the same size as the container view
      //layer.frame = videoViewContainer.bounds
      
      // make the video fill the layer as much as possible while keeping its aspect size
//      layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//
      // add the layer to the container view
      //videoViewContainer.layer.addSublayer(layer)
      
      if let videoLayer = videoLayer {
        videoLayer.frame = previewImageView.bounds
        previewImageView.layer.addSublayer(videoLayer)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
}

//MARK: - MediaEditView API
extension MediaEditViewController: MediaEditViewControllerApi {
  func setNextStepTitle(_ title: String) {
    nextStepButton.setTitleForAllStates(title)
  }
  
  var selectedImageConfig: ImageRequestConfig {
    return ImageRequestConfig.init(size: previewImageView.bounds.size, contentMode: .aspectFill)
  }
  
  func setVideoLayer(_ layer: CALayer) {
    videoLayer = layer
  }
  
  func setImage(_ image: UIImage) {
    previewImageView.image = image
  }
}

// MARK: - MediaEditView Viper Components API
fileprivate extension MediaEditViewController {
    var presenter: MediaEditPresenterApi {
        return _presenter as! MediaEditPresenterApi
    }
}

//MARK:- Helpers

extension MediaEditViewController {
  fileprivate func setupView() {
    mediaEditModesCollectionView.delegate = self
    mediaEditModesCollectionView.dataSource = self
  }
  
  fileprivate func setupAppearance() {
    let itemsCount = UIConstants.MediaEditModesCollectionView.numberOfItemsOnPage
    let itemWidth = mediaEditModesCollectionView.bounds.width / itemsCount
    let size = CGSize(width: itemWidth, height: mediaEditModesCollectionView.bounds.height)
    
    guard let layout = mediaEditModesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    
    layout.itemSize = size
    layout.minimumLineSpacing = UIConstants.MediaEditModesCollectionView.insets
    layout.minimumInteritemSpacing = UIConstants.MediaEditModesCollectionView.insets
    layout.sectionInset.left = UIConstants.MediaEditModesCollectionView.insets
  }
  
}

extension MediaEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfEditModeSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfEditModeItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let id = MediaEditModeCollectionViewCell.identifier
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! MediaEditModeCollectionViewCell
    
    let vm = presenter.editModeItemViewModelAt(indexPath)
    cell.setViewModel(vm)
    return cell
  }
}

fileprivate enum UIConstants {
  enum MediaEditModesCollectionView {
    static let numberOfItemsOnPage: CGFloat = 6.0
    static let insets: CGFloat = 0.0
  }
}
