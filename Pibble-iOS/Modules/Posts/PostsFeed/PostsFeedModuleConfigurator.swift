//
//  PostsFeedModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum PostsFeedModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostsFeed.FeedType)
  case userPostsConfig(ServiceContainerProtocol, PostsFeed.FeedType, shouldScrollToPost: PostingProtocol?)
  case userPostsBaseContentConfig(ServiceContainerProtocol, PostsFeed.FeedType)
  case userPostsGridContentConfig(ServiceContainerProtocol, PostsFeed.FeedType)
  case discoverPostsGridContentConfig(ServiceContainerProtocol, PostsFeed.FeedType)
  case editPostConfig(ServiceContainerProtocol, editPost: PostingProtocol)
  case previewPostPromotionConfig(ServiceContainerProtocol, PromotionDraft)
  case userPostsContentConfig(ServiceContainerProtocol, PostsFeed.FeedType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, _):
      return (V: PostsFeedHomeViewController.self,
              I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                         postingService: diContainer.postingService,
                                         mediaCachingService: diContainer.mediaCachingService,
                                         userInteractionsService: diContainer.userInteractionService,
                                         accountProfileService: diContainer.accountProfileService,
                                         tagService: diContainer.tagService,
                                         placeService: diContainer.placeService,
                                         walletService: diContainer.walletService,
                                         createPostService: diContainer.createPostService, webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                         eventTrackingService: diContainer.eventTrackingService,
                                         promotionService: diContainer.promotionService,
                                         topGroupPostsService: diContainer.topGroupService,
                                         postHelpService: diContainer.postHelpService,
                                         feedType: configFeedType,
                                         paginationConfig: .listing),
              P: PostsFeedPresenter(options: PostsFeed.PresentationOptions.defaultPresentation(configFeedType.shouldPresentClosedPromoStatus,   shouldPresentFundingControls: configFeedType.shouldPresentFundingControls)),
              R: PostsFeedRouter())
    case .userPostsConfig(let diContainer, _, let shouldScrollToPost):
      let presentationOptions: PostsFeed.PresentationOptions
      if let post = shouldScrollToPost {
        presentationOptions = PostsFeed.PresentationOptions(selectionOption: .scrollToPost(post),
                                                            shouldPresentClosedPromoStatus: configFeedType.shouldPresentClosedPromoStatus, shouldPresentFundingControls: configFeedType.shouldPresentFundingControls)
      } else {
        presentationOptions = PostsFeed.PresentationOptions.defaultPresentation(configFeedType.shouldPresentClosedPromoStatus,
                                                                                shouldPresentFundingControls: configFeedType.shouldPresentFundingControls)
      }
      
      return (V: PostsFeedViewController.self,
              I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                         postingService: diContainer.postingService,
                                         mediaCachingService: diContainer.mediaCachingService,
                                         userInteractionsService: diContainer.userInteractionService,
                                         accountProfileService: diContainer.accountProfileService,
                                         tagService: diContainer.tagService,
                                         placeService: diContainer.placeService,
                                         walletService: diContainer.walletService,
                                         createPostService: diContainer.createPostService,
                                         webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                         eventTrackingService: diContainer.eventTrackingService,
                                         promotionService: diContainer.promotionService,
                                         topGroupPostsService: diContainer.topGroupService,
                                         postHelpService: diContainer.postHelpService,
                                         feedType: configFeedType,
                                         paginationConfig: .listing),
              P: PostsFeedPresenter(options: presentationOptions),
              R: PostsFeedRouter())
    case .userPostsBaseContentConfig(let diContainer, _):
      return (V: PostsFeedBaseContentViewController.self,
              I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                         postingService: diContainer.postingService,
                                         mediaCachingService: diContainer.mediaCachingService,
                                         userInteractionsService: diContainer.userInteractionService,
                                         accountProfileService: diContainer.accountProfileService,
                                         tagService: diContainer.tagService,
                                         placeService: diContainer.placeService,
                                         walletService: diContainer.walletService,
                                         createPostService: diContainer.createPostService,
                                         webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                         eventTrackingService: diContainer.eventTrackingService,
                                         promotionService: diContainer.promotionService,
                                         topGroupPostsService: diContainer.topGroupService,
                                         postHelpService: diContainer.postHelpService,
                                         feedType: configFeedType,
                                         paginationConfig: .listing),
              P: PostsFeedPresenter(options: PostsFeed
                .PresentationOptions
                .defaultPresentation(configFeedType.shouldPresentClosedPromoStatus,
                                     shouldPresentFundingControls: configFeedType.shouldPresentFundingControls)),
              R: PostsFeedRouter())
    case .userPostsContentConfig(let diContainer, _):
      return (V: PostsFeedContentViewController.self,
              I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                     postingService: diContainer.postingService,
                                     mediaCachingService: diContainer.mediaCachingService,
                                     userInteractionsService: diContainer.userInteractionService,
                                     accountProfileService: diContainer.accountProfileService,
                                     tagService: diContainer.tagService,
                                     placeService: diContainer.placeService,
                                     walletService: diContainer.walletService,
                                     createPostService: diContainer.createPostService,
                                     webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                     eventTrackingService: diContainer.eventTrackingService,
                                     promotionService: diContainer.promotionService,
                                     topGroupPostsService: diContainer.topGroupService,
                                     postHelpService: diContainer.postHelpService,
                                     feedType: configFeedType,
                                     paginationConfig: .listing),
              P: PostsFeedPresenter(options: PostsFeed
                .PresentationOptions
                .defaultPresentation(configFeedType.shouldPresentClosedPromoStatus,
                                     shouldPresentFundingControls: configFeedType.shouldPresentFundingControls)),
              R: PostsFeedRouter())
    case .userPostsGridContentConfig(let diContainer, _):
      return (V: PostsFeedGridContentViewController.self,
              I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                         postingService: diContainer.postingService,
                                         mediaCachingService: diContainer.mediaCachingService,
                                         userInteractionsService: diContainer.userInteractionService,
                                         accountProfileService: diContainer.accountProfileService,
                                         tagService: diContainer.tagService,
                                         placeService: diContainer.placeService,
                                         walletService: diContainer.walletService,
                                         createPostService: diContainer.createPostService,
                                         webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                         eventTrackingService: diContainer.eventTrackingService,
                                         promotionService: diContainer.promotionService,
                                         topGroupPostsService: diContainer.topGroupService,
                                         postHelpService: diContainer.postHelpService,
                                         feedType: configFeedType,
                                         paginationConfig: .grid),
              P: PostsFeedGridPresenter(),
              R: PostsFeedRouter())
    case .discoverPostsGridContentConfig(let diContainer, _):
    return (V: PostsFeedMosaicGridContentViewController.self,
            I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                       postingService: diContainer.postingService,
                                       mediaCachingService: diContainer.mediaCachingService,
                                       userInteractionsService: diContainer.userInteractionService,
                                       accountProfileService: diContainer.accountProfileService,
                                       tagService: diContainer.tagService,
                                       placeService: diContainer.placeService,
                                       walletService: diContainer.walletService,
                                       createPostService: diContainer.createPostService,
                                       webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                       eventTrackingService: diContainer.eventTrackingService,
                                       promotionService: diContainer.promotionService,
                                       topGroupPostsService: diContainer.topGroupService,
                                       postHelpService: diContainer.postHelpService,
                                       feedType: configFeedType,
                                       paginationConfig: .grid),
            P: PostsFeedGridPresenter(),
            R: PostsFeedRouter())
    case .editPostConfig(let diContainer, let editPost):
      return (V: PostsFeedEditCaptionViewController.self,
              I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                     postingService: diContainer.postingService,
                                     mediaCachingService: diContainer.mediaCachingService,
                                     userInteractionsService: diContainer.userInteractionService,
                                     accountProfileService: diContainer.accountProfileService,
                                     tagService: diContainer.tagService,
                                     placeService: diContainer.placeService,
                                     walletService: diContainer.walletService,
                                     createPostService: diContainer.createPostService,
                                     webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                     eventTrackingService: diContainer.eventTrackingService,
                                     promotionService: diContainer.promotionService,
                                     topGroupPostsService: diContainer.topGroupService,
                                     postHelpService: diContainer.postHelpService,
                                     feedType: configFeedType,
                                     paginationConfig: .listing),
              P: PostsFeedPresenter(options: PostsFeed.PresentationOptions(selectionOption: .editPost(editPost),
                                                                           shouldPresentClosedPromoStatus: configFeedType.shouldPresentClosedPromoStatus,
                                                                           shouldPresentFundingControls: configFeedType.shouldPresentFundingControls)),
              R: PostsFeedRouter())
    case .previewPostPromotionConfig(let diContainer, let promotionDraft):
      return (V: PostsFeedPromotionPostPreviewViewController.self,
              I: PostsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                     postingService: diContainer.postingService,
                                     mediaCachingService: diContainer.mediaCachingService,
                                     userInteractionsService: diContainer.userInteractionService,
                                     accountProfileService: diContainer.accountProfileService,
                                     tagService: diContainer.tagService,
                                     placeService: diContainer.placeService,
                                     walletService: diContainer.walletService,
                                     createPostService: diContainer.createPostService,
                                     webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                     eventTrackingService: diContainer.eventTrackingService,
                                     promotionService: diContainer.promotionService,
                                     topGroupPostsService: diContainer.topGroupService,
                                     postHelpService: diContainer.postHelpService,
                                     feedType: configFeedType,
                                     paginationConfig: .listing),
              P: PostsFeedPreviewPresenter(promotionDraft: promotionDraft),
              R: PostsFeedRouter())
    }
  }
  
  var configFeedType: PostsFeed.FeedType {
    switch self {
    case .defaultConfig(_, let feedType):
      return feedType
    case .userPostsConfig(_, let feedType, _):
      return feedType
    case .userPostsBaseContentConfig(_, let feedType):
      return feedType
    case .userPostsContentConfig(_, let feedType):
      return feedType
    case .userPostsGridContentConfig(_, let feedType):
      return feedType
    case .discoverPostsGridContentConfig(_, let feedType):
      return feedType
    case .editPostConfig(_, let editPost):
      return .singlePost(editPost)
    case .previewPostPromotionConfig(_, let draft):
      return .singlePost(draft.post)
    }
  }
}

extension PostsFeed.FeedType {
  var shouldPresentFundingControls: Bool {
    switch self {
    case .currentUserActiveFundingPosts:
      return true
    case .currentUserEndedFundingPosts:
      return true
    case .currentUserBackedFundingPosts:
      return false
    default:
      return false
    }
  }
  var shouldPresentClosedPromoStatus: Bool {
    switch self {
    case .userPromotedPosts(_, _):
      return true
    default:
      return false
    }
  }
}
