//
//  PostsFeedModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension PostingProtocol {
  func evaluatePostsFeedPresenterItemsCount() -> Int {
    return PostsFeed.ItemViewModelType.sectionViewModelFor(self, shouldPresentClosedPromoStatus: false, userRequest: {_ in }).count
  }
}

enum PostsFeed {
  enum PrefetchMediaContentUrlType {
    case mediaUrl
    case thumbnail
  }
  enum PaginationType {
    case grid
    case listing
    
    var prefetchMediaContentUrlType: PrefetchMediaContentUrlType{
      switch self {
      case .grid:
        return .thumbnail
      case .listing:
        return .mediaUrl
      }
    }
    
    var itemsPerPage: Int {
      switch self {
      case .grid:
        return 18
      case .listing:
        return 9
      }
    }
    
    var requestItems: Int {
      switch self {
      case .grid:
        return 18
      case .listing:
        return 9
      }
    }
    
    func requestPromoItemsForPostsRequested(_ count: Int) -> Int {
      return max(1, count / 9 )
    }
  }
  
  struct PresentationOptions {
    let selectionOption: SelectionOption
    let shouldPresentClosedPromoStatus: Bool
    let shouldPresentFundingControls: Bool
    
    static func defaultPresentation(_ shouldPresentClosedPromoStatus: Bool, shouldPresentFundingControls: Bool) -> PresentationOptions {
      return PresentationOptions(selectionOption: .defaultPresentation,
                                 shouldPresentClosedPromoStatus: shouldPresentClosedPromoStatus,
                                 shouldPresentFundingControls: shouldPresentFundingControls)
    }
  }
  
  enum SelectionOption {
    case defaultPresentation
    case scrollToPost(PostingProtocol)
    case editPost(PostingProtocol)
    
    var shouldScrollToPost: PostingProtocol? {
      switch self {
      case .defaultPresentation:
        return nil
      case .scrollToPost(let post):
        return post
      case .editPost(let post):
        return post
      }
    }
    
    var shouldEditPost: PostingProtocol? {
      switch self {
      case .defaultPresentation:
        return nil
      case .scrollToPost:
        return nil
      case .editPost(let post):
        return post
      }
    }
  }
  
  enum FeedType {
    case main
    case userPosts(UserProtocol)
    case singlePost(PostingProtocol)
    case favoritesPosts(UserProtocol)
    case upvotedPosts(UserProtocol)
    case discover
    case discoverDetailFeedFor(PostingProtocol)
    case postsRelatedToTag(TagProtocol)
    case postsRelatedToPlace(LocationProtocol)
    
    case currentUserCommercePosts(UserProtocol)
    case currentUserPurchasedCommercePosts(UserProtocol)
    
    case userPromotedPosts(AccountProfileProtocol, PromotionStatus)
    case topGroupsPosts(TopGroupPostsType)
    case winnerPosts(UserProtocol)
    
    case currentUserActiveFundingPosts(UserProtocol)
    case currentUserEndedFundingPosts(UserProtocol)
    case currentUserBackedFundingPosts(UserProtocol)
  }
  
  enum FundingCampaignTeamActions {
    case join
  }
  
  enum FundingCampaignActions {
    case donate
    case showCampaign
  }
  
  enum UserSectionActions {
    case following
    case additional
    case userProfile
  }
  
  enum AddCommentActions {
    case beginEditing
    case changeText(String)
    case postComment(String)
  }
  
  enum EditDescriptionActions {
    case beginEditing
    case changeText(String)
  }
  
  enum UploadingActions {
    case cancel
    case restart
  }
  
  enum CommercialPostActions {
    case chat
    case detail
  }
  
  enum PromotionActions {
    case add
    case showEngagement
    case showDestination
  }
  
  enum PromotionEventsActions {
    case pause
    case resume
    case close
    case insight
  }
  
  enum TopGroupsHeaderActions {
    case selectionAt(IndexPath)
    case showLeaderboard
    case showTopBannerInfo
  }
  
  enum ItemViewModelType: DiffableProtocol {
    case user(PostsFeedUserViewModelProtocol)
    case content(PostsFeedContentViewModelProtocol)
    case actions(PostsFeedActionsViewModelProtocol)
    case location(PostsFeedItemLocationViewModelProtocol)
    case description(PostsFeedDescriptionViewModelProtocol)
    case postingDate(PostsFeedDateViewModelProtocol)
    case tags(PostsFeedTagContainerViewModelProtocol)
    case comment(PostsFeedCommentViewModelProtocol)
    case showAllComments(PostsFeedAllCommentsViewModelProtocol)
    case addComment(PostsFeedAddCommentViewModelProtocol)
    case fundingCampaignTitle(PostsFeedFundingCampaignTitleViewModelProtocol)
    case fundingCampaignStatus(PostsFeedFundingCampaignStatusViewModelProtocol)
    case fundingCampaignTeam(PostsFeedFundingCampaignTeamViewModelProtocol)
    case promotionStatus(PostsFeedItemPromotionViewModelProtocol)
    case addPromotion(PostsFeedAddPromotionViewModelProtocol)
    case editDescription(PostsFeedEditDescriptionViewModelProtocol)
    case uploading(PostsFeedUploadingViewModelProtocol)
    case commercialInfo(PostsFeedCommercialInfoViewModelProtocol)
    case goodsInfo(PostsFeedGoodsInfoViewModelProtocol)
    case commercialPostError(PostsFeedCommercialErrorViewModelProtocol)
    
    var identifier: String {
      switch self {
      case .user(let vm):
        return vm.identifier
      case .content(let vm):
        return vm.identifier
      case .actions(let vm):
        return vm.identifier
      case .location(let vm):
        return vm.identifier
      case .description(let vm):
        return vm.identifier
      case .postingDate(let vm):
        return vm.identifier
      case .tags(let vm):
        return vm.identifier
      case .comment(let vm):
        return vm.identifier
      case .showAllComments(let vm):
        return vm.identifier
      case .addComment(let vm):
        return vm.identifier
      case .fundingCampaignTitle(let vm):
        return vm.identifier
      case .fundingCampaignStatus(let vm):
        return vm.identifier
      case .fundingCampaignTeam(let vm):
        return vm.identifier
      case .promotionStatus(let vm):
        return vm.identifier
      case .addPromotion(let vm):
        return vm.identifier
      case .editDescription(let vm):
        return vm.identifier
      case .uploading(let vm):
        return vm.identifier
      case .commercialInfo(let vm):
        return vm.identifier
      case .commercialPostError(let vm):
        return vm.identifier
      case .goodsInfo(let vm):
        return vm.identifier
      }
    }
    
    static func gridItemViewModelFor(_ posting: PostingProtocol, userRequest: @escaping PostsFeedAddCommentViewModelUserRequestClojure) -> PostsFeed.ItemViewModelType {
      let contentViewModelTypes: [PostsFeed.ContentViewModelType] = posting.postingMedia
        .compactMap {
          switch $0.contentType {
          case .image:
            let vm = PostsFeed.ImageThumbnailViewModel($0, post: posting)
            return PostsFeed.ContentViewModelType.image(vm)
          case .video:
            let vm = PostsFeed.VideoThumbnailViewModel($0)
            return PostsFeed.ContentViewModelType.video(vm)
          case .unknown:
            return nil
          }
      }
      
      let contentVM = PostsFeed.ContentViewModel(content: contentViewModelTypes, userRequest: userRequest)
      let contentItemVM = PostsFeed.ItemViewModelType.content(contentVM)
      return contentItemVM
    }
    
    static func sectionPromotionPreviewViewModelFor(_ posting: PostingProtocol, promotionDraft: PromotionDraft, userRequest: @escaping PostsFeedAddCommentViewModelUserRequestClojure) -> [PostsFeed.ItemViewModelType] {
      
      
      //UserViewModel
      
      var viewModels: [PostsFeed.ItemViewModelType] = []
      
      if let user = posting.postingUser {
        let vm = PostsFeed.UserViewModel(user, posting: posting)
        viewModels.append(.user(vm))
      }
      
      //ContentViewModel
      
      let contentViewModelTypes: [PostsFeed.ContentViewModelType] = posting.postingMedia
        .compactMap {
          switch $0.contentType {
          case .image:
            let vm = PostsFeed.ImageViewModel($0, post: posting)
            return PostsFeed.ContentViewModelType.image(vm)
          case .video:
            let vm = PostsFeed.VideoViewModel($0)
            return PostsFeed.ContentViewModelType.video(vm)
          case .unknown:
            return nil
          }
      }
      
      let contentVM = PostsFeed.ContentViewModel(content: contentViewModelTypes, userRequest: userRequest)
      let contentItemVM = PostsFeed.ItemViewModelType.content(contentVM)
      viewModels.append(contentItemVM)
      
      //Promotion
      
      if let promotionVM = PostsFeedPromotionViewModel(post: posting, promotionDraft: promotionDraft) {
        let promotionItemVM = PostsFeed.ItemViewModelType.promotionStatus(promotionVM)
        viewModels.append(promotionItemVM)
      }
      
      //Commercial
      
      if let commercialInfoVM = PostsFeedCommercialInfoViewModel(post: posting) {
        let commercialInfoItemVM = PostsFeed.ItemViewModelType.commercialInfo(commercialInfoVM)
        viewModels.append(commercialInfoItemVM)
      }
      
      if let goodsInfoVM = PostsFeedGoodPriceViewModel(post: posting) {
        let goodsInfoItemVm = PostsFeed.ItemViewModelType.goodsInfo(goodsInfoVM)
        viewModels.append(goodsInfoItemVm)
      }
   
      //Funding
      
      if let funding = posting.fundingCampaign {
        let fundingTitleVM = PostsFeed.PostsFeedFundingCampaignTitleViewModel(funding: funding, posting: posting)
        let fundingTitleItemVM = PostsFeed.ItemViewModelType.fundingCampaignTitle(fundingTitleVM)
        viewModels.append(fundingTitleItemVM)
        
        if let shouldPresentFundingExtension = posting.shouldPresentFundingExtension, shouldPresentFundingExtension {
          
//          let fundingStatusVM = PostsFeed.PostsFeedFundingCampaignStatusViewModel(funding: funding)
//          let fundingStatusItemVM = PostsFeed.ItemViewModelType.fundingCampaignStatus(fundingStatusVM)
//          viewModels.append(fundingStatusItemVM)
          
//          if let team = posting.fundingCampaignTeam {
//            let fundingTeamVM = PostsFeed.PostsFeedFundingCampaignTeamViewModel(team: team)
//            let fundingTeamItemVM = PostsFeed.ItemViewModelType.fundingCampaignTeam(fundingTeamVM)
//            viewModels.append(fundingTeamItemVM)
//          }
        }
      }
      
      //ActionsViewModel
      
      let actionsVM = PostsFeed.ActionsViewModel(posting: posting)
      let actionsItemVM = PostsFeed.ItemViewModelType.actions(actionsVM)
      
      viewModels.append(actionsItemVM)
      
      if let locationVM = PostsFeed.PostsFeedItemLocationViewModel(posting: posting) {
        let locationItemVM = PostsFeed.ItemViewModelType.location(locationVM)
        viewModels.append(locationItemVM)
      }
      
      //DescriptionViewModel
      
      if let descriptionVM = PostsFeed.DescriptionViewModel(posting: posting) {
        let descriptionItemVM = PostsFeed.ItemViewModelType.description(descriptionVM)
        viewModels.append(descriptionItemVM)
      }
     
      //PostsFeedTagContainerViewModel
      
      if posting.postingTags.count > 0 {
        let tagsVM = PostsFeed.PostsFeedTagContainerViewModel(posting: posting)
        let itagsItemVM = PostsFeed.ItemViewModelType.tags(tagsVM)
        viewModels.append(itagsItemVM)
      }
      
      if posting.postingCommentsCount > 4 {
        let showAllCommentsVM = PostsFeed.PostsFeedAllCommentsViewModel(posting: posting)
        let showAllCommentsItemVM = PostsFeed.ItemViewModelType.showAllComments(showAllCommentsVM)
        viewModels.append(showAllCommentsItemVM)
      }
      
      let postingCommentsPreview = posting.postingCommentsPreview
      let postingCommentsPreviewLastIndex = postingCommentsPreview.count - 1
      let commentItemsVM: [PostsFeed.ItemViewModelType] =
        postingCommentsPreview
          .filter { !$0.isCommentDeleted }
          .enumerated()
          .map {
            //checking if first, last comments or first, last isisReplyComment
            
            var isLast = $0 == postingCommentsPreviewLastIndex
            var isFirst = $0 == 0
            
            if !isLast && $0 < postingCommentsPreviewLastIndex {
              isLast = !(postingCommentsPreview[$0 + 1].isReplyComment ?? false)
            }
            
            if !isFirst && $0 > 0 {
              isFirst = !(postingCommentsPreview[$0 - 1].isReplyComment ?? false)
            }
            
            let commentVM = PostsFeed.PostsFeedCommentViewModel(comment: $1, isFirst: isFirst, isLast: isLast, commentIndex: $0)
            return PostsFeed.ItemViewModelType.comment(commentVM)
      }
      
      viewModels.append(contentsOf: commentItemsVM)
     
      return viewModels
    }
    
    static func sectionViewModelFor(_ posting: PostingProtocol, shouldPresentClosedPromoStatus: Bool, userRequest: @escaping PostsFeedAddCommentViewModelUserRequestClojure) -> [PostsFeed.ItemViewModelType] {
      
      //UserViewModel
      
      var viewModels: [PostsFeed.ItemViewModelType] = []
      
      //Uploading
      
      if let uploadVM = PostsFeedUploadingViewModel(post: posting) {
        viewModels.append(.uploading(uploadVM))
        return viewModels
      }
      
      if let user = posting.postingUser {
        let vm = PostsFeed.UserViewModel(user, posting: posting)
        viewModels.append(.user(vm))
      }
      
      //ContentViewModel
      
      let contentViewModelTypes: [PostsFeed.ContentViewModelType] = posting.postingMedia
        .compactMap {
          switch $0.contentType {
          case .image:
            let vm = PostsFeed.ImageViewModel($0, post: posting)
            return PostsFeed.ContentViewModelType.image(vm)
          case .video:
            let vm = PostsFeed.VideoViewModel($0)
            return PostsFeed.ContentViewModelType.video(vm)
          case .unknown:
            return nil
          }
      }
      
      let contentVM = PostsFeed.ContentViewModel(content: contentViewModelTypes, userRequest: userRequest)
      let contentItemVM = PostsFeed.ItemViewModelType.content(contentVM)
      viewModels.append(contentItemVM)
      
      //Promotion
      
      if let promotionVM = PostsFeedPromotionViewModel(post: posting,
                                                       postPromotion: posting.postPromotion,
                                                       shouldShowStatusOnClosedPromo: shouldPresentClosedPromoStatus) {
        let promotionItemVM = PostsFeed.ItemViewModelType.promotionStatus(promotionVM)
        viewModels.append(promotionItemVM)
      }
      
      if let addPromotionVM = AddPromotionViewModel(post: posting) {
        let addPromotionItemVM = PostsFeed.ItemViewModelType.addPromotion(addPromotionVM)
        viewModels.append(addPromotionItemVM)
      }
      
      //Commercial
      
      if let commercialInfoVM = PostsFeedCommercialInfoViewModel(post: posting) {
        let commercialInfoItemVM = PostsFeed.ItemViewModelType.commercialInfo(commercialInfoVM)
        viewModels.append(commercialInfoItemVM)
      }
      
      if let commercialPostErrorVM = PostsFeedCommercialErrorViewModel(post: posting) {
        let commercialPostErrorItemVM = PostsFeed.ItemViewModelType.commercialPostError(commercialPostErrorVM)
        viewModels.append(commercialPostErrorItemVM)
      }
      
      if let goodsInfoVM = PostsFeedGoodPriceViewModel(post: posting) {
        let goodsInfoItemVm = PostsFeed.ItemViewModelType.goodsInfo(goodsInfoVM)
        viewModels.append(goodsInfoItemVm)
      }
      
      //Funding
      
      if let funding = posting.fundingCampaign {
        let fundingTitleVM = PostsFeed.PostsFeedFundingCampaignTitleViewModel(funding: funding, posting: posting)
        let fundingTitleItemVM = PostsFeed.ItemViewModelType.fundingCampaignTitle(fundingTitleVM)
        viewModels.append(fundingTitleItemVM)
        
        if let shouldPresentFundingExtension = posting.shouldPresentFundingExtension, shouldPresentFundingExtension {
          
//          let fundingStatusVM = PostsFeed.PostsFeedFundingCampaignStatusViewModel(funding: funding)
//          let fundingStatusItemVM = PostsFeed.ItemViewModelType.fundingCampaignStatus(fundingStatusVM)
//          viewModels.append(fundingStatusItemVM)
          
//          if let team = posting.fundingCampaignTeam {
//            let fundingTeamVM = PostsFeed.PostsFeedFundingCampaignTeamViewModel(team: team)
//            let fundingTeamItemVM = PostsFeed.ItemViewModelType.fundingCampaignTeam(fundingTeamVM)
//            viewModels.append(fundingTeamItemVM)
//          }
        }
      }
      
      //ActionsViewModel
      
      let actionsVM = PostsFeed.ActionsViewModel(posting: posting)
      let actionsItemVM = PostsFeed.ItemViewModelType.actions(actionsVM)
      
      viewModels.append(actionsItemVM)
      
      if let locationVM = PostsFeed.PostsFeedItemLocationViewModel(posting: posting) {
        let locationItemVM = PostsFeed.ItemViewModelType.location(locationVM)
        viewModels.append(locationItemVM)
      }
      
      //DescriptionViewModel
      
      if let descriptionVM = PostsFeed.DescriptionViewModel(posting: posting) {
        let descriptionItemVM = PostsFeed.ItemViewModelType.description(descriptionVM)
        viewModels.append(descriptionItemVM)
      }
      
      //EditDescriptionViewModel
      
      if let editDescriptionVM = PostsFeed.EditDescriptionViewModel(posting: posting) {
        let editDescriptionItemVM = PostsFeed.ItemViewModelType.editDescription(editDescriptionVM)
        viewModels.append(editDescriptionItemVM)
      }
      
      //PostsFeedTagContainerViewModel
      
      if posting.postingTags.count > 0 {
        let tagsVM = PostsFeed.PostsFeedTagContainerViewModel(posting: posting)
        let itagsItemVM = PostsFeed.ItemViewModelType.tags(tagsVM)
        viewModels.append(itagsItemVM)
      }
      
      //PostsFeedCommentViewModel
      //
      //      let sortedComments = posting.postingComments
      //        .sorted {
      //          $0.identifier >= $1.identifier
      //      }
      //      let comments = sortedComments.count > commentPreviewLimitCount ? Array(sortedComments[0..<commentPreviewLimitCount]) :
      //      sortedComments
      //
      //      let commentItemsVM: [PostsFeed.ItemViewModelType] = comments
      //        .reversed()
      //        .map {
      //          let commentVM = PostsFeed.PostsFeedCommentViewModel(comment: $0)
      //          return PostsFeed.ItemViewModelType.comment(commentVM)
      //      }
      
      if posting.postingCommentsCount > 4 {
        let showAllCommentsVM = PostsFeed.PostsFeedAllCommentsViewModel(posting: posting)
        let showAllCommentsItemVM = PostsFeed.ItemViewModelType.showAllComments(showAllCommentsVM)
        viewModels.append(showAllCommentsItemVM)
      }
      
      let postingCommentsPreview = posting.postingCommentsPreview
      let postingCommentsPreviewLastIndex = postingCommentsPreview.count - 1
      let commentItemsVM: [PostsFeed.ItemViewModelType] =
        postingCommentsPreview
          .filter { !$0.isCommentDeleted }
          .enumerated()
          .map {
            //checking if first, last comments or first, last isisReplyComment
            
            var isLast = $0 == postingCommentsPreviewLastIndex
            var isFirst = $0 == 0
            
            if !isLast && $0 < postingCommentsPreviewLastIndex {
              isLast = !(postingCommentsPreview[$0 + 1].isReplyComment ?? false)
            }
            
            if !isFirst && $0 > 0 {
              isFirst = !(postingCommentsPreview[$0 - 1].isReplyComment ?? false)
            }
            
            let commentVM = PostsFeed.PostsFeedCommentViewModel(comment: $1, isFirst: isFirst, isLast: isLast, commentIndex: $0)
            return PostsFeed.ItemViewModelType.comment(commentVM)
      }
      
      viewModels.append(contentsOf: commentItemsVM)
      
      if let vm = PostsFeedAddCommentViewModel(posting: posting,
                                               userRequest: userRequest) {
        viewModels.append(.addComment(vm))
      }
      
      return viewModels
    }
  }
  
  enum ContentViewModelType {
    case image(PostsFeedImageViewModelProtocol)
    case video(PostsFeedVideoViewModelProtocol)
    
    var contentSize: CGSize {
      switch self {
      case .image(let vm):
        return vm.contentSize
      case .video(let vm):
        return vm.contentSize
      }
    }
  }
  
  struct ContentViewModel: PostsFeedContentViewModelProtocol {
    let identifier: String
    let content: [ContentViewModelType]
    let contentSize: CGSize
    
    let soundHelpInfo: String
    let noSoundInfo: String
    let shouldPresentHelpForCurrentUserRequestClojure: UserLevelRequestClojure
    
    init(content: [ContentViewModelType], userRequest: @escaping PostsFeedAddCommentViewModelUserRequestClojure) {
      identifier = "ContentViewModel\(content.count)"
      self.content = content
      
      soundHelpInfo = PostsFeed.Strings.Video.soundHelpInfo.localize()
      noSoundInfo = PostsFeed.Strings.Video.soundless.localize()
      
      shouldPresentHelpForCurrentUserRequestClojure = { complete in
        userRequest() { obtainedUser in
          let shouldPresentHelp = obtainedUser.userLevel < 6
          complete(shouldPresentHelp)
        }
      }
      
      guard let firstItemContentSize = content.first?.contentSize else {
        contentSize = CGSize.zero
        return
      }
      
      let firstItemContentRatio = firstItemContentSize.width / firstItemContentSize.height
      var contentSizeToSet = firstItemContentSize
      content.forEach {
        let ratio =  $0.contentSize.width /  $0.contentSize.height
        if abs(ratio - firstItemContentRatio) > 0.0001 {
          contentSizeToSet = CGSize(width: firstItemContentSize.width, height: firstItemContentSize.width)
        }
      }
      
      contentSize = contentSizeToSet
    }
    
    func numberOfSections() -> Int {
      return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return content.count
    }
    
    func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeed.ContentViewModelType {
      return content[indexPath.item]
    }
  }
  
  enum PostsFeedActionsType {
    case upvote
    case upvoteInPlace
    case comment
    case shop
    case favorites
    case upvotedUsers
    case help
  }
  
  
  typealias ActionsTableViewCellHandler = (UITableViewCell, PostsFeed.PostsFeedActionsType) -> Void
  
  typealias PromotionActionsTableViewCellHandler = (UITableViewCell, PostsFeed.PromotionActions) -> Void
  
  typealias FundingCampaignStatusActionHandler = (UITableViewCell, PostsFeed.FundingCampaignActions) -> Void
  
  typealias TopGroupsHeaderActionHandler = (PostsFeedHomeTopGroupsHeaderView, TopGroupsHeaderActions) -> Void

  typealias CommercialPostActionsHandler = (UITableViewCell, PostsFeed.CommercialPostActions) -> Void

  
  struct ActionsViewModel: PostsFeedActionsViewModelProtocol {
    static let numberToStringsFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
      formatter.numberStyle = NumberFormatter.Style.decimal
      return formatter
    }()
    
    static func toStringWithFormatter(_ number: Double) -> String {
      let number = NSNumber(value: number)
      return numberToStringsFormatter.string(from: number) ?? ""
    }
    
    let isCollectPromoted: Bool
    let isUpvotePromoted: Bool
    
    var likesCountOldValue: Int
    var shouldAnimateLikesCount: Bool
    
    let likesTitleString: String
    
    let likesCount: Int
    
    let identifier: String
    
    let isShopItem: Bool = false
    
    let isLiked: Bool
    
    let shopItemsCount: String = "0"
    
    let commentsCount: String
    let isAddedToFavorites: Bool
    
    let isWinAmountVisible: Bool
    let winAmount: String
    
    let postHelpRequestReward: String
    let hasPostHelpRequest: Bool
    let isPostHelpRequestActive: Bool
    
    init(posting: PostingProtocol) {
      isCollectPromoted = posting.isCollectPromoted
      isUpvotePromoted = posting.isUpvotePromoted
      
      likesCount = posting.postingUpVotesAmountDraft
      likesCountOldValue = posting.postingUpVotesAmount
      shouldAnimateLikesCount = posting.postingUpVotesAmount != posting.postingUpVotesAmountDraft
      
      likesTitleString = PostsFeed.Strings.brushed.localize()
      
      commentsCount = String(posting.postingCommentsCount)
      isLiked = posting.isUpVotedByUser
      isAddedToFavorites = posting.isPostingAddedToFavorites
      
      hasPostHelpRequest = posting.postHelpRequest != nil
      isPostHelpRequestActive = !(posting.postHelpRequest?.isHelpClosed ?? true)
      if let reward = posting.postHelpRequest?.rewardAmount.value {
        postHelpRequestReward = String(format: "%.0f", reward)
      } else {
        postHelpRequestReward = ""
      }
      
      let prize = posting.winnerPrize ?? 0.0
      isWinAmountVisible = !prize.isZero
      
      winAmount = isWinAmountVisible ? ActionsViewModel.toStringWithFormatter(prize) : ""
      
      identifier = ["Actions_\(posting.identifier)",String(likesCount), commentsCount, String(isLiked), String(isAddedToFavorites), String(isCollectPromoted), String(isUpvotePromoted), String(isPostHelpRequestActive), String(hasPostHelpRequest), winAmount].joined(separator: "_")
      
    }
  }
  
  struct DescriptionViewModel: PostsFeedDescriptionViewModelProtocol {
    let identifier: String
    let postingDateTitle: String
    let attributedCaption: NSAttributedString
    let caption: String
    
    init?(posting: PostingProtocol) {
      let isBeingEditedState = posting.isBeingEditedState ?? false
      
      guard !isBeingEditedState else {
        return nil
      }
     
      let postingDate = posting.postingCreatedAt.timeAgoSinceNow(useNumericDates: true)
      
      postingDateTitle = postingDate
      caption = posting.postingCaption
      let captionWithDate = NSMutableAttributedString()
      if caption.count > 0 {
        captionWithDate
          .append(NSAttributedString(string: "\(caption) ",
            attributes: [
              NSAttributedString.Key.font: UIFont.AvenirNextRegular(size: 13),
              NSAttributedString.Key.foregroundColor: UIConstants.Colors.captionBody
            ]))
      }
      captionWithDate
        .append(NSAttributedString(string: postingDateTitle,
                                   attributes: [
                                    NSAttributedString.Key.font: UIFont.AvenirNextRegular(size: 13),
                                    NSAttributedString.Key.foregroundColor: UIConstants.Colors.captionDate
                                    
          ]))
      
      
      identifier = "Description_\([caption].joined())"
      attributedCaption = captionWithDate //NSAttributedString(string: caption, attributes: [NSAttributedStringKey.font : UIFont.AvenirNextRegular(size: 13)])
    }
    
  }
  
  struct EditDescriptionViewModel: PostsFeedEditDescriptionViewModelProtocol {
    let identifier: String
    let caption: String
    
    init?(posting: PostingProtocol) {
      guard let isBeingEditedState = posting.isBeingEditedState, isBeingEditedState else {
        return nil
      }
      
      caption = posting.postingCaption
      identifier = "EditDescription_\(posting.identifier)"
    }
  }
  
  struct PostsFeedCommentViewModel: PostsFeedCommentViewModelProtocol {
    let commentIndex: Int
    let isFirst: Bool
    let isLast: Bool
    
    let identifier: String
    let username: String
    let userPic: String
    let body: String
    let isReply: Bool
    let isPending: Bool
    let atrributedCommentWithUsername: NSAttributedString
    
    init(comment: CommentProtocol, isFirst: Bool, isLast: Bool, commentIndex: Int) {
      username = comment.commentUser?.userName ?? ""
      userPic = comment.commentUser?.userpicUrlString ?? ""
      body = comment.commentBody
      
      let isParentCommentDeleted = comment.isParentCommentDeleted ?? false
      let isReplyComment = comment.isReplyComment ?? false
      isReply = isReplyComment && !isParentCommentDeleted
      self.isFirst = isFirst
      self.isLast = isLast
      self.commentIndex = commentIndex
      isPending = comment.isDraftComment
      
      let attrString = NSMutableAttributedString()
      let attrUsername = NSAttributedString(string: "\(username.capitalized): ",
        attributes: [
          NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 13),
          NSAttributedString.Key.foregroundColor: UIConstants.Colors.commentUser
        ])
      
      attrString.append(attrUsername)
      
      let attrBody = NSAttributedString(string: body,
                                        attributes: [
                                          NSAttributedString.Key.font: UIFont.AvenirNextRegular(size: 13),
                                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.commentBody
                                          
        ])
      attrString.append(attrBody)
      atrributedCommentWithUsername = attrString
      
      identifier = "CommentId\(comment.identifier)\(isLast)\(isFirst)\(commentIndex)"
    }
  }
  
  struct PostsFeedAllCommentsViewModel: PostsFeedAllCommentsViewModelProtocol {
    let identifier: String
    let shouldPresentShowAllTitle: Bool
    let showAllCommentsTitle: String
    
    
    init(posting: PostingProtocol) {
      self.showAllCommentsTitle = PostsFeed.Strings.showAllCommentsTitle.localize(value: "\(posting.postingCommentsCount)")
      shouldPresentShowAllTitle = posting.postingCommentsCount > 3
      identifier = showAllCommentsTitle
    }
  }
  
  struct PostsFeedDateViewModel: PostsFeedDateViewModelProtocol {
    let identifier: String
    let postingDateTitle: String
    let brushedCountTitle: String
    let brushedCountAttributedTitle : NSAttributedString
    
    init(posting: PostingProtocol) {
      let dateFormatter = DateFormatter()
      //2018-08-08T13:05:41.000Z
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      let postingDate = posting.postingCreatedAt.timeAgoSinceNow(useNumericDates: true)
     
      postingDateTitle = postingDate
      brushedCountTitle = PostsFeed.Strings.brushedCount.localize(value: "\(posting.postingUpVotesCount)")
      
      let attrbrushedCountString = NSMutableAttributedString()
      let attrCount = NSAttributedString(string: "\(posting.identifier) ", attributes: [NSAttributedString.Key.font : UIFont.AvenirNextMedium(size: 13)])
      
      attrbrushedCountString.append(attrCount)
      
      let attrBrushed = NSAttributedString(string: PostsFeed.Strings.brushed.localize(), attributes: [NSAttributedString.Key.font : UIFont.AvenirNextRegular(size: 13)])
      
      attrbrushedCountString.append(attrBrushed)
      
      brushedCountAttributedTitle = attrbrushedCountString
      identifier = [postingDateTitle, brushedCountTitle].joined()
    }
  }
  
  
  struct PostsFeedTagViewModel: PostsFeedTagViewModelProtocol {
    var isPromoted: Bool
    
    let identifier: String
    let tagTitle: String
    let attributedTagTitle: NSAttributedString
    
    init(tagTitle: String, isPromoted: Bool) {
      self.isPromoted = isPromoted
      self.tagTitle = "#\(tagTitle)"
      identifier = "\(tagTitle)\(isPromoted)"
      
      guard tagTitle.count > 0 else {
        attributedTagTitle = NSAttributedString(string: "")
        return
      }
      
      attributedTagTitle = NSAttributedString()
      //      let attrbrushedTagString = NSMutableAttributedString()
      //      let attrCount = NSAttributedString(string: "#", attributes: [NSAttributedStringKey.font : UIFont.AvenirNextRegular(size: 13)])
      //
      //      attrbrushedTagString.append(attrCount)
      //
      //      let attrBrushed = NSAttributedString(string: tagTitle, attributes: [NSAttributedStringKey.font : UIFont.AvenirNextMedium(size: 13)])
      //
      //      attrbrushedTagString.append(attrBrushed)
      //
      //      attributedTagTitle = attrbrushedTagString
      
    }
  }
  
  struct PostsFeedTagContainerViewModel: PostsFeedTagContainerViewModelProtocol {
    let isPromoted: Bool
    
    let identifier: String
    fileprivate let tags: [[PostsFeedTagViewModelProtocol]]
    
    func numberOfSections() -> Int {
      return tags.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return tags[section].count
    }
    
    func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeedTagViewModelProtocol {
      return tags[indexPath.section][indexPath.item]
    }
    
    init(posting: PostingProtocol) {
      isPromoted = posting.isTagPromoted
      
      let tagsInPosting = posting.postingTags
        .map { return PostsFeedTagViewModel(tagTitle: $0, isPromoted: posting.isTagPromoted) }
      
      tags = [tagsInPosting]
      identifier = "\(tagsInPosting.map { $0.identifier }.joined())\(isPromoted)"
    }
  }
  
  struct UserViewModel: PostsFeedUserViewModelProtocol {
    static let numberToStringsFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
      formatter.numberStyle = NumberFormatter.Style.decimal
      return formatter
    }()
    
    static func toStringWithFormatter(_ number: Double) -> String {
      let number = NSNumber(value: number)
      return numberToStringsFormatter.string(from: number) ?? ""
    }
    
    let prizeImage: UIImage?
    
    let prizeAmount: String
    
    let identifier: String
    let followActionTitle: String
    let followingTitleColor: UIColor
    let friendActionTitle: String
    let muteActionTitle: String
    let followingTitle: String
    let userScores: String
    let username: String
    let userpicPlaceholder: UIImage?
    let userPic: String
    
    init(_ user: UserProtocol, posting: PostingProtocol) {
      self.username = user.userName.capitalized
      self.userPic = user.userpicUrlString
      userpicPlaceholder = UIImage.avatarImageForNameString(user.userName)
      
      userScores = PostsFeed.Strings.userScores(redBrush: user.redBrushWalletBalance, greenBrush: user.greenBrushWalletBalance, level: user.userLevel)
      
      muteActionTitle = PostsFeed.Strings.mute.localize()
      
      followingTitleColor = user.isFollowedByCurrentUser ?
        UIConstants.Colors.userIsFollowingColor :
        UIConstants.Colors.userIsNotFollowingColor
      
      followActionTitle = user.isFollowedByCurrentUser ?
        PostsFeed.Strings.unfollowAction.localize() :
        PostsFeed.Strings.followAction.localize()
      
      friendActionTitle = user.isFriendWithCurrentUser ?
        PostsFeed.Strings.unfriendAction.localize() :
        PostsFeed.Strings.friendAction.localize()
      
      followingTitle = posting.isMyPosting ? "" : (user.isFollowedByCurrentUser ? PostsFeed.Strings.following.localize() : PostsFeed.Strings.notFollowing.localize())
      let prize = (user.userWonPrizeAmount ?? 0.0)
      if prize.isZero {
        prizeAmount = ""
        prizeImage = UIImage(imageLiteralResourceName: "PostsFeed-WinPrize")
      } else {
        prizeAmount = UserViewModel.toStringWithFormatter(prize)
        prizeImage = UIImage(imageLiteralResourceName: "PostsFeed-WinPrize-selected")
      }
      
      
      identifier = [followActionTitle, friendActionTitle, muteActionTitle, followingTitle, userScores, username, userPic, prizeAmount].joined()
    }
  }
  
  struct ImageViewModel: PostsFeedImageViewModelProtocol {
    let shouldPresentVerificationWarning: Bool
    
    let contentSize: CGSize
    
    let urlString: String
    
    init(_ media: MediaProtocol, post: PostingProtocol) {
      self.urlString = media.mediaUrl
      contentSize = CGSize(width: media.contentWidth, height: media.contentHeight)
      shouldPresentVerificationWarning = post.isMyPosting && media.shouldPassBitDNA && !media.passedBitDNA
    }
  }
  
  struct ImageThumbnailViewModel: PostsFeedImageViewModelProtocol {
    let shouldPresentVerificationWarning: Bool
    
    let contentSize: CGSize
    
    let urlString: String
    
    init(_ media: MediaProtocol, post: PostingProtocol) {
      self.urlString = media.thumbnailUrl
      contentSize = CGSize(width: media.contentWidth, height: media.contentHeight)
      shouldPresentVerificationWarning = false //post.isMyPosting && media.shouldPassBitDNA && !media.passedBitDNA
    }
  }
  
  struct VideoViewModel: PostsFeedVideoViewModelProtocol {
    let contentSize: CGSize
    let urlString: String
    let thumbnailImageUrlString: String
    
    init(_ media: MediaProtocol) {
      urlString = media.mediaUrl
      thumbnailImageUrlString = media.posterUrl
      contentSize = CGSize(width: media.contentWidth, height: media.contentHeight)
    }
  }
  
  struct VideoThumbnailViewModel: PostsFeedVideoViewModelProtocol {
    let contentSize: CGSize
    let urlString: String
    let thumbnailImageUrlString: String
    
    init(_ media: MediaProtocol) {
      urlString = media.mediaUrl
      thumbnailImageUrlString = media.thumbnailUrl
      contentSize = CGSize(width: media.contentWidth, height: media.contentHeight)
    }
  }
  
  typealias PostsFeedAddCommentViewModelUserRequestCompletion = (UserProtocol) -> Void
  typealias PostsFeedAddCommentViewModelUserRequestClojure = (@escaping PostsFeedAddCommentViewModelUserRequestCompletion) -> Void
  
  struct PostsFeedAddCommentViewModel: PostsFeedAddCommentViewModelProtocol {
    var currentUserAvatarRequestClojure: AvatarRequestClojure
    let identifier: String
    
    let commentText: String
    let isSendButtonActive: Bool
    
    init?(posting: PostingProtocol, userRequest: @escaping PostsFeedAddCommentViewModelUserRequestClojure) {
      guard let hasNewCommentDraft = posting.hasNewCommentDraft, hasNewCommentDraft else {
        return nil
      }
      
      if let isBeingEditedState = posting.isBeingEditedState, isBeingEditedState {
        return nil
      }
      
      currentUserAvatarRequestClojure = { complete in
        userRequest() { obtainedUser in
          let userpicString = obtainedUser.userpicUrlString
          let userpicPlaceholder = UIImage.avatarImageForNameString(obtainedUser.userName)
          
          complete(userpicString, userpicPlaceholder)
        }
      }
      
      commentText = posting.newCommentDraft ?? ""
      //identifier do not include comment draft text, so view model draft text changes won't trigger tableView updates
      
      identifier = "Draft\(posting.identifier)commentsCount\(posting.postingCommentsCount)"
      isSendButtonActive = self.commentText.count > 0
    }
  }
  
  struct PostsFeedFundingCampaignStatusViewModel: PostsFeedFundingCampaignStatusViewModelProtocol {
    let raisedPerCent: String
    let raisedAmount: String
    let goalAmount: String
    let identifier: String
    let campaignProgress: Double
    
    init(funding: FundingCampaignProtocol) {
      campaignProgress = min(1.0, funding.campaignCollectedAmount / funding.campaignGoalAmount)
       let percent = 100.0 * (funding.campaignCollectedAmount / funding.campaignGoalAmount)
      
      raisedPerCent = "\(String(format: "%.0f", percent))%"
      raisedAmount = String(format: "%.0f %@", funding.campaignCollectedAmount, funding.fundingCurrency.symbol)
      goalAmount = String(format: "%.0f %@", funding.campaignGoalAmount, funding.fundingCurrency.symbol)
      identifier = "\(raisedAmount)_\(goalAmount)"
    }
  }
  
  struct PostsFeedFundingCampaignTitleViewModel: PostsFeedFundingCampaignTitleViewModelProtocol {
    let identifier: String
    
    let campaignTitle: String
   
    let campaignDonateActionName: String
    let campaignEndingDate: String
    let isActive: Bool
    
    init(funding: FundingCampaignProtocol, posting: PostingProtocol) {
      campaignTitle = funding.campaignTitle
     
      switch funding.campaignStatus {
      case .succeeded:
        isActive = false
      case .failed:
        isActive = false
      case .processing:
        isActive = true
      case .unsupportedStatus:
        isActive = true
      }
      
      
      identifier = "\(posting.identifier)_\(campaignTitle)_\(isActive)"
      
      guard isActive else {
        campaignEndingDate = ""
        campaignDonateActionName = Strings.FundingCampaignSection.ActionButton.ended.localize()
        return
      }
      
      let intervalTillEnd = abs(funding.campaignEndDate.timeIntervalSinceNow)
      let days = floor(intervalTillEnd / TimeInterval.daysInterval(1))
      campaignEndingDate = Strings.FundingCampaignSection.daysLeft.localize(value: String(format: "%.0f", days))
      
      switch posting.postingType {
      case .media, .commercial, .goods:
        campaignDonateActionName = ""
      case .funding:
        campaignDonateActionName = Strings.FundingCampaignSection.ActionButton.contribute.localize()
      case .charity:
        campaignDonateActionName = Strings.FundingCampaignSection.ActionButton.donate.localize()
      case .crowdfundingWithReward:
        campaignDonateActionName = Strings.FundingCampaignSection.ActionButton.pledge.localize()
       
      }
    }
  }
  
  struct PostsFeedItemLocationViewModel: PostsFeedItemLocationViewModelProtocol {
    let identifier: String
    let locationDescription: String
    let isHighlighted: Bool
    
    init?(posting: PostingProtocol) {
      if let location = posting.postingPlace, location.locationDescription.count > 0 {
        locationDescription = location.locationDescription
        identifier = locationDescription
        isHighlighted = false
        return
      }
      
      if let isBeingEditedState = posting.isBeingEditedState, isBeingEditedState {
        locationDescription = PostsFeed.Strings.locationDescription.localize()
        identifier = locationDescription
        isHighlighted = true
        return
      }
      
      return nil
    }
  }
  
  struct PostsFeedFundingCampaignTeamViewModel: PostsFeedFundingCampaignTeamViewModelProtocol {
    let teamLogoURLString: String?
    let teamName: String
    let teamInfo: String
    let identifier: String
    
    init(team: FundingCampaignTeamProtocol) {
      teamLogoURLString = team.teamLogoUrlString
      teamName = team.teamTitle
      teamInfo = "\(team.teamMembersCount)"
      
      identifier = "\(teamName)_\(teamInfo)_\(teamLogoURLString ?? "")"
    }
  }
  
  struct PostsFeedPromotionViewModel: PostsFeedItemPromotionViewModelProtocol {
    let statusTitle: String
    
    
    let backgroundColor: UIColor
    
    let actionTitle: String
    let identifier: String
    
    
    init?(post: PostingProtocol, promotionDraft: PromotionDraft) {
      guard let destination = promotionDraft.destination else {
        return nil
      }
      
      switch destination {
      case .userProfile(let action):
        actionTitle = action.actionTitle
      case .url(_, let action):
        actionTitle = action.actionTitle
      }
      
      statusTitle = ""
      identifier = actionTitle
      
      guard let lastDigitChar = String(post.identifier).last,
        let lastDigitInt = Int(String(lastDigitChar)) else {
          backgroundColor = UIConstants.Colors.promotionColors[0]
          return
      }
      
      guard !(0...2).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[0]
        return
      }
      
      guard !(3...5).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[1]
        return
      }
      
      guard !(6...7).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[2]
        return
      }
      
      guard !(8...9).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[3]
        return
      }
      
      backgroundColor = UIConstants.Colors.promotionColors[3]
    }
    
    init?(post: PostingProtocol, postPromotion: PostPromotionProtocol?, shouldShowStatusOnClosedPromo: Bool) {
      guard let postPromotion = postPromotion else {
        return nil
      }
      
      switch postPromotion.promotionStatus {
      case .active:
        break
      case .paused:
        guard post.isMyPosting else {
          return nil
        }
      case .closed:
        guard post.isMyPosting else {
          return nil
        }
      }
      
      actionTitle = postPromotion.promotionActionButton
      identifier = postPromotion.promotionStatus.rawValue
      
      switch postPromotion.promotionStatus {
      case .active:
        statusTitle = ""
      case .paused:
        statusTitle = postPromotion.promotionStatus.localizedTitle
        backgroundColor = UIConstants.Colors.Promotion.paused
        return
      case .closed:
        statusTitle = postPromotion.promotionStatus.localizedTitle
        backgroundColor = UIConstants.Colors.Promotion.closed
        return
      }
      
      guard let lastDigitChar = String(post.identifier).last,
        let lastDigitInt = Int(String(lastDigitChar)) else {
          backgroundColor = UIConstants.Colors.promotionColors[0]
          return
      }
      
      guard !(0...2).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[0]
        return
      }
      
      guard !(3...5).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[1]
        return
      }
      
      guard !(6...7).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[2]
        return
      }
      
      guard !(8...9).contains(lastDigitInt) else {
        backgroundColor = UIConstants.Colors.promotionColors[3]
        return
      }
      
      backgroundColor = UIConstants.Colors.promotionColors[3]
    }
  }
  
  struct ItemLayout {
    let size: CGSize
    
    static func defaultLayout() -> ItemLayout {
      return ItemLayout(size: CGSize.zero)
    }
  }
  
  struct PostsFeedUploadingViewModel: PostsFeedUploadingViewModelProtocol {
    let stateTitle: String
    let progress: CGFloat
    let cancelButtonEnabled: Bool
    let restartButtonEnabled: Bool
    let identifier: String
    let shouldPresentProgress: Bool
    
    init?(post: PostingProtocol) {
      guard let postingDraftAttributes = post.postingDraftAttributes else {
        return nil
      }
      
      stateTitle = PostsFeed.Strings.titleFor(postingDraftAttributes.status)
      if case PostCreationStatus.uploading = postingDraftAttributes.status {
        shouldPresentProgress = true
      } else {
        shouldPresentProgress = false
      }
      
      cancelButtonEnabled = true
      restartButtonEnabled = false
      progress = PostsFeed.Strings.progressFor(postingDraftAttributes.status)
      identifier = "\(post.postUUID)_\(progress)_\(stateTitle)"
    }
  }
  
  struct PostsFeedGoodPriceViewModel: PostsFeedGoodsInfoViewModelProtocol {
    
    let commercialPostPrice: String
    let commercialPostSalesCount: String
    let isNewGood: Bool
    let isAvailabilityStatusVisible: Bool
    let availabilityStatusString: String
    
    let identifier: String
    
    init?(post: PostingProtocol) {
      guard case PostType.goods = post.postingType,
        let goodsInfo = post.goodsInfo
      else {
        return nil
      }
      
      switch goodsInfo.availabilityStatus {
      case .available:
        isAvailabilityStatusVisible = false
        availabilityStatusString = goodsInfo.availabilityStatus.title
      case .booked:
        isAvailabilityStatusVisible = true
        availabilityStatusString = goodsInfo.availabilityStatus.title
      case .soldOut:
        isAvailabilityStatusVisible = true
        availabilityStatusString = goodsInfo.availabilityStatus.title
      case .unsupportedStatus:
        isAvailabilityStatusVisible = false
        availabilityStatusString = goodsInfo.availabilityStatus.title
      }
      
      commercialPostPrice = "\(String(format:"%.0f", goodsInfo.goodsPrice)) \(BalanceCurrency.pibble.symbol)"
      commercialPostSalesCount = ""
      isNewGood = goodsInfo.isNewGoodsStatus
      identifier = ["\(post.identifier)", "\(goodsInfo.identifier)", commercialPostPrice, commercialPostSalesCount, availabilityStatusString].joined(separator: "_")

    }
  }
  
  struct PostsFeedCommercialInfoViewModel: PostsFeedCommercialInfoViewModelProtocol {
    let status: String
    let isStatusEnabled: Bool
    let commercialPostTitle: String
    let commercialPostPrice: String
    let rewardAmountLabel: String
    let identifier: String
    
    init?(post: PostingProtocol) {
      guard let commerceInfo = post.commerceInfo else {
        return nil
      }
      
      guard commerceInfo.commerceProcessingStatus == .success || post.isMyPosting else {
        return nil
      }
      
      commercialPostTitle = commerceInfo.commerceItemTitle
      commercialPostPrice = "\(commerceInfo.commerceItemPrice) \(BalanceCurrency.pibble.symbol)"
      
      rewardAmountLabel = "\(String(format:"%.0f", commerceInfo.commerceReward * 100))%"
      
      isStatusEnabled = commerceInfo.commerceProcessingStatus != .success
      status = PostsFeed.Strings.statusTitleFor(commerceInfo.commerceProcessingStatus)
      identifier =  [String(post.identifier), commercialPostTitle, commercialPostPrice, rewardAmountLabel, status].joined(separator: "_")
    }
  }
  
  struct PostsFeedCommercialErrorViewModel: PostsFeedCommercialErrorViewModelProtocol {
    var errorMessage: String
    var identifier: String
    
    init?(post: PostingProtocol) {
      guard let commerceInfo = post.commerceInfo else {
        return nil
      }
      
      guard post.isMyPosting else {
        return nil
      }
      
      guard let error = commerceInfo.commerceProcessingError else {
        return nil
      }
      
      errorMessage = "\(error.description)"
      identifier = errorMessage
    }
  }
  
  enum PostsFeedPlaceholderViewModel: PostsFeedItemsPlaceholderProtocol {
    case currentUserGoods
    case currentPurchasedGoods
    case usersPromotedPosts(_ promotionStatus: PromotionStatus)
    
    case currentUserActiveFundings
    case currentUserEndedFundings
    case currentUserDonatedFundings
    
    var image: UIImage? {
      switch self {
      case .currentUserGoods:
        return UIImage(imageLiteralResourceName: "PostsFeed-MyCommerceItemsPlaceholder")
      case .currentPurchasedGoods:
        return UIImage(imageLiteralResourceName: "PostsFeed-MyPurchasedCommerceItemsPlaceholder")
      case .usersPromotedPosts(_):
        return UIImage(imageLiteralResourceName: "PostsFeed-PromotedPostsPlaceholder")
      case .currentUserActiveFundings:
        return UIImage(imageLiteralResourceName: "PostsFeed-FundingItemsPlaceholder")
      case .currentUserEndedFundings:
        return UIImage(imageLiteralResourceName: "PostsFeed-FundingItemsPlaceholder")
      case .currentUserDonatedFundings:
        return UIImage(imageLiteralResourceName: "PostsFeed-FundingItemsPlaceholder")
      }
    }
    
    var isCreateButtonEnabled: Bool {
      switch self {
      case .currentUserGoods:
        return true
      case .currentPurchasedGoods:
        return false
      case .usersPromotedPosts(_):
        return false
      case .currentUserActiveFundings:
        return false
      case .currentUserEndedFundings:
        return false
      case .currentUserDonatedFundings:
        return false
      }
    }
    
    var title: String {
      switch self {
      case .currentUserGoods:
        return Strings.PlaceholderTitle.currentUserCommercePosts.localize()
      case .currentPurchasedGoods:
        return Strings.PlaceholderTitle.currentUserPurchasedPosts.localize()
      case .usersPromotedPosts(let promotionStatus):
        return Strings.PlaceholderTitle.userPromotedPosts.localize(value: promotionStatus.localizedTitle)
      case .currentUserActiveFundings:
        return Strings.FundingPlaceholderTitle.currentUserActiveFundings.localize()
      case .currentUserEndedFundings:
        return Strings.FundingPlaceholderTitle.currentUserEndedFundings.localize()
      case .currentUserDonatedFundings:
        return Strings.FundingPlaceholderTitle.currentUserBackedFundings.localize()
      }
    }
    
    var subTitle: String {
      switch self {
      case .currentUserGoods:
        return Strings.PlaceholderSubtitle.currentUserCommercePosts.localize()
      case .currentPurchasedGoods:
        return Strings.PlaceholderSubtitle.currentUserPurchasedPosts.localize()
      case .usersPromotedPosts:
        return ""
      case .currentUserActiveFundings:
        return ""
      case .currentUserEndedFundings:
        return ""
      case .currentUserDonatedFundings:
        return ""
      }
    }
  }
  
  struct AddPromotionViewModel: PostsFeedAddPromotionViewModelProtocol {
    let isAddButtonVisible: Bool
    let identifier: String
    let addButtonColor: UIColor
    
    init?(post: PostingProtocol)  {
      guard post.isMyPosting, post.postPromotion == nil else {
        return nil
      }
      
      isAddButtonVisible = true
      identifier = "\(post.identifier)"
      
      guard let lastDigitChar = String(post.identifier).last,
        let lastDigitInt = Int(String(lastDigitChar)) else {
          addButtonColor = UIConstants.Colors.promotionColors[0]
          return
      }
      
      guard !(0...2).contains(lastDigitInt) else {
        addButtonColor = UIConstants.Colors.promotionColors[0]
        return
      }
      
      guard !(3...5).contains(lastDigitInt) else {
        addButtonColor = UIConstants.Colors.promotionColors[1]
        return
      }
      
      guard !(6...7).contains(lastDigitInt) else {
        addButtonColor = UIConstants.Colors.promotionColors[2]
        return
      }
      
      guard !(8...9).contains(lastDigitInt) else {
        addButtonColor = UIConstants.Colors.promotionColors[3]
        return
      }
      
      addButtonColor = UIConstants.Colors.promotionColors[3]
    }
  }
  
  
  struct TopGroupItemViewModel: PostsFeedTopGroupItemViewModelProtocol {
   
    let identifier: String
    
    let title: String
    let image: UIImage?
    var bannerMessage: String
    let isSelected: Bool
    
    let expirationDate: Date?
    
    let bannerImageURLString: String
    let hasBannerImage: Bool
    var hasBannerMessage: Bool
    
    init(_ group: TopGroup, isSelected: Bool) {
      image = group.type.iconImage
      title = group.type.localizedTitle
      self.isSelected = isSelected
      identifier = "\(title)_\(isSelected)"
      
      bannerImageURLString = group.bannerImageURLString
      hasBannerImage = group.type.hasBanner
      bannerMessage = group.bannerMessage
      hasBannerMessage = group.bannerMessage.count > 0
      
      expirationDate = group.type.hasExpiration ? group.expirationDate : nil
    }
  }
  
  struct HomeTopGroupsHeaderViewModel: PostsFeedHomeTopGroupsHeaderViewModelProtocol {
    let bannerImageURLString: String
    let expirationDate: Date?
    let bannerMessage: String
    
    
    let shouldShowBanner: Bool
    let shouldShowFooter: Bool
    let shouldShowBannerMessage: Bool
    let groupViewModels: [PostsFeedTopGroupItemViewModelProtocol]
    
    func numberOfSections() -> Int {
      return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return groupViewModels.count
    }
    
    func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeedTopGroupItemViewModelProtocol {
      return groupViewModels[indexPath.item]
    }
    
    func diffWithPrevious(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol) -> [CollectionViewModelUpdate] {
      let diff = groupViewModels.map { $0.identifier }.diff(before: vm.groupViewModels.map { $0.identifier })
      
      return diff.collectionViewUpdatesForSection(0)
    }
    
    func timerLabelForTimeInterval(_ timeinterval: TimeInterval) -> String {
      return "\((abs(timeinterval)).formattedHoursMinutesSecondsTimeString) \(Strings.TopGroupsHeader.timerLeftTitle.localize())"
    }

    init(_ groups: [TopGroup], selectedGroupType: TopGroupPostsType?) {
      groupViewModels = groups.map { TopGroupItemViewModel($0, isSelected: selectedGroupType == $0.type ) }
      
      guard let selectedGroup = groups.first(where: { $0.type == selectedGroupType})  else {
        bannerImageURLString = ""
        expirationDate = nil
        shouldShowBanner = false
        shouldShowFooter = false
        shouldShowBannerMessage = false
        bannerMessage = ""
        return
      }
      
      let selectedItemVM = TopGroupItemViewModel(selectedGroup, isSelected: true)
      
      bannerImageURLString = selectedItemVM.bannerImageURLString
      expirationDate = selectedItemVM.expirationDate
      shouldShowBanner = selectedItemVM.hasBannerImage
      shouldShowFooter = selectedItemVM.expirationDate != nil
      shouldShowBannerMessage = selectedItemVM.hasBannerMessage
      bannerMessage = selectedItemVM.bannerMessage
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    
    static let userIsNotFollowingColor = UIColor.bluePibble //UIColor.bluePibble
    static let userIsFollowingColor = UIColor.black //UIColor.yellowPibble
    
    
    static let captionBody = UIColor.black
    static let captionDate = UIColor.gray191
    
    static let commentBody = UIColor.gray124
    static let commentUser = UIColor.black
    
    static let promotionColors: [UIColor] = [UIColor.yellowPromoCell, UIColor.bluePromoCell, UIColor.greenPromoCell, UIColor.pibbleBluePromoCell]
    
    enum Promotion {
      static let closed = UIColor.black
      static let paused = UIColor.gray168
    }
  }
  
}


extension PostsFeed {
  enum Strings: String, LocalizedStringKeyProtocol {
    case budgetTitleWithBudgets = "Promoted (%/%)"
    case locationDescription = "Add Location..."
    case brushedCount = "% Brushed"
    case showAllCommentsTitle = "View all % comments"
    
    case deletePostConfirmation = "Delete Post?"
    case notEnoughFundsForPostDeleteWithSymbol = "Insufficient % for Deleting"
    case alertTitleForInvoiceWithValueSymbolUsername = "Checkout % % %to buy this item"
    case alertMessageForPostDeleteWithValueSymbol = "Consume: % %"
    
    case alertTitleForGoodsOrderValueSymbol = "Checkout % % to buy this item. Your payment will be escrowed by system until you confirm."
    case alertTitleForPostHelpCreation = "Would you like to checkout % to start your asking help now?"
    
    case brushed = "Brushed"
    
    case following = "FOLLOWING"
    case notFollowing = "FOLLOW"
    
    case mute = "Mute"
    case followAction = "Follow"
    case unfollowAction = "Unfollow"
    case friendAction = "Add friends"
    case unfriendAction = "Remove friends"
    
    case teamMembers = "Members: "
    
    enum Video: String, LocalizedStringKeyProtocol  {
      case soundHelpInfo = "Tap to turn on sound"
      case soundless = "No sound video"
    }
    
    enum TitleForCreationStatus: String, LocalizedStringKeyProtocol {
      case preparing = "Preparing..."
      case uploading = "Publishing..."
      case failed = "Error occurred when creating post"
      case completed = "Published"
      case cancelled = "Cancelled"
    }
    
    enum StatusTitleForCommerce: String, LocalizedStringKeyProtocol {
      case waiting = "Waiting"
      case inProgress = "In-Progress"
      case failed = "Failed"
      case success = "Success"
    }
    
    enum FundingCampaignSection: String, LocalizedStringKeyProtocol {
      case daysLeft = "% days left"
      
      enum ActionButton: String, LocalizedStringKeyProtocol {
        case ended = "Ended"
        case donate = "DONATE"
        case contribute = "CONTRIBUTE"
        case pledge = "PLEDGE"
      }
    }
    
    enum EditAlerts: String, LocalizedStringKeyProtocol {
      case removeLocationAction = "Remove Location"
      case changeLocationAction = "Change Location"
      case cancelAction = "Cancel"
    }
    
    enum NavigationBarTitles: String, LocalizedStringKeyProtocol {
      case currentUserCommercePosts = "My Goods"
      case currentUserPurchasedPosts = "My Purchases"
      case postPromotionPreview = "Preview Promotion"
    }
    
    enum PlaceholderTitle: String, LocalizedStringKeyProtocol {
      case currentUserCommercePosts = "Become an Author"
      case currentUserPurchasedPosts = "No purchased item"
      case userPromotedPosts = "No % promotion"
    }
    
    enum FundingPlaceholderTitle: String, LocalizedStringKeyProtocol {
      case currentUserActiveFundings = "There is no funding campaign in progress."
      case currentUserEndedFundings = "There is no ended funding campaign."
      case currentUserBackedFundings = "There is no campaign contributed."
    }
    
    enum PlaceholderSubtitle: String, LocalizedStringKeyProtocol {
      case currentUserCommercePosts = "Post your photos for quality and originality."
      case currentUserPurchasedPosts = ""
    }
    
    enum TopGroupsHeader: String, LocalizedStringKeyProtocol {
      case timerLeftTitle = "Left"
    }
    
    enum Alerts: String, LocalizedStringKeyProtocol {
      enum PromotionActions: String, LocalizedStringKeyProtocol {
        case pause = "Pause"
        case resume = "Resume"
        case close = "Close"
        case insight = "Insight"
      }
      
      enum FundingActions: String, LocalizedStringKeyProtocol {
        case donators = "Supporters"
        case details = "Raised"
      }
      
      enum PromotionMessages: String, LocalizedStringKeyProtocol {
        case pause = "This promotion will be paused.  You can resume anytime."
        case resume = "Are you sure to reactivate this promotion?"
        case close = "Your promotion will be closed right now. You budget left will be return to your wallet."
      }
      
      enum FundingMessages: String, LocalizedStringKeyProtocol {
        case stopFundingConfirmMessage = "Do you really want to end funding campaign now? When the campaign ends, The amount of funding, excluding the fee, will be delivered to you."
        case stopFundingSuccessMessage = "Your funding campaign has just ended. After the verification process, the funds will be transferred to your account soon."
      }
      
      case turnOnNotificationAction = "Turn On Post Notification"
      case copyLink = "Copy Link"
      case editCaptionAction = "Edit"
      case editTagsAction = "Edit Tags"
      case shareAction = "Share"
      case addPromotionAction = "Add Promotion"
      case cancelAction = "Cancel"
      case reportAction = "Report"
      case deleteAction = "Delete"
      case viewEngagement = "View Engage"
      case okAction = "OK"
      
      case deletePostAlertMessage = "Delete Post?"
      
      case invoicePaymentSuccessAlertTitle = "Thank you"
      case invoicePaymentSuccessAlertMessage = "Your payment was successful"
      
      static let donationPaymentSuccessAlertTitle = Alerts.invoicePaymentSuccessAlertTitle
      static let donationPaymentSuccessAlertMessage = Alerts.invoicePaymentSuccessAlertMessage
      
      case inappropriateReportAlertTitle = "Report as inappropriate"
      case spamReportAlertTitle = "Report as spam"
      
      case spamReportSuccessAlertTitle = "Thanks for reporting"
      case spamReportSuccessAlertMessage = "If you do not want to see this post right now, make it as Block. If you think this post violates our Community Guidelines and should be removed for others. Report as inappropriate."
      
      case spamReportSuccessAlertBlockAction = "Block"
    }
    
    static func userScores(redBrush: Double, greenBrush: Double, level: Int) -> String {
      let rb = String(format:"%.0f", redBrush)
      let gb = String(format:"%.0f", greenBrush)
      
      return "Lv.\(level) R.B \(rb) G.B \(gb)"
    }
    
    static func statusTitleFor(_ status: CommerceStatus) -> String {
      switch status {
      case .waiting:
        return StatusTitleForCommerce.waiting.localize()
      case .inProgress:
        return StatusTitleForCommerce.inProgress.localize()
      case .failed:
        return StatusTitleForCommerce.failed.localize()
      case .success:
        return StatusTitleForCommerce.success.localize()
      }
    }
    
    static func titleFor(_ status: PostCreationStatus) -> String {
      switch status {
      case .preparing:
        return TitleForCreationStatus.preparing.localize()
      case .uploading:
        return TitleForCreationStatus.uploading.localize()
      case .failed:
        return TitleForCreationStatus.failed.localize()
      case .completed:
        return TitleForCreationStatus.completed.localize()
      case .cancelled:
        return TitleForCreationStatus.cancelled.localize()
      }
    }
    
    static func progressFor(_ status: PostCreationStatus) -> CGFloat {
      switch status {
      case .preparing:
        return 0.7
      case .uploading:
        return 0.7
      case .failed:
        return 1.0
      case .completed:
        return 1.0
      case .cancelled:
        return 1.0
      }
    }
    
    static func notEnoughFundsForPostDelete(_ balance: BalanceProtocol) -> String {
      return notEnoughFundsForPostDeleteWithSymbol.localize(value: balance.currency.symbol)
    }
    
    static func alertTitleForInvoice(_ invoice: InvoiceProtocol) -> String {
      let value = String(format:"%.0f", invoice.activityValue)
      let currencySymbol = invoice.activityCurrency.symbol
      let username = invoice.activityFromUser?.userName.asUsername.withSpaceAsSuffix ?? ""
      return alertTitleForInvoiceWithValueSymbolUsername.localize(values: value, currencySymbol, username)
    }
 
    static func alertTitleForGoodsInfo(_ goodsIndo: GoodsProtocol) -> String {
      let value = String(format:"%.0f", goodsIndo.goodsPrice)
      let currencySymbol = goodsIndo.itemCurrency.symbol
      return alertTitleForGoodsOrderValueSymbol.localize(values: value, currencySymbol)
    }
    
    static func alertMessageForPostDelete(_ balance: BalanceProtocol) -> String {
      guard !balance.value.isZero else {
        return ""
      }
      
      let valueString = String(format: balance.currency.stringFormat, balance.value)
      return alertMessageForPostDeleteWithValueSymbol.localize(values: valueString, balance.currency.symbol)
    }
    
    static func alertTitleForPostHelp(_ createPostHelpDraft: CreatePostHelpProtocol) -> String {
      let rewardValue = "\(createPostHelpDraft.reward) \(createPostHelpDraft.currency.symbol)"
      return alertTitleForPostHelpCreation.localize(value: rewardValue)
    }
  }
}

extension TopGroupPostsType {
  var iconImage: UIImage {
    switch self {
    case .news:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-News")
    case .coin:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-Coin")
    case .webtoon:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-Webtoon")
    case .newbie:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-Newbie")
    case .funding:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-Funding")
    case .promoted:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-Promoted")
    case .shop:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-Shop")
    case .hot:
      return UIImage(imageLiteralResourceName: "PostFeed-TopGroup-Hot")
    }
  }
}


