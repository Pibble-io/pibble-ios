//
//  MediaPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

// MARK: - MediaPickPresenter Class
final class MediaPickPresenter: Presenter {
  fileprivate weak var delegate: MediaPickDelegateProtocol?
  
  fileprivate enum IndecesHelper {
    static let firstMediaItemIndexPath = IndexPath(item: 0, section: 0)
  }
  
  fileprivate var config: MediaPick.Config {
    return interactor.config
  }
  
  fileprivate var isAlbumPickerHidden: Bool = true {
    didSet {
      viewController.setMediaAlbumPickScreenContainerHidden(isAlbumPickerHidden, animated: true)
    }
  }
  
  fileprivate var selectedItems: Set<IndexPath> = Set()
  fileprivate var selectedItemsArray: [IndexPath] = []
  fileprivate var cropInsetsForItems: [IndexPath: MediaPick.CropConfig] = [:]
  
  fileprivate var currentSelectedItem: IndexPath? {
    didSet {
      guard let index = currentSelectedItem else {
        return
      }
      
      guard index != oldValue else {
        return
      }
      
      interactor.requestMediaFor(index, config: viewController.selectedImageConfig) { [weak self] image, resizeImage, videoPlayerLayer, _ in
        guard let loadedImage = image, let loadedResizeImage = resizeImage else {
          return
        }
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.viewController.setSelectedItem(loadedImage, resizedImage: loadedResizeImage, videoLayer: videoPlayerLayer, crop: strongSelf.cropInsetsForItems[index])
      }
    }
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initalFetchData()
    viewController.reloadCollection()
    viewController.setNextStageEnabled(selectedItems.count > 0)
    viewController.setNavigationBarButtonsStyleFor(delegate?.presentationStyle() ?? .push)
    viewController.setMediaAlbumPickScreenContainerHidden(true, animated: false)
    let albumTitle = albumTitleFor(interactor.currentPickedMediaAlbum)
    viewController.setCurrentMediaAlbumTitle(albumTitle)
    
    
    switch config {
    case .singleImageItem:
      viewController.setMediaAlbumSelectionViewHidden(true)
    case .multipleItems:
      viewController.setMediaAlbumSelectionViewHidden(false)
    case .images:
      viewController.setMediaAlbumSelectionViewHidden(true)
    }
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    selectFirstIfExists()
  }
  
  override func viewDidDisappear() {
    super.viewDidDisappear()
    interactor.dropCachedData()
  }
  
  init(delegate: MediaPickDelegateProtocol) {
    self.delegate = delegate
  }
}

// MARK: - MediaPickPresenter API
extension MediaPickPresenter: MediaPickPresenterApi {
  func handleTrimCurrentItemConfirmation() {
    
  }
  
  func handleTrimCurrentItemCancelSelection() {
    guard let indexPath = currentSelectedItem else {
      return
    }
    
    handleItemSelectionAt(indexPath)
  }
  
  func presentVideoLengthWarningForItemAt(_ indexPath: IndexPath, maxVideoLength: Double) {
    let alertMessage = MediaPick.Strings.maxVideoLengthWarning(maxVideoLength)
    viewController.showTrimVideoAlertWith(alertMessage)
  }
  
  func handlePickAlbumAction() {
    guard isAlbumPickerHidden else {
      isAlbumPickerHidden = !isAlbumPickerHidden
      return
    }
    
    router.routeToMediaAlbumPick(with: self, in: viewController.mediaAlbumPickScreenContainerView)
    isAlbumPickerHidden = !isAlbumPickerHidden
  }
  
  func handleSelectedImageCropChange(_ crop: MediaPick.CropConfig) {
    guard let currentItem = currentSelectedItem else {
      return
    }
    
    cropInsetsForItems[currentItem] = crop
  }
  
  func presentReload() {
    viewController.reloadCollection()
    selectFirstIfExists()
  }
  
  func handleNextStepAciton() {
    let assets = selectedItemsArray
      .map { LibraryAsset(asset: interactor.itemAt($0),
                          crop: cropInsetsForItems[$0]?.perCentEdgeInsets ?? UIEdgeInsets.zero)
    }
    
    guard assets.count > 0 else {
      return
    }
   
    delegate?.didSelectedMediaAssets(assets)
  }
  
  func handleMediaEditNextStepActionFor(_ presenter: PresenterProtocol, outputAsset: MediaType) {
     AppLogger.debug("handleNextStepActionWithOutput")
    presenter._router.dismiss()
  }

  func handleEditAciton() {
    guard let currentSelectedItem = currentSelectedItem else {
      return
    }
    
    let asset = interactor.itemAt(currentSelectedItem)
    router.routeToMediaEditWith(asset)
  }
  
  func itemViewModelFor(_ indexPath: IndexPath) -> MediaPick.MediaItemType {
    let requestFunc = requestItemViewModelFor
    return MediaPick.MediaItemType.image(requestFunc)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  fileprivate func requestItemViewModelFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping MediaPickItemCompletion) {
    var durationString = ""
    
    if let duration = interactor.durationForMediaAt(indexPath) {
      durationString = duration.formattedMinutesSecondsTimeString
    }
   
    interactor.requestImageFor(indexPath, config: config) { [weak self] (image, resizedImage, idx) in
      guard let strongSelf = self else {
        return
      }
      
      let isSelected = strongSelf.selectedItems.contains(idx)
      var count = ""
      if isSelected {
        if let countIndex = strongSelf.selectedItemsArray.index(of: idx)  {
          count = String(describing: countIndex + 1)
        }
      }
      
      let vm = MediaPick
                .MediaItemViewModel(image: image ?? UIImage(),
                                                      isSelected: isSelected,
                                                      duration: durationString,
                                                      count: count)
      
      result(vm, idx)
    }
  }
  
  func handlePrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {
    interactor.prepareItemsAt(indexPaths, config: config)
  }
  
  func handleCancelPrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {
    interactor.dropPreparedItemsAt(indexPaths, config: config)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func handleItemSelectionAt(_ indexPath: IndexPath) {
    guard !selectedItems.contains(indexPath) else {
      if currentSelectedItem == indexPath {
        cropInsetsForItems.removeValue(forKey: indexPath)
        selectedItems.remove(indexPath)
        if let idx = selectedItemsArray.index(of: indexPath) {
          let indeces = selectedItemsArray[idx..<selectedItemsArray.count]
            .map { return $0 }
          selectedItemsArray.remove(at: idx)
          viewController.reloadItemsAt(indeces)
        }
      }
      
      currentSelectedItem = indexPath
      viewController.setNextStageEnabled(selectedItems.count > 0)
      return
    }
    
    guard interactor.checkIsItemAvailableAt(indexPath) else {
      return
    }
    
    switch config {
    case .singleImageItem:
      var reloadItems = Array(selectedItems)
      reloadItems.append(indexPath)
      selectedItems.removeAll()
      selectedItems.insert(indexPath)
      selectedItemsArray = [indexPath]
      viewController.reloadItemsAt(reloadItems)
    case .multipleItems(let limit), .images(let limit):
      if selectedItems.count < limit {
        selectedItems.insert(indexPath)
        selectedItemsArray.append(indexPath)
        viewController.reloadItemsAt([indexPath])
      }
    }
    
    currentSelectedItem = indexPath
    viewController.setNextStageEnabled(selectedItems.count > 0)
  }
}

//MARK:- Helpers

extension MediaPickPresenter {
  fileprivate func albumTitleFor(_ album: MediaAlbumPick.Album) -> String {
    switch album {
    case .none:
      return MediaPick.Strings.allPhotos.localize().capitalized
    case .smartAlbum(let collection):
      return collection.localizedTitle?.capitalized ?? ""
    case .userCollection(let collection):
      return collection.localizedTitle?.capitalized ?? ""
    }
  }
  
  fileprivate func selectedItemsTitle() -> String {
    return "\(selectedItems.count) / \(config.pickItemsLimit)"
  }
  
  fileprivate func selectFirstIfExists() {
    guard interactor.numberOfItemsInSection(IndecesHelper.firstMediaItemIndexPath.section) > 0 else {
      return
    }
  
    currentSelectedItem = IndecesHelper.firstMediaItemIndexPath
  }
}

// MARK: - MediaPick Viper Components
fileprivate extension MediaPickPresenter {
    var viewController: MediaPickViewControllerApi {
        return _viewController as! MediaPickViewControllerApi
    }
    var interactor: MediaPickInteractorApi {
        return _interactor as! MediaPickInteractorApi
    }
    var router: MediaPickRouterApi {
        return _router as! MediaPickRouterApi
    }
}

extension MediaPickPresenter: MediaAlbumPickDelegateProtocol {
  func didSelectMediaAlbum(_ album: MediaAlbumPick.Album) {
    selectedItems.removeAll()
    selectedItemsArray = []
    cropInsetsForItems = [:]
    currentSelectedItem = nil
    interactor.setPickedMediaAlbum(album)
    
    let albumTitle = albumTitleFor(interactor.currentPickedMediaAlbum)
    viewController.setCurrentMediaAlbumTitle(albumTitle)
    selectFirstIfExists()
    viewController.setMediaAlbumPickScreenContainerHidden(true, animated: true)
  }
}


