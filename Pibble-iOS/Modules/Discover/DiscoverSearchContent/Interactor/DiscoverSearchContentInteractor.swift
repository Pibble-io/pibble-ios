//
//  DiscoverSearchContentInteractor.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

class DiscoverSearchContentInteractor: Interactor {
  fileprivate let discoverService: DiscoverServiceProtocol
  fileprivate let storageService: CoreDataStorageServiceProtocol
  fileprivate let contentType: DiscoverSearchContent.ContentType
  fileprivate var searchText = ""
  fileprivate var searchResults: [[SearchResultEntity]] = [[], [], []]
  
  init(discoverService: DiscoverServiceProtocol,
       storageService: CoreDataStorageServiceProtocol,
       contentType: DiscoverSearchContent.ContentType) {
    self.discoverService = discoverService
    self.storageService = storageService
    self.contentType = contentType
    super.init()
  }
}

// MARK: - Interactor Viper Components Api
private extension DiscoverSearchContentInteractor {
  var presenter: DiscoverSearchContentPresenterApi {
    return _presenter as! DiscoverSearchContentPresenterApi
  }
}

// MARK: - DiscoverSearchContentInteractor API
extension DiscoverSearchContentInteractor: DiscoverSearchContentInteractorApi {
  var isCopySearchStringAvailable: Bool {
    return false
  }
  
  func saveToSearchHistoryItemAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath)
    storageService.batchUpdateStorage(with: [item])
  }
  
  func setSearchResults(_ results: [[SearchResultEntity]], presentDiffUpdate: Bool = true) {
    searchResults = results
    guard presentDiffUpdate else {
      presenter.presentReload()
      return
    }
    
    presenter.presentCollectionUpdates(.beginUpdates)
    presenter.presentCollectionUpdates(.updateSections(idx: Array(searchResults.indices)))
    presenter.presentCollectionUpdates(.endUpdates)
    
  }
  
  fileprivate func mapToSearchResultsFor(_ text: String, users: [PartialUserProtocol], places: [LocationProtocol], tags: [TagProtocol]) -> [[SearchResultEntity]] {
    
    let userSearchResuls = users
        .map { UserManagedObject.updateOrCreate(with: $0, in: storageService.viewContext) }
        .map { UserSearchResult(user: $0, searchString: text) }
        .map { SearchResultEntity(user: $0) }
    
    let locationSearchResults = places
      .map { LocationManagedObject.replaceOrCreate(with: $0, in: storageService.viewContext) }
      .map { PlaceSearchResult(place: $0, searchString: text) }
      .map { SearchResultEntity(place: $0) }
    
    let tagSearchResults = tags
      .map { TagManagedObject.replaceOrCreate(with: $0, in: storageService.viewContext) }
      .map { TagSearchResult(tag: $0, searchString: text) }
      .map { SearchResultEntity(tag: $0) }
    
    return [userSearchResuls, locationSearchResults, tagSearchResults]
  }
  
  
  func performSearch(_ text: String) {
    guard text.count > 0 else {
      searchText = ""
      setSearchResults([[], [], []], presentDiffUpdate: false)
      return
    }
    
    guard searchText != text else {
      return
    }
    
    searchText = text
    
    switch contentType {
    case .users:
      discoverService.searchUser(text) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let users):
          let results = strongSelf.mapToSearchResultsFor(text, users: users, places: [], tags: [])
          strongSelf.setSearchResults(results)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    case .places:
      discoverService.searchPlace(text) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let places):
          let results = strongSelf.mapToSearchResultsFor(text, users: [], places: places, tags: [])
          strongSelf.setSearchResults(results)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    case .tags:
      discoverService.searchTag(text) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let tags):
          let results = strongSelf.mapToSearchResultsFor(text, users: [], places: [], tags: tags)
          strongSelf.setSearchResults(results)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    case .top:
      discoverService.searchForTop(text) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let users, let places, let tags):
          let results = strongSelf.mapToSearchResultsFor(text, users: users, places: places, tags: tags)
          strongSelf.setSearchResults(results)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  }
  
  func numberOfSections() -> Int {
    return searchResults.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return searchResults[section].count
  }
  
  func itemAt(_ indexPath: IndexPath) -> SearchResultEntity {
    return searchResults[indexPath.section][indexPath.item]
  }
  
  func prepareItemFor(_ index: Int) {
    
  }
  
  func cancelPrepareItemFor(_ index: Int) {
    
  }
  
  func initialFetchData() {
    setSearchResults([[], [], []], presentDiffUpdate: false)
  }
  
  func initialRefresh() {
    
  }
}


fileprivate struct UserSearchResult: UserSearchResultProtocol {
  let relatedUser: UserProtocol?
  let identifier: Int
  let searchString: String
  let searchResultType: SearchResultType
  let searchResultCreatedAt: Date
  
  init(user: UserProtocol, searchString: String) {
    self.relatedUser = user
    self.searchString = searchString
    searchResultType = .user
    identifier = user.identifier
    searchResultCreatedAt = Date()
  }
  
  var user: UserProtocol? {
    return relatedUser
  }
}

fileprivate struct PlaceSearchResult: PlaceSearchResultProtocol {
  let relatedPlace: LocationProtocol
  let identifier: Int
  let searchString: String
  let searchResultType: SearchResultType
  let searchResultCreatedAt: Date
  
  init(place: LocationProtocol, searchString: String) {
    self.relatedPlace = place
    self.searchString = searchString
    searchResultType = .place
    identifier = place.identifier
    searchResultCreatedAt = Date()
  }
  
  var place: LocationProtocol? {
    return relatedPlace
  }
}

fileprivate struct TagSearchResult: TagSearchResultProtocol {
  let relatedTag: TagProtocol
  let identifier: Int
  let searchString: String
  let searchResultType: SearchResultType
  let searchResultCreatedAt: Date
  
  
  init(tag: TagProtocol, searchString: String) {
    self.relatedTag = tag
    self.searchString = searchString
    searchResultType = .tag
    identifier = tag.identifier
    searchResultCreatedAt = Date()
  }
  
  var tag: TagProtocol? {
    return relatedTag
  }
}
