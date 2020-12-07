//
//  MediaPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

typealias MediaResult = ((MediaPick.MediaItemType, IndexPath) -> Void)

typealias ImageRequestResult = ((UIImage?, IndexPath) -> Void)
typealias ImageRequestWithProcessedResult = ((UIImage?, UIImage?, IndexPath) -> Void)
typealias MediaRequestWithProcessedResult = ((UIImage?, UIImage?, AVPlayerLayer?, IndexPath) -> Void)

//MARK: - MediaPickRouter API
protocol MediaPickRouterApi: RouterProtocol {
  func routeToCameraCapture()
  func routeToMediaEditWith(_ asset: PHAsset)
  func routeToMediaAlbumPick(with delegate: MediaAlbumPickDelegateProtocol, in container: UIView)
}

//MARK: - MediaPickView API
protocol MediaPickViewControllerApi: ViewControllerProtocol {
  func setSelectedItem(_ originalSizeImage: UIImage,
                       resizedImage: UIImage,
                       videoLayer: AVPlayerLayer?,
                       crop: MediaPick.CropConfig?)
  
  func reloadItemsAt(_ indexPaths: [IndexPath])
  
  func reloadCollection()
  
  var selectedImageConfig: ImageRequestConfig { get }
  
  func setNextStageEnabled(_ isEnabled: Bool)
  
  func setNavigationBarButtonsStyleFor(_ presentation: MediaPick.PresentationStyle)
  
  func setMediaAlbumPickScreenContainerHidden(_ hidden: Bool, animated: Bool)
  
  func setCurrentMediaAlbumTitle(_ text: String)
  
  func setMediaAlbumSelectionViewHidden(_ hidden: Bool)
  
  var mediaAlbumPickScreenContainerView: UIView { get }
  
  func showTrimVideoAlertWith(_ message: String)
  
}

//MARK: - MediaPickPresenter API
protocol MediaPickPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleEditAciton()
  func handleNextStepAciton()
  func handlePickAlbumAction()
  
  func handleTrimCurrentItemConfirmation()
  func handleTrimCurrentItemCancelSelection()
  
  func numberOfSections() -> Int
  
  func numberOfItemsInSection(_ section: Int) -> Int
 
  func itemViewModelFor(_ indexPath: IndexPath) -> MediaPick.MediaItemType
  
  func handleItemSelectionAt(_ indexPath: IndexPath)
  
  func handlePrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func handleCancelPrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func presentReload()
  func handleSelectedImageCropChange(_ crop: MediaPick.CropConfig)
  
  func presentVideoLengthWarningForItemAt(_ indexPath: IndexPath, maxVideoLength: Double)
  

  
}

//MARK: - MediaPickInteractor API
protocol MediaPickInteractorApi: InteractorProtocol {
  var config: MediaPick.Config { get }
  
  var currentPickedMediaAlbum: MediaAlbumPick.Album { get }
  
  func setPickedMediaAlbum(_ album: MediaAlbumPick.Album)
  
  func initalFetchData()
  
  func dropCachedData()
  
  func numberOfSections() -> Int
  
  func numberOfItemsInSection(_ section: Int) -> Int
  
  func requestImageFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping ImageRequestWithProcessedResult)
  
  func requestMediaFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping MediaRequestWithProcessedResult)
  
  func prepareItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func dropPreparedItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func durationForMediaAt(_ indexPath: IndexPath) -> TimeInterval?
  
  func itemAt(_ indexPath: IndexPath) -> PHAsset
  
  func checkIsItemAvailableAt(_ indexPath: IndexPath) -> Bool
  
}

protocol MediaPickItemViewModelProtocol {
  var image: UIImage { get }
  var isSelected: Bool { get }
  var duration: String { get }
  var count: String { get }
}

protocol MediaPickDelegateProtocol: class {
  func didSelectedMediaAssets(_ assets: [LibraryAsset])
  func presentationStyle() -> MediaPick.PresentationStyle
}
