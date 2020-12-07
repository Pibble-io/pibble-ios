//
//  MediaPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

//MARK: MediaPickView Class
final class MediaPickViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var mediaItemsCollectionView: UICollectionView!
  @IBOutlet weak var selectedImageView: UIImageView!
  @IBOutlet weak var mediaAlbumPickerContainerView: UIView!
  
  @IBOutlet weak var upperSectionDimView: UIView!
  
  @IBOutlet weak var zoomButton: UIButton!
  
  @IBOutlet weak var currentAlbumLabel: UILabel!
  
  @IBOutlet weak var albumPickView: UIView!
  
  @IBOutlet weak var upperSectionBackgroundViewTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var imageGridLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageGridViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageGridViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageGridViewRightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var upperSectionBackgroundView: UIView!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var nextStageButton: UIButton!
  @IBOutlet weak var hideButton: UIButton!
  
  @IBOutlet weak var upperSectionDragView: UIView!
  @IBOutlet weak var imageGridView: UIView!
  
  //IBActions
  
  @IBAction func makeSquareAction(_ sender: Any) {
    changeSquareZoom()
  }
 
  @IBAction func pickAlbumAction(_ sender: Any) {
    presenter.handlePickAlbumAction()
  }
  
  @IBAction func editAction(_ sender: Any) {
    presenter.handleEditAciton()
  }
  
  @IBAction func nextStepAction(_ sender: Any) {
    presenter.handleNextStepAciton()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Private properties
  
  fileprivate var videoLayer: AVPlayerLayer?
  fileprivate var isImageGridViewAnimating = false
  
  fileprivate var isUpperSectionUserInteractionEnabled: Bool = true {
    didSet {
      zoomButton.isEnabled = isUpperSectionUserInteractionEnabled
      selectedImagePinch.isEnabled = isUpperSectionUserInteractionEnabled
      selectedImagePan.isEnabled = isUpperSectionUserInteractionEnabled
      selectedImageTap.isEnabled = isUpperSectionUserInteractionEnabled
    }
  }
  
  fileprivate var upperSectionAlpha: CGFloat = 1.0 {
    didSet {
      upperSectionDimView.alpha = (1.0 - upperSectionAlpha)
      isUpperSectionUserInteractionEnabled = upperSectionDimView.alpha.isZero
      //selectedImageView.alpha = upperSectionAlpha
      //editButton.alpha = upperSectionAlpha
    }
  }
  
  fileprivate lazy var imageConfig = {
    return ImageRequestConfig(size: mediaItemSize, contentMode: PHImageContentMode.aspectFill)
  }()
  
  fileprivate lazy var selectedImagePinch: UIPinchGestureRecognizer = {
    let gesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handleSelectedImageViewPinchGesture(_:)))
    gesture.delegate = self
    return gesture
  }()
  
  fileprivate var selectedImageViewFrameObservation: NSKeyValueObservation?
  fileprivate var selectedImageViewTransformObservation: NSKeyValueObservation?
  fileprivate var selectedImageViewCenterObservation: NSKeyValueObservation?
  
  deinit {
    selectedImageViewFrameObservation = nil
    selectedImageViewTransformObservation = nil
    selectedImageViewCenterObservation = nil
  }
  
  fileprivate lazy var collectionViewPan: UIPanGestureRecognizer = {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleCollectionViewPanGesutre(_:)))
    gesture.delegate = self
    return gesture
  }()
  
  
  fileprivate lazy var upperSectionPan: UIPanGestureRecognizer = {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleDragPanGestureAction(_:)))
    gesture.delegate = self
    return gesture
  }()
  
  fileprivate lazy var selectedImagePan: UIPanGestureRecognizer = {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleSelectedImageViewPanGesture(_:)))
    gesture.delegate = self
    return gesture
  }()
  
  fileprivate lazy var selectedImageTap: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectedImageViewTapGesture(_:)))
    gesture.delegate = self
    return gesture
  }()
  
  fileprivate var mediaItemSize: CGSize {
    let space = UIConstants.MediaCollectionView.mediaColumnsInnerSpacing * CGFloat(UIConstants.MediaCollectionView.numberOfColumns - 1)
    
    let width = (mediaItemsCollectionView.bounds.width - space) / CGFloat(UIConstants.MediaCollectionView.numberOfColumns)
    return CGSize(width: width, height: width)
  }
  
  //MARK:- Properties
  
  var selectedImageConfig: ImageRequestConfig {
    let selectedImageViewSize = CGSize(width: upperSectionBackgroundView.bounds.width * 3.0, height: upperSectionBackgroundView.bounds.height * 3.0)
    return ImageRequestConfig(size: selectedImageViewSize, contentMode: PHImageContentMode.aspectFit)
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupAppearance()
    mediaItemsCollectionView.reloadData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    videoLayer?.player?.pause()
  }
}

//MARK: - MediaPickView API
extension MediaPickViewController: MediaPickViewControllerApi {
  func showTrimVideoAlertWith(_ message: String) {
    let alertController = UIAlertController(title: "", message: message, safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let confirm = UIAlertAction(title: MediaPick.Strings.confirm.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleTrimCurrentItemConfirmation()
    }
    
    let cancel = UIAlertAction(title: MediaPick.Strings.cancel.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleTrimCurrentItemCancelSelection()
    }
    
    alertController.addAction(confirm)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func setMediaAlbumSelectionViewHidden(_ hidden: Bool) {
    albumPickView.isHidden = hidden
  }
  
  func setCurrentMediaAlbumTitle(_ text: String) {
    currentAlbumLabel.text = text
  }
  
  var mediaAlbumPickScreenContainerView: UIView {
    return mediaAlbumPickerContainerView
  }
  
  func setMediaAlbumPickScreenContainerHidden(_ hidden: Bool, animated: Bool) {
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    guard animated else {
      mediaAlbumPickerContainerView.alpha = alpha
      mediaAlbumPickerContainerView.isHidden = hidden
      return
    }
    
    if !hidden {
      mediaAlbumPickerContainerView.isHidden = hidden
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.mediaAlbumPickerContainerView.alpha = alpha
    }) { [weak self] (_) in
      self?.mediaAlbumPickerContainerView.isHidden = hidden
    }
  }
  
  func setNavigationBarButtonsStyleFor(_ presentation: MediaPick.PresentationStyle) {

    switch presentation {
    case .push:
      nextStageButton.setTitleForAllStates(MediaPick.Strings.nextButtonTitle.localize())
    case .present:
      nextStageButton.setTitleForAllStates(MediaPick.Strings.doneButtonTitle.localize())
    }
  }
  
  func setNextStageEnabled(_ isEnabled: Bool) {
    nextStageButton.isEnabled = isEnabled
  }
  
  func reloadCollection() {
    mediaItemsCollectionView.reloadData()
  }
  
  func reloadItemsAt(_ indexPaths: [IndexPath]) {
    mediaItemsCollectionView.reloadItems(at: indexPaths)
  }
  
  
  func changeSquareZoom() {
    guard selectedImageView.transform == CGAffineTransform.identity else {
      UIView.animate(withDuration: 0.3, animations: { [weak self] in
        guard let strongSelf = self else {
          return
        }
        strongSelf.selectedImageView.transform = CGAffineTransform.identity
        strongSelf.selectedImageView.center = CGPoint(x: strongSelf.upperSectionBackgroundView.bounds.midX,
                                           y: strongSelf.upperSectionBackgroundView.bounds.midY)
      }) { [weak self] (_) in
        self?.checkSelectedImageViewBounds()
      }
      
     
      
      return
    }
    
    let isPortrait = selectedImageView.bounds.width < selectedImageView.bounds.height
    let scale = isPortrait ?
      upperSectionBackgroundView.bounds.width / selectedImageView.bounds.width :
      upperSectionBackgroundView.bounds.height / selectedImageView.bounds.height
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      strongSelf.selectedImageView.transform = strongSelf.selectedImageView.transform.scaledBy(x: scale, y: scale)
    }
  }
  
  
  func setSelectedItem(_ originalSizeImage: UIImage, resizedImage: UIImage, videoLayer: AVPlayerLayer?, crop:
    MediaPick.CropConfig?) {
    setUpperSectionPresentationHidden(false)
    selectedImageView.image = originalSizeImage
    guard let crop = crop else {
      let isPortrait = resizedImage.size.height > resizedImage.size.width
      let ratio = resizedImage.size.height / resizedImage.size.width
      let originalImageRatio = originalSizeImage.size.height / originalSizeImage.size.width
      let visibleHeight = isPortrait ?
        upperSectionBackgroundView.bounds.height :
        upperSectionBackgroundView.bounds.height * ratio
      
      let visibleWidth = !isPortrait ?
        upperSectionBackgroundView.bounds.width :
        upperSectionBackgroundView.bounds.height / ratio
      
      let selectedImageViewHeight = !isPortrait ?
        visibleHeight :
        visibleWidth * originalImageRatio
      
      let selectedImageViewWidth = isPortrait ?
        visibleWidth :
        visibleHeight / originalImageRatio
      
      selectedImageView.transform = CGAffineTransform.identity
      selectedImageView.center = CGPoint(x: upperSectionBackgroundView.bounds.midX,
                                         y: upperSectionBackgroundView.bounds.midY)
      selectedImageView.bounds = CGRect(origin: CGPoint.zero,
                                       size: CGSize(width: selectedImageViewWidth,
                                                    height: selectedImageViewHeight))
 
      selectedImageView.contentMode = .scaleToFill
      checkSelectedImageViewBounds()
      setVideoLayer(videoLayer)
      return
    }
    
    selectedImageView.bounds = crop.bounds
    selectedImageView.center = crop.center
    selectedImageView.transform = crop.transform
    checkSelectedImageViewBounds()
    setVideoLayer(videoLayer)
  }
  
  fileprivate func setVideoLayer(_ newVideoLayer: AVPlayerLayer?) {
    videoLayer?.player?.pause()
    videoLayer?.removeFromSuperlayer()
    videoLayer = newVideoLayer
    selectedImagePinch.isEnabled = newVideoLayer == nil
    guard let video = videoLayer else {
      return
    }
    
    video.frame = selectedImageView.bounds
    video.player?.setCurrentlyPlaying()
    videoLayer?.videoGravity = AVLayerVideoGravity.resize
    selectedImageView.layer.addSublayer(video)
  }
}

//MARK: - Helpers
extension MediaPickViewController {
  func setImageGridVisible(_ visible: Bool, animated: Bool = false) {
    let alpha: CGFloat = visible ? 1.0 : 0.0
    guard animated else {
      imageGridView.alpha = alpha
      return
    }
    
    let duration: TimeInterval = 0.3
    guard !isImageGridViewAnimating else {
      imageGridView.alpha = alpha
      return
    }
    
    isImageGridViewAnimating = true
    
    UIView.animate(withDuration: duration, animations: { [weak self] in
      self?.imageGridView.alpha = alpha
    }) { [weak self] (_) in
      self?.isImageGridViewAnimating = false
    }
  }
  
  func updateSelectedImageGridConstraints() {
    imageGridLeftConstraint.constant = selectedImageView.frame.origin.x
    imageGridViewTopConstraint.constant = selectedImageView.frame.origin.y
    imageGridViewBottomConstraint.constant = upperSectionBackgroundView.bounds.maxY - selectedImageView.frame.maxY
    imageGridViewRightConstraint.constant = upperSectionBackgroundView.bounds.maxX - selectedImageView.frame.maxX
  }
  
  func evaluateCropInsetsFor(imageRect: CGRect, canvasRect: CGRect) -> UIEdgeInsets {
    let left = abs(min(imageRect.origin.x, 0))
    let top = abs(min(imageRect.origin.y, 0))
    let right = max(imageRect.maxX - canvasRect.maxX, 0)
    let bottom = max(imageRect.maxY - canvasRect.maxY, 0)
    
    let leftPerCent = 100 * (left / imageRect.width)
    let topPerCent = 100 * (top / imageRect.height)
    let rightPerCent = 100 * (right / imageRect.width)
    let bottomPerCent = 100 * (bottom / imageRect.height)
    
    return UIEdgeInsets(top: topPerCent, left: leftPerCent, bottom: bottomPerCent, right: rightPerCent)
  }
  
  func evaluateImageRectFor(originalImageRect: CGRect, cropPerCent: UIEdgeInsets, canvasRect: CGRect) -> CGRect {
    return CGRect.zero
    
//    let left = abs(min(imageRect.origin.x, 0))
//    let top = abs(min(imageRect.origin.y, 0))
//    let right = max(imageRect.maxX - canvasRect.maxX, 0)
//    let bottom = max(imageRect.maxY - canvasRect.maxY, 0)
//
//    let leftPerCent = 100 * (left / imageRect.width)
//    let topPerCent = 100 * (top / imageRect.height)
//    let rightPerCent = 100 * (right / imageRect.width)
//    let bottomPerCent = 100 * (bottom / imageRect.height)
//
//    return UIEdgeInsets(top: topPerCent, left: leftPerCent, bottom: bottomPerCent, right: rightPerCent)
  }
  
  func setUpperSectionPresentationHidden(_ hidden: Bool) {
    upperSectionBackgroundViewTopConstraint.constant = hidden ? UIConstants.Constraints.selectedItemBackgroundViewTopConstraintMin(upperSectionBackgroundView.bounds.height) :
      UIConstants.Constraints.selectedItemBackgroundViewTopConstraintMax
    let alpha = hidden ? UIConstants.Colors.selectedImageMinAlpha :
      UIConstants.Colors.selectedImageMaxAlpha
    UIView.animate(withDuration: 0.15) { [weak self] in
      self?.upperSectionAlpha = alpha
      self?.view.layoutIfNeeded()
    }
  }
  
  func setupLayout() {
    view.clipsToBounds = true
  }
  
  
  
  func setupAppearance() {
    setImageGridVisible(false)
  }
  
  func setupView() {
    mediaItemsCollectionView.dataSource = self
    mediaItemsCollectionView.delegate = self
    mediaItemsCollectionView.prefetchDataSource = self
    mediaItemsCollectionView.isPrefetchingEnabled = true
   
    upperSectionDragView.addGestureRecognizer(upperSectionPan)
    mediaItemsCollectionView.addGestureRecognizer(collectionViewPan)
    selectedImageView.addGestureRecognizer(selectedImagePan)
    selectedImageView.addGestureRecognizer(selectedImagePinch)
    selectedImageView.addGestureRecognizer(selectedImageTap)
    
    selectedImageViewFrameObservation = selectedImageView.observe(\UIImageView.frame) { [weak self] (_, _) in
      guard let strongSelf = self else {
        return
      }
      
      let perCentEdgeInsets = strongSelf.evaluateCropInsetsFor(imageRect: strongSelf.selectedImageView.frame, canvasRect: strongSelf.upperSectionBackgroundView.bounds)
      
      let crop = MediaPick.CropConfig(center: strongSelf.selectedImageView.center,
                                      bounds: strongSelf.selectedImageView.bounds,
                                      transform: strongSelf.selectedImageView.transform,
                                      perCentEdgeInsets: perCentEdgeInsets)
      
      strongSelf.presenter.handleSelectedImageCropChange(crop)
      strongSelf.updateSelectedImageGridConstraints()
    }
    
    selectedImageViewCenterObservation = selectedImageView.observe(\UIImageView.center) { [weak self] (_, _) in
      guard let strongSelf = self else {
        return
      }
      
      let perCentEdgeInsets = strongSelf.evaluateCropInsetsFor(imageRect: strongSelf.selectedImageView.frame, canvasRect: strongSelf.upperSectionBackgroundView.bounds)
      
      let crop = MediaPick.CropConfig(center: strongSelf.selectedImageView.center,
                                      bounds: strongSelf.selectedImageView.bounds,
                                      transform: strongSelf.selectedImageView.transform,
                                      perCentEdgeInsets: perCentEdgeInsets)
      
      strongSelf.presenter.handleSelectedImageCropChange(crop)
      strongSelf.updateSelectedImageGridConstraints()
    }
    
    selectedImageViewTransformObservation = selectedImageView.observe(\UIImageView.transform) { [weak self] (_, _) in
      guard let strongSelf = self else {
        return
      }
      
      let perCentEdgeInsets = strongSelf.evaluateCropInsetsFor(imageRect: strongSelf.selectedImageView.frame, canvasRect: strongSelf.upperSectionBackgroundView.bounds)
      
      let crop = MediaPick.CropConfig(center: strongSelf.selectedImageView.center,
                           bounds: strongSelf.selectedImageView.bounds,
                           transform: strongSelf.selectedImageView.transform,
                           perCentEdgeInsets: perCentEdgeInsets)
      
      strongSelf.presenter.handleSelectedImageCropChange(crop)
      strongSelf.updateSelectedImageGridConstraints()
    }
  }
  
  fileprivate func tranlateIntervalValue<T: FloatingPoint>(_ value: T, from: (min: T, max: T), to: (min: T, max: T)) -> T {
   
    let k = (to.max - to.min) / (from.max - from.min)
    let b = to.min - (k * from.min)
    
    let translatedValue = k * value + b
    return translatedValue
  }
}

// MARK: - MediaPickView Viper Components API
fileprivate extension MediaPickViewController {
    var presenter: MediaPickPresenterApi {
        return _presenter as! MediaPickPresenterApi
    }
}


// MARK: - Pan gestures

extension MediaPickViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    
    if gestureRecognizer == selectedImagePinch && otherGestureRecognizer == selectedImagePan {
      return true
    }
    
    if gestureRecognizer == selectedImagePan && otherGestureRecognizer == selectedImagePinch {
      return true
    }
    
    if gestureRecognizer == collectionViewPan || otherGestureRecognizer == collectionViewPan {
      return true
    }
    
    return false
  }
  
  @objc func handleSelectedImageViewPinchGesture(_ sender: UIPinchGestureRecognizer) {
    switch sender.state {
    case .possible:
      break
    case .began:
      setImageGridVisible(true, animated: true)
    case .changed:
      guard let viewToTransform = selectedImageView else {
        return
      }
      
      let pinchCenter = CGPoint(x: sender.location(in: viewToTransform).x - viewToTransform.bounds.midX,
                                y: sender.location(in: viewToTransform).y - viewToTransform.bounds.midY)
      
      let currentScale = viewToTransform.frame.size.width / viewToTransform.bounds.size.width
      var newScale = currentScale * sender.scale
      
      guard newScale < 2.5 else {
        newScale = 2.5
        let transform = viewToTransform.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
          .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        viewToTransform.transform = transform
        sender.scale = 1
        return
      }
      
      let transform = viewToTransform.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
        .scaledBy(x: sender.scale, y: sender.scale)
        .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
      viewToTransform.transform = transform
      sender.scale = 1
    case .ended, .cancelled, .failed:
      guard let viewToTransform = selectedImageView else {
        return
      }
      
      let currentScale = viewToTransform.frame.size.width / viewToTransform.bounds.size.width
      guard currentScale > 1 else {
        sender.scale = 1
        let transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        setImageGridVisible(false, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
          viewToTransform.transform = transform
        }) { [weak self] (_) in
          self?.checkSelectedImageViewBounds()
          
        }
        return
      }
      setImageGridVisible(false, animated: true)
      checkSelectedImageViewBounds()
    }
    
  }
  
  func checkSelectedImageViewBounds() {
    if selectedImageView.frame.width < upperSectionBackgroundView.frame.width {
      if selectedImageView.frame.minX > 0 || selectedImageView.frame.maxX < upperSectionBackgroundView.frame.width {
        UIView.animate(withDuration: 0.3) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.selectedImageView.center.x = strongSelf.upperSectionBackgroundView.bounds.midX
          strongSelf.upperSectionBackgroundView.layoutIfNeeded()
        }
      }
    } else {
      if selectedImageView.frame.minX > 0  {
        UIView.animate(withDuration: 0.3) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.selectedImageView.frame.origin.x = 0
          strongSelf.upperSectionBackgroundView.layoutIfNeeded()
        }
      }
      
      if selectedImageView.frame.maxX < upperSectionBackgroundView.frame.width  {
        let sizeDelta = selectedImageView.frame.width - upperSectionBackgroundView.frame.width
        UIView.animate(withDuration: 0.3) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.selectedImageView.frame.origin.x = -sizeDelta
          strongSelf.upperSectionBackgroundView.layoutIfNeeded()
        }
      }
    }
    
    if selectedImageView.frame.height < upperSectionBackgroundView.frame.height {
      if selectedImageView.frame.minY > 0 || selectedImageView.frame.maxY < upperSectionBackgroundView.frame.height {
        UIView.animate(withDuration: 0.3) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.selectedImageView.center.y = strongSelf.upperSectionBackgroundView.bounds.midY
          strongSelf.upperSectionBackgroundView.layoutIfNeeded()
        }
      }
    } else {
      if selectedImageView.frame.minY > 0  {
        UIView.animate(withDuration: 0.3) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.selectedImageView.frame.origin.y = 0
          strongSelf.upperSectionBackgroundView.layoutIfNeeded()
        }
      }
      
      if selectedImageView.frame.maxY < upperSectionBackgroundView.frame.height  {
        let sizeDelta = selectedImageView.frame.height - upperSectionBackgroundView.frame.height
        UIView.animate(withDuration: 0.3) { [weak self] in
          guard let strongSelf = self else {
            return
          }
          
          strongSelf.selectedImageView.frame.origin.y = -sizeDelta
          strongSelf.upperSectionBackgroundView.layoutIfNeeded()
        }
      }
    }
  }
  
  @objc func handleSelectedImageViewTapGesture(_ sender: UIPanGestureRecognizer) {
    guard videoLayer?.player?.timeControlStatus == .playing else {
      videoLayer?.player?.seek(to: CMTime.zero)
      videoLayer?.player?.setCurrentlyPlaying()
      return
    }
    
    videoLayer?.player?.pause()
  }
  
  @objc func handleSelectedImageViewPanGesture(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .possible:
      break
    case .began:
      setImageGridVisible(true, animated: true)
      break
    case .changed:
      let translation = sender.translation(in: upperSectionBackgroundView)
      selectedImageView.center = CGPoint(x: selectedImageView.center.x + translation.x,
                                   y: selectedImageView.center.y + translation.y)
      
      sender.setTranslation(CGPoint.zero, in: selectedImageView)
    case .ended:
      setImageGridVisible(false)
      checkSelectedImageViewBounds()
    case .cancelled:
      setImageGridVisible(false)
      break
    case .failed:
      setImageGridVisible(false)
      break
    }
  }
  
  @objc func handleCollectionViewPanGesutre(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: mediaItemsCollectionView)
    let location = sender.location(in: upperSectionBackgroundView)
    
    let inBoundsOfUpperSectionView = location.y < upperSectionBackgroundView.bounds.height
    let mediaItemsCollectionViewBouncing = mediaItemsCollectionView.contentOffset.y < 0.0
    
    let canMoveUpperSectionView = inBoundsOfUpperSectionView || mediaItemsCollectionViewBouncing
    
    var updatedConstraint = upperSectionBackgroundViewTopConstraint.constant + translation.y
    let constraintMax = UIConstants.Constraints.selectedItemBackgroundViewTopConstraintMax
    let constraintMin = UIConstants.Constraints.selectedItemBackgroundViewTopConstraintMin(upperSectionBackgroundView.bounds.height)
    
    let constraintBorderValue = (2.0 * constraintMax + constraintMin) / 3.0
    updatedConstraint = max(constraintMin, min(updatedConstraint, constraintMax))
   
    let alphaMin = UIConstants.Colors.selectedImageMinAlpha
    let alphaMax = UIConstants.Colors.selectedImageMaxAlpha
 
    let selectedImageViewAlpha = tranlateIntervalValue(updatedConstraint,
                                                  from: (min: constraintMin,
                                                         max: constraintMax),
                                                  to: (min: alphaMin,
                                                       max: alphaMax))
    
    switch sender.state {
    case .changed:
      if canMoveUpperSectionView {
        upperSectionAlpha = selectedImageViewAlpha
        upperSectionBackgroundViewTopConstraint.constant = updatedConstraint
      }
    case .ended, .cancelled:
      upperSectionBackgroundViewTopConstraint.constant = updatedConstraint > constraintBorderValue ? constraintMax : constraintMin
      UIView.animate(withDuration: 0.15) { [weak self] in
        self?.upperSectionAlpha = updatedConstraint > constraintBorderValue ? alphaMax : alphaMin
        self?.view.layoutIfNeeded()
      }
    default:
      break
    }
    
    sender.setTranslation(CGPoint.zero, in: view)
  }
  
  @objc func handleDragPanGestureAction(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: view)
    
    var updatedConstraint = upperSectionBackgroundViewTopConstraint.constant + translation.y
    
    let constraintMax = UIConstants.Constraints.selectedItemBackgroundViewTopConstraintMax
    let constraintMin = UIConstants.Constraints.selectedItemBackgroundViewTopConstraintMin(upperSectionBackgroundView.bounds.height)
    
    let constraintBorderValue = (2.0 * constraintMax + constraintMin) / 3.0
    updatedConstraint = max(constraintMin, min(updatedConstraint, constraintMax))
    
    let alphaMin = UIConstants.Colors.selectedImageMinAlpha
    let alphaMax = UIConstants.Colors.selectedImageMaxAlpha
 
    let selectedImageViewAlpha = tranlateIntervalValue(updatedConstraint,
                                                  from: (min: constraintMin,
                                                         max: constraintMax),
                                                  to: (min: alphaMin,
                                                       max: alphaMax))
    
    switch sender.state {
    case .changed:
      upperSectionBackgroundViewTopConstraint.constant = updatedConstraint
      upperSectionAlpha = selectedImageViewAlpha
    case .ended, .cancelled:
      upperSectionBackgroundViewTopConstraint.constant = updatedConstraint > constraintBorderValue ? constraintMax : constraintMin
      UIView.animate(withDuration: 0.15) { [weak self] in
        self?.upperSectionAlpha = updatedConstraint > constraintBorderValue ? alphaMax : alphaMin
        self?.view.layoutIfNeeded()
      }
    default:
      break
    }
    
    sender.setTranslation(CGPoint.zero, in: view)
  }
}

//MARK:- UICollectionViewDataSourcePrefetching

extension MediaPickViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    presenter.handlePrefetchingItemsAt(indexPaths, config: imageConfig)
  }
  
  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    presenter.handleCancelPrefetchingItemsAt(indexPaths, config: imageConfig)
  }
}

//MARK:- MediaPickViewController, UICollectionViewDelegate

extension MediaPickViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return UIConstants.MediaCollectionView.mediaColumnsInnerSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return UIConstants.MediaCollectionView.mediaColumnsInnerSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return mediaItemSize
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let viewModelType = presenter.itemViewModelFor(indexPath)
    
    switch viewModelType {
    case .image(let viewModelRequest):
      let cellReuseId = MediaPickItemCollectionViewCell.identifier
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! MediaPickItemCollectionViewCell
      cell.indexPath = indexPath
      viewModelRequest(indexPath, imageConfig) { (viewModel, idx) in
        guard cell.indexPath == idx else {
          return
        }
        cell.setViewModel(viewModel)
      }
      return cell
    case .camera(let title):
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MediaPickCameraCollectionViewCell.identifier, for: indexPath) as! MediaPickCameraCollectionViewCell
      cell.setViewModel(title: title)
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter.handleItemSelectionAt(indexPath)
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let selectedImageMinAlpha: CGFloat = 0.0
    static let selectedImageMaxAlpha: CGFloat = 1.0
  }
  
  enum MediaCollectionView {
    static let mediaColumnsInnerSpacing: CGFloat = 1.0
    static let numberOfColumns = 3
  }
  
  
  
  enum Constraints {
    static func selectedItemBackgroundViewTopConstraintMin(_ totalHeight: CGFloat) -> CGFloat {
      let selectedItemBackgroundViewTopConstraintMin: CGFloat = 100.0
      return selectedItemBackgroundViewTopConstraintMin - totalHeight
    }
    
    static let selectedItemBackgroundViewTopConstraintMax: CGFloat = 64.0
  }
}

