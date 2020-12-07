//
//  SearchResultDetailContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - SearchResultDetailContainerPresenter Class
final class SearchResultDetailContainerPresenter: Presenter {
  fileprivate var currentSegment: SearchResultDetailContainer.PostsSegments = .grid
  
  override func presentInitialState() {
    super.presentInitialState()
    viewController.scrollToTop()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    interactor.initialFetchData()
  }
}

// MARK: - SearchResultDetailContainerPresenter API
extension SearchResultDetailContainerPresenter: SearchResultDetailContainerPresenterApi {
  func presentPlace(_ place: LocationProtocol) {
    router.presentPlaceDetail(viewController.topSectionContainerView, for: place)
    viewController.setNavigationBarTitle(place.locationDescription)
    switchTo(currentSegment, for: place)
    viewController.setSegmentSelected(currentSegment)
  }
  
  func presentTag(_ tag: TagProtocol) {
    router.presentTagDetail(viewController.topSectionContainerView, for: tag)
    viewController.setNavigationBarTitle("#\(tag.cleanTagString)")
    switchTo(currentSegment, for: tag)
    viewController.setSegmentSelected(currentSegment)
  }
  
  func handleSwitchTo(_ segment: SearchResultDetailContainer.PostsSegments) {
    switch interactor.contentType {
    case .relatedPostsForTag(let tag):
      switchTo(segment, for: tag)
    case .relatedPostsForTagString:
      guard let tag = interactor.fetchedTag else {
        return
      }
      switchTo(segment, for: tag)
    case .placeRelatedPosts(let place):
      switchTo(segment, for: place)
    }
    
    viewController.setSegmentSelected(currentSegment)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - UserProfileContainer Viper Components
fileprivate extension SearchResultDetailContainerPresenter {
  var viewController: SearchResultDetailContainerViewControllerApi {
    return _viewController as! SearchResultDetailContainerViewControllerApi
  }
  var interactor: SearchResultDetailContainerInteractorApi {
    return _interactor as! SearchResultDetailContainerInteractorApi
  }
  var router: SearchResultDetailContainerRouterApi {
    return _router as! SearchResultDetailContainerRouterApi
  }
}


//MARK:- Helpers

extension SearchResultDetailContainerPresenter {
  fileprivate func switchTo(_ segment: SearchResultDetailContainer.PostsSegments, for tag: TagProtocol) {
    currentSegment = segment
    switch segment {
    case .listing:
      router.presentPostsIn(viewController.bottomSectionContainerView, for: tag)
    case .grid:
      router.presentPostsGridIn(viewController.bottomSectionContainerView, for: tag)
    }
  }
  
  fileprivate func switchTo(_ segment: SearchResultDetailContainer.PostsSegments, for place: LocationProtocol) {
    currentSegment = segment
    switch segment {
    case .listing:
      router.presentPostsIn(viewController.bottomSectionContainerView, for: place)
    case .grid:
      router.presentPostsGridIn(viewController.bottomSectionContainerView, for: place)
    }
  }
}
