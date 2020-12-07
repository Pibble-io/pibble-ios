//
//  DiscoverFeedRootContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

fileprivate enum PresentationStates {
  case searchSegment(DiscoverFeedRootContainer.Segments)
  case discoverFeed
  case searchHistory
}

// MARK: - DiscoverFeedRootContainerPresenter Class
final class DiscoverFeedRootContainerPresenter: Presenter {
  fileprivate weak var searchDelegate: DiscoverFeedRootContainerSearchDelegate?
  fileprivate var lastPresentedSegment: DiscoverFeedRootContainer.Segments = .top
  fileprivate var lastSearchedText: String = ""
  
  fileprivate var presentationState: PresentationStates = .discoverFeed {
    didSet {
      switch presentationState {
      case .searchSegment(let segment):
        if case let PresentationStates.searchSegment(oldSegment) = oldValue, oldSegment == segment {
          return
        }
        
        lastPresentedSegment = segment
        searchDelegate = router.routeTo(segment, insideView: viewController.searchResultsContainerView, delegate: self)
        searchDelegate?.handleSearch(lastSearchedText)
        viewController.setDiscoverContainerHidden(true, animated: true)
        viewController.setButtonSelectedStateFor(segment)
        viewController.setHistoryButtonSelected(false)
        
      case .discoverFeed:
        viewController.setDiscoverContainerHidden(false, animated: true)
        viewController.setHistoryButtonSelected(false)
      case .searchHistory:
        if case PresentationStates.searchHistory = oldValue {
          return
        }
        
        searchDelegate = router.routeToSearchHistory(insideView: viewController.searchResultsContainerView, delegate: self)
        searchDelegate?.handleSearch(lastSearchedText)
        viewController.setDiscoverContainerHidden(true, animated: true)
        viewController.setHistoryButtonSelected(true)
        viewController.setSegmentsDeselected()      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    router.routeToDiscoverPostsGrid(viewController.containerView)
    viewController.setDiscoverContainerHidden(false, animated: false)
  }
}

// MARK: - DiscoverFeedRootContainerPresenter API
extension DiscoverFeedRootContainerPresenter: DiscoverFeedRootContainerPresenterApi {
  func handleSearchHistoryAction() {
    presentationState = .searchHistory
  }
  
  func handleSwitchTo(_ segment: DiscoverFeedRootContainer.Segments) {
    presentationState = .searchSegment(segment)
    lastPresentedSegment = segment
  }
  
  func handleSearchTextChange(_ text: String) {
    lastSearchedText = text
    interactor.scheduleSearch(text)
  }
  
  func handleSearchTextBeginEditingWith(_ text: String) {
    presentationState = .searchSegment(lastPresentedSegment)
  }
  
  func handleSearchTextEndEditingWith(_ text: String) {
    let hasSearchText = text.count > 0
    guard !hasSearchText else {
      return
    }
    
    presentationState = .discoverFeed
  }
  
  func presentSearch(_ text: String) {
    searchDelegate?.handleSearch(text)
  }
}

// MARK: - DiscoverFeedRootContainer Viper Components
fileprivate extension DiscoverFeedRootContainerPresenter {
  var viewController: DiscoverFeedRootContainerViewControllerApi {
    return _viewController as! DiscoverFeedRootContainerViewControllerApi
  }
  var interactor: DiscoverFeedRootContainerInteractorApi {
    return _interactor as! DiscoverFeedRootContainerInteractorApi
  }
  var router: DiscoverFeedRootContainerRouterApi {
    return _router as! DiscoverFeedRootContainerRouterApi
  }
}

extension DiscoverFeedRootContainerPresenter: DiscoverSearchContentDelegate {
  func searchWithCopyPastedSearchString(_ text: String) {
    lastSearchedText = text
    presentationState = .searchSegment(lastPresentedSegment)
    viewController.setSearchString(text)
    interactor.performSearch(text)
  }
}
