//
//  UserProfileContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UserProfileContent {
  enum TargetUser {
    case current
    case other(UserProtocol)
  }
  
  enum FriendRequestStatus {
    case accpeted
    case denied
    case none
  }
  
  enum FollowActions {
    case following
    case friendship
  }
  
  enum UserStatsShowActions {
    case followers
    case followings
    case friends
    case posts
  }
  
  enum UserAvavarActions {
    case wall
    case userpic
    case playroom
  }
  
  enum UserProfileCaptionActions {
    case edit
    case showWebsite
  }
  
  enum UserProfileFriendRequestActions {
    case accept
    case deny
    case showUserProfile
  }
  
  enum UserProfileFriendActions {
    case showUserProfile
  }
  
  struct BrushRewardsHistory {
    fileprivate struct DataPoint: HistoricalDataPointProtocol {
      let value: Double
      let dateValue: Date
    }
    
    fileprivate static let dateMergeValueFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyyMMdd"
      return formatter
    }()
    
    let pgb: [HistoricalDataPointProtocol]
    let prb: [HistoricalDataPointProtocol]
    let period: RewardsHistoryPeriod
    
    fileprivate static func mergedArrayFor(dataPoints: [HistoricalDataPointProtocol]) -> [HistoricalDataPointProtocol] {
      
      var sumValuesDictionary: [String: Double] = [:]
      var mergedDatesKeysArray: [String] = []
      var lastDateKey: String = ""
     
      for dataPoint in dataPoints {
        let date = dataPoint.dateValue
      
        let dateStringKey = BrushRewardsHistory.dateMergeValueFormatter.string(from: date)
        let sumValue = (sumValuesDictionary[dateStringKey] ?? 0.0) + dataPoint.value
        sumValuesDictionary[dateStringKey] = sumValue
        if lastDateKey != dateStringKey {
          mergedDatesKeysArray.append(dateStringKey)
          lastDateKey = dateStringKey
        }
      }
      
      return mergedDatesKeysArray.map { return DataPoint(value: sumValuesDictionary[$0] ?? 0.0,
                                                         dateValue: dateMergeValueFormatter.date(from: $0)!)  }
    }
    
    fileprivate static func mergedByDateArrays(arr1: [HistoricalDataPointProtocol], arr2: [HistoricalDataPointProtocol]) -> ([HistoricalDataPointProtocol], [HistoricalDataPointProtocol]) {
      
      let mergedByDateArr1 = mergedArrayFor(dataPoints: arr1)
      let mergedByDateArr2 = mergedArrayFor(dataPoints: arr2)
      
      let arr1ValuesByKey: [String: Double] = Dictionary(pairs: mergedByDateArr1.map { (dateMergeValueFormatter.string(from: $0.dateValue), $0.value) })
      let arr2ValuesByKey: [String: Double] = Dictionary(pairs: mergedByDateArr2.map { (dateMergeValueFormatter.string(from: $0.dateValue), $0.value) })
      
      var mergedArr1: [HistoricalDataPointProtocol] = []
      var mergedArr2: [HistoricalDataPointProtocol] = []
      
      var allKeys = Set<String>(arr1ValuesByKey.keys)
      allKeys.formUnion(arr2ValuesByKey.keys)
      
      allKeys
        .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
        .forEach {
          mergedArr1.append(DataPoint(value: arr1ValuesByKey[$0] ?? 0.0, dateValue: dateMergeValueFormatter.date(from: $0)!))
          mergedArr2.append(DataPoint(value: arr2ValuesByKey[$0] ?? 0.0, dateValue: dateMergeValueFormatter.date(from: $0)!))
      }
      
      return (mergedArr1, mergedArr2)
    }
    
    static func mergedDailyRewards(pgb: [HistoricalDataPointProtocol], prb: [HistoricalDataPointProtocol], period: RewardsHistoryPeriod) -> BrushRewardsHistory {
      let mergedArrays = mergedByDateArrays(arr1: pgb, arr2: prb)
      return BrushRewardsHistory(pgb: mergedArrays.0, prb: mergedArrays.1, period: period)
    }
  }
  
  enum ItemViewModelType: DiffableProtocol {
    case avatar(UserProfileAvatarViewModelProtocol)
    case username(UserProfileUsernameViewModelProtocol)
    case followActions(UserProfileFollowActionsViewModelProtocol)
    case level(UserProfileLevelViewModelProtocol)
    case countsStatus(UserProfileCountsStatusViewModelProtocol)
    case caption(UserProfileCaptionViewModelProtocol)
    case usersHeader(UserProfileUsersSectionHeaderViewModelProtocol)
    case friend(UserProfileFriendViewModelProtocol)
    case friendRequest(UserProfileFriendRequestViewModelProtocol)
    case rewardsHistoryChart(UserProfileRewardsChartViewModelProtocol)
    
    var identifier: String {
      switch self {
      case .avatar(let vm):
        return vm.identifier
      case .username(let vm):
        return vm.identifier
      case .followActions(let vm):
        return vm.identifier
      case .level(let vm):
        return vm.identifier
      case .countsStatus(let vm):
        return vm.identifier
      case .caption(let vm):
        return vm.identifier
      case .usersHeader(let vm):
        return vm.identifier
      case .friend(let vm):
        return vm.identifier
      case .friendRequest(let vm):
        return vm.identifier
      case .rewardsHistoryChart(let vm):
        return vm.identifier
      }
    }
    
    static func prepareInfoSectionViewModels(user: UserProtocol) -> [ItemViewModelType] {
      var viewModels: [ItemViewModelType] = []
      
      let avatarVM = UserProfileAvatarViewModel(user: user)
      viewModels.append(.avatar(avatarVM))
      
      let usernameVM = UserProfileUsernameViewModel(user: user)
      viewModels.append(.username(usernameVM))
      
      if !(user.isCurrent ?? false) {
        let followActionsVM = UserProfileFollowActionsViewModel(user: user)
        viewModels.append(.followActions(followActionsVM))
      }
      
      if user.hasUserLevelData {
        let levelVM = UserProfileLevelViewModel(user: user)
        viewModels.append(.level(levelVM))
      }
      
      let statsVM = UserProfileCountsStatusViewModel(user: user)
      viewModels.append(.countsStatus(statsVM))
      
      if let captionVM = UserProfileCaptionViewModel(user: user) {
        viewModels.append(.caption(captionVM))
      }
      
      return viewModels
    }
  }
  
  struct UserProfileAvatarViewModel: UserProfileAvatarViewModelProtocol {
    
    static let richLimit: Double = 100000
    let identifier: String
    
    let wallPlaceholder: UIImage?
    
    let avatarPlaceholder: UIImage?
    
    let wallURLString: String
    let avatarURLString: String
    let pibbleAmount: String
    let redBrushAmount: String
    let greenBrushAmount: String
    
    let isPlaygroundVisible: Bool
    
    
    init(user: UserProtocol) {
      wallPlaceholder = nil
      avatarPlaceholder = UIImage.avatarImageForNameString(user.userName, size: CGSize(width: 200, height: 200))
      
      wallURLString = user.userWallCoverUrlString
      avatarURLString = user.userpicUrlString
      
      let pibbleBalance = user.walletBalances.first { $0.currency == BalanceCurrency.pibble }?.value ?? 0.0
      pibbleAmount = pibbleBalance.isLess(than: UserProfileAvatarViewModel.richLimit) ?
        String(format:"%.0f", pibbleBalance) :
        UserProfileContent.Strings.Titles.rich.localize()
      
      redBrushAmount = String(format:"%.0f", user.redBrushWalletBalance)
      greenBrushAmount = String(format:"%.0f", user.greenBrushWalletBalance)
      
      isPlaygroundVisible = true
      
      identifier = "\(wallURLString)_\(avatarURLString)_\(pibbleAmount)_\(redBrushAmount)_\(greenBrushAmount)"
    }
  }
  
  struct UserProfileUsernameViewModel: UserProfileUsernameViewModelProtocol {
    var prizeIconImage: UIImage?
    
    var prizeAmount: String
    
    let identifier: String
    
    let username: String
    let userLevel: String
    
    init(user: UserProtocol) {
      if user.userProfileFirstName.count > 0 || user.userProfileLastName.count > 0 {
        let space = user.userProfileFirstName.count > 0 && user.userProfileLastName.count > 0 ? " " : ""
        username = "\(user.userProfileFirstName)\(space)\(user.userProfileLastName)"
      } else {
        username = user.userName.capitalized
      }
      
      userLevel = UserProfileContent.Strings.userScores(redBrush: user.redBrushWalletBalance,
                                                 greenBrush: user.greenBrushWalletBalance,
                                                 level: user.userLevel)
      
      let prize = (user.userWonPrizeAmount ?? 0.0)
      if prize.isZero {
        prizeAmount = ""
        prizeIconImage = UIImage(imageLiteralResourceName: "UserProfileContent-WinPrize")
      } else {
        prizeAmount = formatNumber(prize)
        prizeIconImage = UIImage(imageLiteralResourceName: "UserProfileContent-WinPrize-selected")
      }
      
      identifier = "\(username)_\(userLevel)_\(prizeAmount)"
    }
  }
  
  struct UserProfileFollowActionsViewModel: UserProfileFollowActionsViewModelProtocol {
    let identifier: String
    
    let leftActionTitle: String
    let isLeftActionHighlighted: Bool
    let isLeftActionPromoted: Bool
    let rightActionTitle: String
    let isRightActionHighlighted: Bool
    let isRightActionPromoted: Bool
    
    init(user: UserProtocol) {
      leftActionTitle = user.isFollowedByCurrentUser ?
        UserProfileContent.Strings.ButtonStates.unfollowAction.localize() :
        UserProfileContent.Strings.ButtonStates.followAction.localize()
      
      isLeftActionHighlighted = !user.isFollowedByCurrentUser
      isLeftActionPromoted = false
      
      
      isRightActionPromoted = false
      
      
      guard !user.isFriendWithCurrentUser else {
        isRightActionHighlighted = !user.isFriendWithCurrentUser
        rightActionTitle = UserProfileContent.Strings.ButtonStates.unfriendAction.localize()
        
        identifier = "\(isLeftActionHighlighted)_\(isRightActionHighlighted)"
        return
      }
      
      guard !user.isInboundFriendshipRequested else {
        isRightActionHighlighted = !user.isFriendWithCurrentUser
        rightActionTitle = UserProfileContent.Strings.ButtonStates.acceptFriendshipAction.localize()
        
        identifier = "\(isLeftActionHighlighted)_\(isRightActionHighlighted)"
        return
      }
      
      guard !user.isOutboundFriendshipRequested else {
        isRightActionHighlighted = false
        rightActionTitle = UserProfileContent.Strings.ButtonStates.friendshipRequestedAction.localize()
        
        identifier = "\(isLeftActionHighlighted)_\(isRightActionHighlighted)"
        return
      }
      
      isRightActionHighlighted = !user.isFriendWithCurrentUser
      rightActionTitle = UserProfileContent.Strings.ButtonStates.friendAction.localize()
      
      identifier = "\(isLeftActionHighlighted)_\(isRightActionHighlighted)"
    }
  }
  
  struct UserProfileLevelItemViewModel: UserProfileLevelItemViewModelProtocol {
    let identifier: String
    
    enum UserProfileLevelType {
      case level
      case rewards
    }
    
    let statusTitle: String
    let amount: String
    let amountTarget: String
    let progressPerCentAmount: String
    let progressBarColor: UIColor
    let progressBarValue: Double
    
    init(user: UserProtocol, levelType: UserProfileLevelType) {
      switch levelType {
      case .level:
        statusTitle = UserProfileContent.Strings.Titles.level.localize(value: "\(user.userLevel)")
        amount = UserProfileContent.Strings.Titles.points.localize(value: "\(user.availableLevelUpPoints)")
        amountTarget = "\(user.necessaryLevelUpPoints)"
        let progress = Double(user.availableLevelUpPoints) / Double(user.necessaryLevelUpPoints)
        
        progressBarValue = min(1, progress)
        progressPerCentAmount = "\(String(format:"%.0f", progress * 100))%"
        progressBarColor = UserProfileContent.Colors.points
      case .rewards:
        statusTitle = UserProfileContent.Strings.Titles.rewards.localize()
        amount = String(format:"%.0f %@", user.earnedBrushRewards, BalanceCurrency.greenBrush.symbol)
        amountTarget = String(format:"%.0f", user.brushRewardsLimit)
        let progress = Double(user.availableLevelUpPoints) / Double(user.necessaryLevelUpPoints)
        
        progressBarValue = min(1, progress)
        progressPerCentAmount = "\(String(format:"%.0f", progress * 100))%"
        progressBarColor = UserProfileContent.Colors.rewards
      }
      
      identifier = "\(amount)_\(amountTarget)"
    }
  }
  
  struct UserProfileLevelViewModel: UserProfileLevelViewModelProtocol {
    let identifier: String
    
    let levelItems: [UserProfileLevelItemViewModelProtocol]
    
    init(user: UserProtocol) {
      levelItems = [
        UserProfileLevelItemViewModel(user: user, levelType: .level),
        UserProfileLevelItemViewModel(user: user, levelType: .rewards)
      ]
      
      identifier = levelItems.map { $0.identifier }.joined(separator: "_")
    }
  }
  
  struct UserProfileCountItemStatusViewModel: UserProfileCountItemStatusViewModelProtocol {
    let showStatAction: UserProfileContent.UserStatsShowActions
    
    let identifier: String
    
    let title: String
    let amount: String
    
    init(title: String, amount: String, showStatAction: UserProfileContent.UserStatsShowActions) {
      self.title = title
      self.amount = amount
      self.showStatAction = showStatAction
      
      identifier = "\(amount)_\(title)"
    }
  }
  
  struct UserProfileCountsStatusViewModel: UserProfileCountsStatusViewModelProtocol {
    let identifier: String
    
    let countItems: [UserProfileCountItemStatusViewModelProtocol]
    
    init(user: UserProtocol) {
      countItems = [
        UserProfileCountItemStatusViewModel(title: UserProfileContent.Strings.UserStats.followers.localize().uppercased(),
                                            amount: "\(user.userFollowersCount)",
                                            showStatAction: .followers),
        UserProfileCountItemStatusViewModel(title: UserProfileContent.Strings.UserStats.following.localize().uppercased(),
                                            amount: "\(user.userFollowingsCount)",
                                            showStatAction: .followings),
        UserProfileCountItemStatusViewModel(title: UserProfileContent.Strings.UserStats.friends.localize().uppercased(),
                                            amount: "\(user.userFriendsCount)",
                                            showStatAction: .friends),
        UserProfileCountItemStatusViewModel(title: UserProfileContent.Strings.UserStats.post.localize().uppercased(),
                                            amount: "\(user.userPostsCount)",
                                            showStatAction: .posts)
      ]
      
      identifier = countItems.map { $0.amount }.joined(separator: "_")
    }
  }
  
  struct UserProfileCaptionViewModel: UserProfileCaptionViewModelProtocol {
    let isEditButtonHidden: Bool
    let hasCaption: Bool
    let identifier: String
    let caption: String
    
    let hasWebsite: Bool
    
    let website: String
    
    init?(user: UserProtocol) {
      isEditButtonHidden = !(user.isCurrent ?? false)
      guard user.userProfileDescription.count > 0 || user.userProfileSiteName.count > 0 else {
        guard (user.isCurrent ?? false) else {
          return nil
        }
        
        caption = UserProfileContent.Strings.Placeholder.userDescriptionCaptionPlaceholder.localize()
        hasCaption = false
        hasWebsite = user.userProfileSiteName.count > 0
        website = user.userProfileSiteName
        identifier = "\(caption)_\(website)"
        return
      }
      
      hasCaption = true
      caption = user.userProfileDescription
      hasWebsite = user.userProfileSiteName.count > 0
      website = user.userProfileSiteName
      
      identifier = "\(caption)_\(website)"
    }
  }
  
  struct UserProfileFriendViewModel: UserProfileFriendViewModelProtocol {
    let identifier: String
    
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let username: String
    let userLevel: String
    
    init(user: UserProtocol) {
      avatarPlaceholder = UIImage.avatarImageForNameString(user.userName)
      
      avatarURLString = user.userpicUrlString
      username = user.userName.capitalized
      userLevel = UserProfileContent.Strings.userScores(redBrush: user.redBrushWalletBalance,
                                                 greenBrush: user.greenBrushWalletBalance,
                                                 level: user.userLevel)
      
      identifier = username
    }
    
  }
  
  struct UserProfileFriendsHeaderViewModel: UserProfileUsersSectionHeaderViewModelProtocol {
    let identifier: String
    
    let title: String
    let isShowAllButtonHidden: Bool
    
    init(friendsCount: Int, isShowAllButtonHidden: Bool) {
      title = UserProfileContent.Strings.Titles.friendsCount.localize(value: "\(friendsCount)")
      identifier = title
      self.isShowAllButtonHidden = isShowAllButtonHidden
    }
  }
  
  struct UserProfileFriendsRequestHeaderViewModel: UserProfileUsersSectionHeaderViewModelProtocol {
    let identifier: String
    let title: String
    let isShowAllButtonHidden: Bool
    
    init(friendsCount: Int, isShowAllButtonHidden: Bool) {
      title = UserProfileContent.Strings.Titles.friendsRequestCount.localize(value: "\(friendsCount)")
      identifier = title
      self.isShowAllButtonHidden = isShowAllButtonHidden
    }
  }
  
  struct UserProfileFriendRequestViewModel: UserProfileFriendRequestViewModelProtocol {
    let identifier: String
    
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let username: String
    let userLevel: String
    let requestStatus: UserProfileContent.FriendRequestStatus
    let statusTitle: String
    
    init(user: UserProtocol) {
      avatarPlaceholder = UIImage.avatarImageForNameString(user.userName)
      
      avatarURLString = user.userpicUrlString
      username = user.userName.capitalized
      userLevel = UserProfileContent.Strings.userScores(redBrush: user.redBrushWalletBalance,
                                                 greenBrush: user.greenBrushWalletBalance,
                                                 level: user.userLevel)
      
      if user.isFriendWithCurrentUser {
        requestStatus = .accpeted
      } else {
        if let isFriendshipDenied = user.isFriendshipDeniedByCurrentUser, isFriendshipDenied {
          requestStatus = .denied
        } else{
          requestStatus = .none
        }
      }
      
      switch requestStatus {
      case .accpeted:
        statusTitle = UserProfileContent.Strings.FriendsStatus.accepted.localize()
      case .denied:
        statusTitle = UserProfileContent.Strings.FriendsStatus.denied.localize()
      case .none:
        statusTitle = UserProfileContent.Strings.FriendsStatus.none.localize()
      }
      
      identifier = username
    }
  }
  
  struct UserProfileRewardsChartViewModel: UserProfileRewardsChartViewModelProtocol {
    fileprivate let pointsLimit = 365
    
    static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "d, EEE"
      return formatter
    }()
    
    let points: [(UIColor, [(Double, Date)])]
    
    let identifier: String
    let labels: [String]
    let labelsIndexes: [Double]
    let periodTitle: String
    
    init(rewardsHistory: BrushRewardsHistory) {
      switch rewardsHistory.period {
      case .year:
        periodTitle = UserProfileContent.Strings.TimePeriod.thisYearPeriod.localize()
      case .week:
        periodTitle = UserProfileContent.Strings.TimePeriod.thisWeekPeriod.localize()
      }
      
      var pgbPoints = rewardsHistory.pgb.map {
        ($0.value, $0.dateValue)
      }
      
      if pgbPoints.count > pointsLimit {
        pgbPoints = Array(pgbPoints.suffix(pointsLimit))
      }
      
      var prbPoints = rewardsHistory.prb.map {
        ($0.value, $0.dateValue)
      }
      
      if prbPoints.count > pointsLimit {
        prbPoints = Array(prbPoints.suffix(pointsLimit))
      }
      
      let lastPRBPoint = prbPoints.last?.0 ?? 0.0
      let lastPGBPoint = pgbPoints.last?.0 ?? 0.0
      
      identifier = "\(String(format:"%.0f", lastPRBPoint))_\(String(format:"%.0f", lastPGBPoint))_\(periodTitle)"
      
      var pointsArrays: [(UIColor, [(Double, Date)])] = []
      
      if pgbPoints.count > 0 {
        pointsArrays.append((UIColor.greenPibble, pgbPoints))
      }
      
      if prbPoints.count > 0 {
         pointsArrays.append((UIColor.pinkPibble, prbPoints))
      }
      
      var labelsAsString: [String] = []
      var labelsIndexesArr: [Double] = []
      switch rewardsHistory.period {
      case .year:
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MM"
        let series = prbPoints.count > 0 ? prbPoints : pgbPoints
        
        for (i, point) in series.enumerated() {
          let date = point.1
          if let month = Int(monthDateFormatter.string(from: date)) {
            let monthAsString: String = monthDateFormatter.shortMonthSymbols[month - 1]
            if (labelsIndexesArr.count == 0 || labelsAsString.last != monthAsString) {
              labelsIndexesArr.append(Double(i))
              labelsAsString.append(monthAsString)
            }
          }
        }
      case .week:
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MM"
        let series = prbPoints.count > 0 ? prbPoints : pgbPoints
        var lastMonthString = ""
        for (i, point) in series.enumerated() {
          let date = point.1
          if let month = Int(monthDateFormatter.string(from: date)) {
            let monthAsString: String = monthDateFormatter.shortMonthSymbols[month - 1]
            if (labelsIndexesArr.count == 0 || lastMonthString != monthAsString) {
              labelsIndexesArr.append(Double(i))
              labelsAsString.append(monthAsString)
              lastMonthString = monthAsString
            } else {
              let dateString = UserProfileRewardsChartViewModel.dateFormatter.string(from: date)
              labelsIndexesArr.append(Double(i))
              labelsAsString.append(dateString)
            }
          }
        }
      }
     
      labels = labelsAsString
      labelsIndexes = labelsIndexesArr
      points = pointsArrays
    }
  }
}


extension UserProtocol {
  fileprivate var hasUserLevelData: Bool {
    return necessaryLevelUpPoints > 0 &&
    brushRewardsLimit > 0
  }
}


extension UserProfileContent {
  enum Colors {
    static let points = UIColor.pinkPibble
    static let rewards = UIColor.greenPibble
  }
}


extension UserProfileContent {
  enum Strings {
    
    enum Titles: String, LocalizedStringKeyProtocol {
      case points = "% Points"
      case level = "Level (Lv.%)"
      case rewards = "Rewards (24h)"
      case friendsCount = "Friends (%)"
      case friendsRequestCount = "% Friends request arrived"
      case rich = "Rich"
    }
    
    enum ButtonStates: String, LocalizedStringKeyProtocol {
      case followAction = "Follow"
      case unfollowAction = "Unfollow"
      case friendAction = "Add friends"
      case friendshipRequestedAction = "Friendship requested"
      case acceptFriendshipAction = "Accept friendship"
      case unfriendAction = "Your friend"
    }
    
    enum TimePeriod: String, LocalizedStringKeyProtocol {
      case thisYearPeriod = "This Year"
      case thisWeekPeriod = "This Week"
    }
    
    enum Placeholder: String, LocalizedStringKeyProtocol {
      case userDescriptionCaptionPlaceholder = "Add description"
    }
    
    enum UserStats: String, LocalizedStringKeyProtocol {
      case followers = "Followers"
      case following = "Following"
      case friends = "Friends"
      case post = "Posts"
    }
    
    enum FriendsStatus: String, LocalizedStringKeyProtocol {
      case accepted = "Accepted"
      case denied = "Denied"
      case none = ""
    }
    
    static func userScores(redBrush: Double, greenBrush: Double, level: Int) -> String {
      let rb = String(format:"%.0f", redBrush)
      let gb = String(format:"%.0f", greenBrush)
      
      return "Lv.\(level) R.B \(rb) G.B \(gb)"
    }
  }
}


fileprivate extension Double {
  func truncate(places: Int) -> Double {
    return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
  }
}

fileprivate func formatNumber(_ n: Double) -> String {
  let num = abs(n)
  let sign = (n < 0) ? "-" : ""
  
  switch num {
  case 1_000_000_000...:
    var formatted = num / 1_000_000_000
    formatted = formatted.truncate(places: 1)
    return "\(sign)\(formatted)B"
    
  case 1_000_000...:
    var formatted = num / 1_000_000
    formatted = formatted.truncate(places: 1)
    return "\(sign)\(formatted)M"
    
  case 1_000...:
    var formatted = num / 1_000
    formatted = formatted.truncate(places: 1)
    return "\(sign)\(formatted)K"
    
  case 0...:
    return "\(n)"
    
  default:
    return "\(sign)\(n)"
  }
  
}
