//
//  PostsFeedRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - PostsFeedRouter class
final class PostsFeedRouter: Router {
  fileprivate var walletPreviewModule: Module?
  //  fileprivate var transitioningDelegate: SlideTransitionDelegate?
}


// MARK: - PostsFeedRouter API
extension PostsFeedRouter: PostsFeedRouterApi {
  func routeToTopBannerInfo() {
    let module = AppModules
      .Posts
      .topBannerInfo
      .build()
    
    module?.router.presentFromRootWithPush()
  }
  
  func routeToFundingDonators(_ post: PostingProtocol) {
    let configurator = WalletActivityContentModuleConfigurator.donationsListingConfig(AppModules.servicesContainer, .donationsForPost(post))
    
    let module = AppModules
      .Wallet
      .walletActivityContent(.donationsForPost(post))
      .build(configurator: configurator)
    
    module?.router.presentFromRootWithPush()
  }
  
  func routeToWebsiteAt(_ url: URL) {
    let configurator = ExternalLinkModuleConfigurator.modalConfig(url, url.absoluteString)
    let module = AppModules
      .Settings
      .externalLink(url, url.absoluteString)
      .build(configurator: configurator)
    
    module?.router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToPickPostReportReason(delegate: ReportPostDelegateProtocol) {
    AppModules
      .Posts
      .reportPost(delegate)
      .build()?
      .router.presentFromRootWithPush()
  }
  
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
  
  func routeToChatRoomForPost(_ post: PostingProtocol) {
    AppModules
      .Messenger
      .chat(.roomForPost(post))
      .build()?
      .router.presentFromRootWithPush()
  }
  
  func routeToChatRoomsWith(_ transition: GestureInteractionController) {
    let module = AppModules
      .Messenger
      .chatRoomsContainer
      .build()
    
    module?.view.transitionsController.presentationAnimator = SlideInAnimationController()
    module?.view.transitionsController.presentationAnimator?.interactiveTransitioning = transition
    module?.view.transitionsController.dismissalAnimator = SlideOutAnimationController()
    module?.router.presentFromRootWithPush()
  }
  
  func routeToChatRooms() {
    let module = AppModules
      .Messenger
      .chatRoomsContainer
      .build()
    
    module?.view.transitionsController.presentationAnimator = SlideInAnimationController()
    module?.view.transitionsController.dismissalAnimator = SlideOutAnimationController()
    module?.router.presentFromRootWithPush()
  }
  
  func routeToChatRoomsGroupFor(_ post: PostingProtocol) {
    let configurator = ChatRoomsModuleConfigurator.chatRoomsForGroupConfig(AppModules.servicesContainer,
                                                                           .chatRoomsForGroup(post))
    AppModules
      .Messenger
      .chatRooms(.chatRoomsForGroup(post))
      .build(configurator: configurator)?
      .router.presentFromRootWithPush()
  }
  
  func routeToDigitalGoodDetail(_ post: PostingProtocol, commercialInfo: CommerceInfoProtocol, delegate: CommercialPostDetailDelegateProtocol) {
    AppModules
      .Posts
      .commercialPostDetail(.digitalGoods(post, commercialInfo), delegate)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController, embedInNavController: true, animated: false)
  }
  
  func routeToGoodsDetail(_ post: PostingProtocol, goodsInfo: GoodsProtocol, delegate: CommercialPostDetailDelegateProtocol) {
    AppModules
      .Posts
      .commercialPostDetail(.goods(post, goodsInfo), delegate)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController, embedInNavController: true, animated: false)
  }
  
  func routeToFundingDetail(_ post: PostingProtocol, shouldPresentFundingControls: Bool, delegate: FundingDetailDelegateProtocol) {
    AppModules
      .Posts
      .fundingPostDetail(post, shouldPresentFundingControls ? .presentationWithControls : .defaultPresentation, delegate)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController, embedInNavController: true, animated: false)
  }
  
  func routeToLocationPick(_ withDelegate: LocationPickDelegateProtocol) {
    AppModules
      .CreatePost
      .locationPick(withDelegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPlaceRelatedPostsFor(_ place: LocationProtocol) {
    AppModules
      .Discover
      .searchResultDetailContainer(.placeRelatedPosts(place))
      .build()?
      .router.present(withPushfrom: _presenter._viewController, animated: true)
  }
  
  func routeToTagEdit(_ withDelegate: TagPickDelegateProtocol) {
    AppModules
      .CreatePost
      .tagPick(withDelegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPostCaptionEditFor(_ posting: PostingProtocol) {
    let configurator = PostsFeedModuleConfigurator.editPostConfig(AppModules.servicesContainer, editPost: posting)
    
    let module = AppModules
      .Posts
      .postsFeed(configurator.configFeedType)
      .build(configurator: configurator)
    
    module?.router.present(withDissolveFrom: presenter._viewController, embedInNavController: true)
  }
  
  func routeToPostingsWithTag(_ tag: String, originalPosting: PostingProtocol) {
    let module = AppModules
      .Discover
      .searchResultDetailContainer(.relatedPostsForTagString(tag))
      .build()
    
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToPostingDetailFor(_ posting: PostingProtocol, currentFeedType: PostsFeed.FeedType) {
    let config: PostsFeed.FeedType = currentFeedType
    let configurator = PostsFeedModuleConfigurator.userPostsConfig(AppModules.servicesContainer, config, shouldScrollToPost: posting)
    let module = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToDiscoverPostDetailFor(_ post: PostingProtocol) {
    let config: PostsFeed.FeedType = .discoverDetailFeedFor(post)
    let configurator = PostsFeedModuleConfigurator.userPostsConfig(AppModules.servicesContainer, config, shouldScrollToPost: post)
    let module = AppModules
      .Posts
      .postsFeed(config)
      .build(configurator: configurator)
    
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToUserProfileFor(_ user: UserProtocol) {
    let targetUser: UserProfileContent.TargetUser = (user.isCurrent ?? false) ? .current : .other(user)
    
    AppModules
      .UserProfile
      .userProfileContainer(targetUser)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToDonate(delegate: DonateDelegateProtocol) {
    AppModules
      .Posts
      .donate(delegate, [.pibble, .redBrush, .greenBrush], .anyAmount)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToUpvotedUsersFor(_ posting: PostingProtocol, delegate: UpvotePickDelegateProtocol) {
    AppModules
      .Posts
      .upvotedUsers(posting, delegate)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController, embedInNavController: true)
  }
  
  func routeToShareControlWith(_ urls: [URL], completion: @escaping ((UIActivity.ActivityType?, Bool) -> Void)) {
    let vc = UIActivityViewController(activityItems: urls, applicationActivities: [])
    vc.completionWithItemsHandler = { (activityType, success, items, error) in
      completion(activityType, success)
    }
    presenter._viewController.present(vc, animated: true, completion: nil)
  }
  
  func routeToUpVote(delegate: UpVoteDelegateProtocol, purpose: UpVote.UpvotePurpose) {
    AppModules
      .Posts
      .upVote(delegate, purpose)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToWallet() {
    AppModules
      .Wallet
      .walletHome
      .build()?
      .router.presentFromRootWithPush()
  }
  
  func routeToPlayRoom() {
    let module = AppModules
      .UserProfile
      .playRoom(.currentUser)
      .build()
    
    module?.router.presentFromRootWithPush()
  }
  
  func routeToGifts() {
    let module = AppModules
      .Gifts
      .giftsFeed(.giftHome)
      .build()
    
    module?.router.presentFromRootWithPush()
  }
  
  func routeToCommentsFor(_ posting: PostingProtocol) {
    AppModules
      .Posts
      .comments(posting)
      .build()?
      .router.presentFromRootWithPush()
  }
  
  
  
  
  
  
  func routeToWalletPreview(in container: UIView) {
    walletPreviewModule?.router.removeFromContainerView()
    let module = AppModules
      .Wallet
      .walletPreview
      .build()
    
    walletPreviewModule = module
    module?
      .router
      .show(from: presenter._viewController, insideView: container)
  }
  
  func routeToZoomForPost(_ post: PostingProtocol, media: MediaProtocol) {
    AppModules
      .Posts
      .mediaDetail(post, media)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeToCreateCommercePost() {
    let module = AppModules
      .CreatePost
      .mediaSource(PostDraft(postingType: .digitalGood))
      .build()
    
    module?.router.present(from: presenter._viewController, embedInNavController: true)
  }
  
  func routeToCreateFundingWithCampaignTeam(_ team: FundingCampaignTeamProtocol) {
    guard let draft = PostDraft(team: team) else {
      return
    }
    let module = AppModules
      .CreatePost
      .mediaSource(draft)
      .build()
    
    module?.router.present(from: presenter._viewController, embedInNavController: true)
  }
  
  func routeToAddPromotion(post: PostingProtocol) {
    AppModules
      .Promotion
      .promotionDestinationPick(post)
      .build()?
      .router.present(from: presenter._viewController, embedInNavController: true)
  }
  
  func routeToEngagement(post: PostingProtocol) {
    AppModules
      .Promotion
      .postStatistics(post)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController, animated: false)
  }
  
  func routeToInsights(promotion: PostPromotionProtocol) {
    AppModules
      .Promotion
      .promotionInsights(promotion)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToLeaderboard() {
    AppModules
      .Posts
      .leaderboardContainer
      .build()?
      .router.presentFromRootWithPush()
  }
  
  func routeToPostHelpCreationFor(_ post: PostingProtocol, delegate: CreatePostHelpDelegateProtocol) {
    AppModules
      .PostHelp
      .createPostHelp(delegate)
      .build()?
      .router.present(withDissolveFrom: presenter._viewController, animated: false)
  }
  
  func routeToPostHelpAnswersFor(_ postHelpRequest: PostHelpRequestProtocol) {
    AppModules
      .PostHelp
      .postHelpAnswers(postHelpRequest)
      .build()?
      .router.presentFromRootWithPush()
  }
}

// MARK: - PostsFeed Viper Components
fileprivate extension PostsFeedRouter {
  var presenter: PostsFeedPresenterApi {
    return _presenter as! PostsFeedPresenterApi
  }
}
