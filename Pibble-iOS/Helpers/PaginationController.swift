//
//  PaginationController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 13.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum PaginationType {
  case page
  case cursor
}

struct Cursor {
  let id: Int
  let sortIds: [Double]
  
  init(id: Int, sortIds: [Int]) {
    self.id = id
    self.sortIds = sortIds.map { Double($0) }
  }
  
  init(id: Int, sortIds: [Double]) {
    self.id = id
    self.sortIds = sortIds
  }
}

func < (lhs: Cursor, rhs: Cursor) -> Bool {
  return zip(lhs.sortIds, rhs.sortIds)
    .first { $0.0 != $0.1 }
    .map { $0.0.isLess(than: $0.1) } ?? false
}

func == (lhs: Cursor, rhs: Cursor) -> Bool {
  return zip(lhs.sortIds, rhs.sortIds)
    .first { !$0.0.isEqual(to: $0.1) } == nil
}

func <= (lhs: Cursor, rhs: Cursor) -> Bool {
  return lhs < rhs || lhs == rhs
}

func > (lhs: Cursor, rhs: Cursor) -> Bool {
  return !(lhs < rhs) && !(lhs == rhs)
}


protocol PaginationControllerProtocol: class {
  var paginationType: PaginationType { get }
  func initialRequest()
  
  //controller should implement one of these pagination methods
  func paginateByIndex(_ itemIndex: Int)
  func paginateByIdentifier(_ itemId: Cursor)
  
  //controller should implement one of these update pagination info methods
  func updatePaginationInfo(_ paginationInfo: PaginationInfoProtocol)
  func updatePaginationInfoWith(_ cursorItemIds: [Cursor])
  
  var delegate: PaginationControllerDelegate? { get set }
}

extension PaginationControllerProtocol {
  func paginateBy(_ itemIndex: Int, identifier: Cursor) {
    switch paginationType {
    case .page:
      paginateByIndex(itemIndex)
    case .cursor:
      paginateByIdentifier(identifier)
    }
  }
  
  func updatePaginationInfo(_ itemIds: [Cursor], paginationInfo: PaginationInfoProtocol) {
    switch paginationType {
    case .page:
      updatePaginationInfo(paginationInfo)
    case .cursor:
      updatePaginationInfoWith(itemIds)
    }
  }
}

@objc protocol PaginationControllerDelegate: class {
  func request(page: Int, perPage: Int)
  
  @objc optional func request(cursorId: Int, perPage: Int)
  @objc optional func requestInitial(perPage: Int)
}


class PaginationController: PaginationControllerProtocol {
  fileprivate let itemsPerPage: Int
  fileprivate let requestItems: Int
  fileprivate let shouldRefreshTop: Bool
  fileprivate let shouldRefreshInTheMiddle: Bool
  fileprivate let pullToRefreshUsed: Bool
  
  fileprivate var paginationInfo: PaginationInfoProtocol? {
    didSet {
      if let prevValue = oldValue, let value = paginationInfo {
        if prevValue.totalCount < value.totalCount && shouldRefreshTop {
          let count = abs(prevValue.totalCount - value.totalCount)
          request(page: 0, perPage: count)
        }
      }
    }
  }
  
  weak var delegate: PaginationControllerDelegate?
  
  init(itemsPerPage: Int, requestItems: Int, shouldRefreshTop: Bool, shouldRefreshInTheMiddle: Bool = true, pullToRefreshUsed: Bool = false) {
    self.itemsPerPage = itemsPerPage
    self.requestItems = requestItems
    self.shouldRefreshTop = shouldRefreshTop
    self.shouldRefreshInTheMiddle = shouldRefreshInTheMiddle
    self.pullToRefreshUsed = pullToRefreshUsed
  }
  
  fileprivate var lastPageRequest: Int?
  fileprivate var canRequestFirstPage: Bool {
    if let lastPageRequest = lastPageRequest {
      return lastPageRequest > 1 && !pullToRefreshUsed
    }
    
    return true
  }
  
  fileprivate func currentPageForItemIndex(_ currentItemIndex: Int) -> Int {
    return currentItemIndex / itemsPerPage
  }
  
  var paginationType: PaginationType {
   return .page
  }
  
  func initialRequest() {
    lastPageRequest = 0
    delegate?.request(page: 0, perPage: requestItems)
  }
  
  func updatePaginationInfo(_ paginationInfo: PaginationInfoProtocol) {
    self.paginationInfo = paginationInfo
  }
  
  //uses pagination by page, per page
  
  func paginateByIdentifier(_ itemId: Cursor) {
    fatalError("Cursor based pagination is not supported")
  }
  
  //uses pagination info page, per page
  func updatePaginationInfoWith(_ cursorItemIds: [Cursor]) {
    fatalError("Cursor based pagination is not supported")
  }
  
  fileprivate func request(page: Int, perPage: Int) {
    lastPageRequest = page
    delegate?.request(page: page, perPage: perPage)
  }
  
  fileprivate func shouldPerformNextPageFetchData(_ currentIndexPath: Int) -> Bool {
    let currentPage =  currentPageForItemIndex(currentIndexPath)
    let currentItemNumber = currentIndexPath - (currentPage  * itemsPerPage)
    
    let middle = Int(Double(itemsPerPage) * 0.5)
    if shouldRefreshInTheMiddle {
      return currentItemNumber >= middle
    }
    
    return currentItemNumber == itemsPerPage - 1
  }
  
  func paginateByIndex(_ itemIndex: Int) {
    if itemIndex == 0 && canRequestFirstPage {
      request(page: 0, perPage: requestItems)
      return
    }
    
    if shouldPerformNextPageFetchData(itemIndex) {
      let currentPage = currentPageForItemIndex(itemIndex)
      if canRequestPage(currentPage + 1) {
        request(page: currentPage + 1, perPage: requestItems)
      }
    }
  }
  
  fileprivate func canRequestPage(_ page: Int) -> Bool {
    if let lastPageRequest = lastPageRequest {
//      if abs(lastPageRequest - page) > 2 {
//        return true
//      }
      
      if page <= lastPageRequest {
        return false
      }
    }
    return true
  }
}


class CursorPaginationController: PaginationControllerProtocol {
  fileprivate let requestItems: Int
  fileprivate let shouldRefreshInTheMiddle: Bool
  fileprivate var cursorIds: (first: Cursor, middle: Cursor, last: Cursor)?

  weak var delegate: PaginationControllerDelegate?
  
  init(requestItems: Int, shouldRefreshInTheMiddle: Bool = true) {
    self.requestItems = requestItems
    self.shouldRefreshInTheMiddle = shouldRefreshInTheMiddle
  }
  
  fileprivate var lastItemRequestId: Cursor?
  
  fileprivate var initialRequestCursorIds: (first: Cursor, middle: Cursor, last: Cursor)?
  
  var paginationType: PaginationType {
    return .cursor
  }
  
  func initialRequest() {
    initialRequestCursorIds = nil
    lastItemRequestId = nil
    delegate?.requestInitial?(perPage: requestItems)
  }
  
  //uses ids for cursor
  func updatePaginationInfo(_ paginationInfo: PaginationInfoProtocol) {
    fatalError("Page based pagination is not supported")
  }
  
  func updatePaginationInfoWith(_ cursorItemIds: [Cursor]) {
    let midIndex = Int(cursorItemIds.count / 2)
    guard let first = cursorItemIds.first,
      let last = cursorItemIds.last,
      midIndex < cursorItemIds.count
      else {
        return
    }
    
    let mid = cursorItemIds[midIndex]
    cursorIds = (first, mid, last)
    if initialRequestCursorIds == nil {
      initialRequestCursorIds = cursorIds
    }
  }
  
  fileprivate func request(cursorId: Cursor, perPage: Int) {
    lastItemRequestId = cursorId
    delegate?.request?(cursorId: cursorId.id, perPage: perPage)
  }
  
  fileprivate func shouldPerformNextPageFetchData(_ currentId: Cursor) -> Bool {
    guard let cursorIds = cursorIds else {
      return true
    }
    
    if shouldRefreshInTheMiddle {
      return currentId <= cursorIds.middle
    }
    
    return currentId <= cursorIds.last
  }
  
  fileprivate func isBeforeCursor(_ currentId: Cursor) -> Bool {
    guard let cursorIds = cursorIds else {
      return false
    }
    
    if shouldRefreshInTheMiddle {
      return currentId > cursorIds.first
    }
    
    return false
  }
  
  fileprivate func isAfterCursor(_ currentId: Cursor) -> Bool {
    guard let cursorIds = cursorIds else {
      return false
    }
    
    if shouldRefreshInTheMiddle {
      return currentId <= cursorIds.last
    }
    
    return false
  }
  
  func paginateByIndex(_ itemIndex: Int) {
    fatalError("Page based pagination is not supported")
  }
  
  func paginateByIdentifier(_ itemId: Cursor) {
//    guard !isBeforeCursor(itemId) else {
//      if canRequestBefore(itemId) {
//        AppLogger.info("canRequestBefore")
//        request(cursorId: itemId, perPage: requestItems)
//      }
//      
//      return
//    }
    
    guard !isAfterCursor(itemId) else {
      if canRequestAfter(itemId) {
        AppLogger.debug("canRequestAfter")
        request(cursorId: itemId, perPage: requestItems)
      }
      
      return
    }
    
    guard shouldPerformNextPageFetchData(itemId),
      let cursor = cursorIds
    else {
      return
    }
    
    guard canRequest(cursor.last) else {
      return
    }
    AppLogger.debug("Request next")
    request(cursorId: cursor.last, perPage: requestItems)
  }
  
  fileprivate func canRequest(_ cursorId: Cursor) -> Bool {
    guard let lastItemRequestId = lastItemRequestId else {
      return true
    }
    
    return cursorId < lastItemRequestId
  }
  
  fileprivate func canRequestAfter(_ cursorId: Cursor) -> Bool {
    guard let lastItemRequestId = lastItemRequestId else {
      return true
    }
    
    return cursorId < lastItemRequestId
  }
  
  fileprivate func canRequestBefore(_ cursorId: Cursor) -> Bool {
    guard let lastItemRequestId = lastItemRequestId else {
      return true
    }
    
    return cursorId < lastItemRequestId
  }
}
