//
//  SearchResultDetailContainerModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - SearchResultDetailContainerRouter API
protocol SearchResultDetailContainerRouterApi: RouterProtocol {
  func presentPostsIn(_ container: UIView, for tag: TagProtocol)
  func presentPostsGridIn(_ container: UIView, for tag: TagProtocol)
  
  func presentPostsIn(_ container: UIView, for place: LocationProtocol)
  func presentPostsGridIn(_ container: UIView, for place: LocationProtocol)
  
  func presentTagDetail(_ container: UIView, for tag: TagProtocol)
  func presentPlaceDetail(_ container: UIView, for place: LocationProtocol)
  
  func removeBottomContainer()
}

//MARK: - SearchResultDetailContainerView API
protocol SearchResultDetailContainerViewControllerApi: ViewControllerProtocol, EmbedableViewControllerDelegate {
  var topSectionContainerView: UIView { get }
  var bottomSectionContainerView: UIView { get }
  var topSectionEmbeddableViewController: EmbedableViewController? { get set }
  var bottmoSectionEmbeddableViewController: EmbedableViewController? { get set }
  
  //  func setHideButtonHidden(_ hidden: Bool)
  func setNavigationBarTitle(_ title: String)
  func setSegmentSelected(_ segment: SearchResultDetailContainer.PostsSegments)
  
  func scrollToTop()
}

//MARK: - SearchResultDetailContainerPresenter API
protocol SearchResultDetailContainerPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func presentPlace(_ place: LocationProtocol)
  func presentTag(_ tag: TagProtocol)
  
  func handleSwitchTo(_ segment: SearchResultDetailContainer.PostsSegments)
}

//MARK: - SearchResultDetailContainerInteractor API
protocol SearchResultDetailContainerInteractorApi: InteractorProtocol { 
  func initialFetchData()
  var contentType: SearchResultDetailContainer.ContentType { get }
  var fetchedTag: TagProtocol? { get }
}

