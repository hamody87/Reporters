//
//  LandingView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 04/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

extension LandingView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isStopAutoScroll {
            print("dsadasdasdsadsa")
            self.isStopAutoScroll = false
            return
        }
        for i in 0 ..< self.sectionViews.count {
            self.sectionViews[i]?.alpha = 1.0
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.animate(withDuration: 0.6, animations: {
            self.getPresentSection(scrollView)?.alpha = 0
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.6, animations: {
            self.getPresentSection(scrollView)?.alpha = 0
        })
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("2222")
        self.isStopAutoScroll = true
        UIView.animate(withDuration: 0.6, animations: {
            self.getPresentSection(scrollView)?.alpha = 0
        })
    }
}

extension LandingView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let sectionMessages: [Any] = self.messages[indexPath.section] as? [Any], let currentMessage: [String: Any] = sectionMessages[indexPath.row] as? [String: Any], let content: [String: Any] = currentMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] as? [String: Any], let height: CGFloat = content[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.HEIGHT] as? CGFloat  {
            return CONSTANTS.SCREEN.MARGIN(4) + height + DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT + DEFAULT.TABLENVIEW.CELL.MARGIN + DEFAULT.TABLENVIEW.CELL.REPORTER.SIZE.HEIGHT
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CONSTANTS.SCREEN.MARGIN(3) + DEFAULT.TABLENVIEW.SECTION.HEIGHT
    }

}

extension LandingView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.messages else {
            return 0
        }
        return (self.messages[section] as? [Any])?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = self.sections else {
            return 0
        }
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView: UIView = UIView()
        let title: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: DEFAULT.TABLENVIEW.SECTION.HEIGHT))
        title.textAlignment = .center
        title.textColor = UIColor(named: "Font/Basic")
        title.text = self.sections[section]
        title.font = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
        title.frame = CGRect(x: 0, y: title.frame.origin.y, width: title.widthOfString() + CONSTANTS.SCREEN.MARGIN(4), height: title.frame.height)
        let coreSectionView: UIView = UIView(frame: CGRect(x: (tableView.frame.width - title.frame.width) / 2.0, y: 0, width: title.frame.width, height: title.frame.height))
        sectionView.addSubview(coreSectionView)
        if self.sectionViews.indices.contains(section) {
            if let oldSectionView: UIView = self.sectionViews[section] {
                print("---> \(oldSectionView.alpha)")
                coreSectionView.alpha = oldSectionView.alpha
            }
            self.sectionViews.remove(at: section)
        }
        self.sectionViews.insert(coreSectionView, at: section)
        let backgroundSectionView: UIView = UIView(frame: coreSectionView.bounds)
        backgroundSectionView.backgroundColor = UIColor(named: "Background/Third")
        backgroundSectionView.alpha = 0.5
        backgroundSectionView.layer.cornerRadius = backgroundSectionView.frame.height / 2.0
        coreSectionView.addSubview(backgroundSectionView)
        coreSectionView.addSubview(title)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoneDesignCell.NONE_DESIGN_CELL_REUSE_ID, for: indexPath)
        let cellView: UIView!
        if let view: UIView = cell.viewWithTag(111) {
            cellView = view
        } else {
            cellView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(2), y: 0, width: cell.bounds.width - CONSTANTS.SCREEN.MARGIN(4), height: 0))
            cellView.tag = 111
            cellView.backgroundColor = .clear
            cell.addSubview(cellView)
            let thumb: AsyncImageView! = AsyncImageView(withFrame: CGRect(x: 0, y: 0, width: DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH, height: DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH))
            thumb.backgroundColor = UIColor(named: DEFAULT.TABLENVIEW.CELL.THUMB.COLOR)
            cellView.addSubview(thumb)
            let reporterName: UILabel = UILabel(frame: CGRect(x: thumb.frame.width + DEFAULT.TABLENVIEW.CELL.MARGIN, y: 0, width: 0, height: DEFAULT.TABLENVIEW.CELL.REPORTER.SIZE.HEIGHT))
            reporterName.backgroundColor = UIColor(named: "Background/Basic")
            reporterName.textColor = UIColor.white
            reporterName.textAlignment = .center
            reporterName.font = CONSTANTS.GLOBAL.createFont(ofSize: 15.0, false)
            cellView.addSubview(reporterName)
            let img_favBtn: UIImage! = UIImage(named: "\(self.classDir())FavOffBtn")
            let favBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: img_favBtn.size.width, height: img_favBtn.size.height))
            favBtn.setImage(img_favBtn, for: UIControl.State.normal)
            cellView.addSubview(favBtn)
            let img_shareBtn: UIImage! = UIImage(named: "\(self.classDir())ShareBtn")
            let shareBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: img_shareBtn.size.width, height: img_shareBtn.size.height))
            shareBtn.setImage(img_shareBtn, for: UIControl.State.normal)
            cellView.addSubview(shareBtn)
            let messageView: UIView = UIView(frame: CGRect(x: reporterName.frame.origin.x, y: 0, width: cellView.frame.width - reporterName.frame.origin.x, height: 0))
            messageView.backgroundColor = UIColor(named: "Background/Third")
            cellView.addSubview(messageView)
            let messageLabel: UILabel = UILabel(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: CONSTANTS.SCREEN.MARGIN(), width: messageView.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: 0))
            messageLabel.backgroundColor = .clear
            messageLabel.textColor = UIColor(named: "Font/Basic")
            messageLabel.numberOfLines = 0
            messageLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: DEFAULT.TABLENVIEW.CELL.MESSAGE.FONT.SIZE, false)
            messageView.addSubview(messageLabel)
            let dateLabel: UILabel = UILabel(frame: CGRect(x: messageLabel.frame.origin.x, y: 0, width: messageLabel.frame.width, height: DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT))
            dateLabel.backgroundColor = .clear
            dateLabel.textColor = UIColor(named: "Font/Basic")
            dateLabel.textAlignment = .right
            dateLabel.alpha = 0.5
            dateLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, false)
            messageView.addSubview(dateLabel)
        }
        if let sectionMessages: [Any] = self.messages[indexPath.section] as? [Any], let currentMessage: [String: Any] = sectionMessages[indexPath.row] as? [String: Any], let reporterID: String = currentMessage[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String {
            let thumb: AsyncImageView = cellView.subviews[0] as! AsyncImageView
            let reporterName: UILabel = cellView.subviews[1] as! UILabel
            let favBtn: UIButton = cellView.subviews[2] as! UIButton
            let shareBtn: UIButton = cellView.subviews[3] as! UIButton
            let messageView: UIView = cellView.subviews[4]
            let messageLabel: UILabel = messageView.subviews[0] as! UILabel
            let dateLabel: UILabel = messageView.subviews[1] as! UILabel
            cellView.frame = CGRect(x: cellView.frame.origin.x, y: cellView.frame.origin.y, width: cell.bounds.width - CONSTANTS.SCREEN.MARGIN(4), height: cell.frame.height - CONSTANTS.SCREEN.MARGIN(3))
            thumb.frame = CGRect(x: thumb.frame.origin.x, y: cellView.frame.height - DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH, width: thumb.frame.width, height: thumb.frame.height)
            if let reporter: [String: Any] = self.reporters[reporterID], let name: String = reporter[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String, let reporterThumb: String = reporter[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
                thumb.setImage(withUrl: NSURL(string: reporterThumb)!)
                reporterName.text = name
            }
            reporterName.frame = CGRect(x: reporterName.frame.origin.x, y: cellView.frame.height - reporterName.frame.height, width: reporterName.widthOfString() + CONSTANTS.SCREEN.MARGIN(2), height: reporterName.frame.height)
            favBtn.frame = CGRect(x: reporterName.frame.origin.x + reporterName.frame.width + CONSTANTS.SCREEN.MARGIN(), y: reporterName.frame.origin.y, width: favBtn.frame.width, height: favBtn.frame.height)
            shareBtn.frame = CGRect(x: favBtn.frame.origin.x + favBtn.frame.width + CONSTANTS.SCREEN.MARGIN(), y: reporterName.frame.origin.y, width: shareBtn.frame.width, height: shareBtn.frame.height)
            messageView.frame = CGRect(x: messageView.frame.origin.x, y: messageView.frame.origin.y, width: messageView.frame.width, height: cellView.frame.height - reporterName.frame.height - DEFAULT.TABLENVIEW.CELL.MARGIN)
            messageView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 16.0)
            messageLabel.frame = CGRect(x: messageLabel.frame.origin.x, y: messageLabel.frame.origin.y, width: messageLabel.frame.width, height: messageView.frame.height - CONSTANTS.SCREEN.MARGIN() - DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT)
            if let content: [String: Any] = currentMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] as? [String: Any], let element: String = content[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.SELF] as? String, let value: String = content[element] as? String  {
                switch element {
                case CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.IMAGE:
                    break
                case CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.IMAGE:
                    break
                default:
                    messageLabel.text = value
                    messageLabel.decideTextDirection()
                    break
                }
            }
            dateLabel.frame = CGRect(x: dateLabel.frame.origin.x, y: messageLabel.frame.origin.y + messageLabel.frame.height, width: dateLabel.frame.width, height: dateLabel.frame.height)
            if messageLabel.textAlignment == .left {
                dateLabel.textAlignment = .right
            } else {
                dateLabel.textAlignment = .left
            }
            if let date: Date = currentMessage[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as? Date {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "HH:mm"
                dateLabel.text = inputFormatter.string(from: date)
            }
        }
        return cell
    }
    
}

class LandingView: SuperView {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        struct TABLENVIEW {
            
            struct SECTION {
                
                fileprivate static let HEIGHT: CGFloat = 30.0
            }
            
            struct CELL {
                
                static let MARGIN: CGFloat = 3.0
                
                struct DATE {
                    
                    struct SIZE {
                        fileprivate static let HEIGHT: CGFloat = 30.0
                    }
                    
                }
                
                struct THUMB {
                    
                    struct SIZE {
                        static let BOTH: CGFloat = 50.0
                    }
                    fileprivate static let COLOR: String = "Background/Basic"
                    
                }
                
                struct REPORTER {
                    
                    struct SIZE {
                        fileprivate static let HEIGHT: CGFloat = 30.0
                    }
                    fileprivate static let COLOR: UInt = 0xeeeeee
                    
                }
                
                struct MESSAGE {
                    
                    struct FONT {
                        static let SIZE: CGFloat = 17.0
                    }
                    
                }
            }
            
        }
        
    }
    
    // MARK: - Declare Basic Variables

    private var tabBar: TabBarView!
    private var messagesList: UITableView!
    private var newDataReceived: Queue! = Queue<[String: Any]>()
    private var sections: [String]!
    private var messages: [Any]!
    private var reporters: [String: [String: Any]]!
    private var sectionViews: [UIView?] = [UIView?]()
    private var lastSection: Int = 0
    private var lastItem: Int = 0
    private var isStopAutoScroll = false
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func getPresentSection(_ scrollView: UIScrollView) -> UIView? {
        var heightPreviousSection: CGFloat = 0
        for i in 0 ..< self.messagesList.numberOfSections {
            if scrollView.contentOffset.y + CONSTANTS.SCREEN.SAFE_AREA.TOP() <= self.messagesList.rect(forSection: i).height + heightPreviousSection {
                if scrollView.contentOffset.y + CONSTANTS.SCREEN.SAFE_AREA.TOP() - heightPreviousSection > CONSTANTS.SCREEN.MARGIN(3) + DEFAULT.TABLENVIEW.SECTION.HEIGHT {
                    return self.sectionViews.getElement(safe: i) ?? nil
                } else {
                    return nil
                }
            }
            heightPreviousSection += self.messagesList.rect(forSection: i).height
        }
        return nil
    }
    
    @objc private func reloadMessages() {
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        if let reporters: [[String: Any]] = query.fetchRequest([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.FOLLOWING, CONSTANTS.KEYS.SQL.FIELDS: [CONSTANTS.KEYS.JSON.FIELD.ID.USER, CONSTANTS.KEYS.JSON.FIELD.NAME, CONSTANTS.KEYS.JSON.FIELD.THUMB]]) as? [[String: Any]] {
            self.reporters = [String: [String: Any]]()
            for reporter in reporters {
                self.reporters[reporter[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as! String] = [CONSTANTS.KEYS.JSON.FIELD.NAME: reporter[CONSTANTS.KEYS.JSON.FIELD.NAME] ?? "", CONSTANTS.KEYS.JSON.FIELD.THUMB: reporter[CONSTANTS.KEYS.JSON.FIELD.THUMB] ?? ""]
            }
        }
        if let messages: [[String: Any]] = query.fetchRequest([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.MESSAGES]) as? [[String: Any]] {
            self.sections = [String]()
            self.messages = [Any]()
            self.lastSection = 0
            self.lastItem = 0
            var countSection: Int = 0
            var countMessages: Int = 0
            while countSection < CONSTANTS.INFO.APP.BASIC.NUM_DAYS_TO_SHOW {
                var sectionMessages: [Any] = [Any]()
                guard let startDate: Date = Calendar.current.date(byAdding: .day, value: -(CONSTANTS.INFO.APP.BASIC.NUM_DAYS_TO_SHOW - countSection - 1), to: Date()) else {
                    return
                }
                repeat {
                    if let message: [String: Any] = messages.getElement(safe: countMessages), let date: Date = message[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as? Date {
                        if startDate.stripTime().timeIntervalSince1970 == date.stripTime().timeIntervalSince1970 {
                            sectionMessages.append(message)
                            countMessages += 1
                            continue
                        } else if startDate.stripTime().timeIntervalSince1970 > date.stripTime().timeIntervalSince1970 {
                            // delete it
                            countMessages += 1
                            continue
                        }
                    }
                    break
                } while true
                if sectionMessages.count > 0 {
                    self.lastItem = sectionMessages.count - 1
                    self.messages.append(sectionMessages)
                    switch CONSTANTS.INFO.APP.BASIC.NUM_DAYS_TO_SHOW - countSection - 1 {
                    case 0:
                        self.sections.append("TODAY".localized)
                        break
                    case 1:
                        self.sections.append("YESTERDAY".localized)
                        break
                    default:
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "E, d MMM"
                        self.sections.append(inputFormatter.string(from: startDate))
                        break
                    }
                }
                countSection += 1
            }
            self.lastSection = max(self.sections.count - 1, 0)
            self.messagesList.reloadData(completion: {
                self.messagesList.scrollToRow(at: IndexPath(item: self.lastItem, section: self.lastSection), at: .bottom, animated: false)
            })
        }
    }
    
    @objc private func reporterDidChangeName(_ notification: NSNotification) {
        self.reloadMessages()
    }
    
    @objc private func reporterDidChangeThumb(_ notification: NSNotification) {
        self.reloadMessages()
    }
    
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .default)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.backgroundColor = UIColor(named: "Background/Secondary")
        if let img_background: UIImage = UIImage(named: "\(self.classDir())Background") {
            let backgroundImage = UIView(frame: self.bounds)
            backgroundImage.backgroundColor = UIColor(patternImage: img_background)
            self.addSubview(backgroundImage)
        }
        self.tabBar = TabBarView(withFrame: CGRect(x: 0, y: self.frame.height - 56.0 - CONSTANTS.SCREEN.SAFE_AREA.BOTTOM(), width: self.frame.width, height: 56.0 + CONSTANTS.SCREEN.SAFE_AREA.BOTTOM()), delegate: self)
        self.addSubview(self.tabBar)
        self.messagesList = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.tabBar.frame.height))
        self.messagesList.backgroundColor = .clear
        self.messagesList.separatorStyle = .none
        self.messagesList.dataSource = self as UITableViewDataSource
        self.messagesList.delegate = self as UITableViewDelegate
        self.messagesList.semanticContentAttribute = CONSTANTS.SCREEN.LEFT_DIRECTION ? UISemanticContentAttribute.forceLeftToRight : UISemanticContentAttribute.forceRightToLeft
        self.messagesList.register(NoneDesignCell.self, forCellReuseIdentifier: NoneDesignCell.NONE_DESIGN_CELL_REUSE_ID)
        self.messagesList.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.messagesList.frame.width, height: CONSTANTS.SCREEN.MARGIN(2)))
        self.addSubview(self.messagesList)
        self.reloadMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reporterDidChangeName(_ :)), name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.REPORTER.CHANGE.NAME), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reporterDidChangeThumb(_ :)), name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.DID.REPORTER.CHANGE.THUMB), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMessages), name: NSNotification.Name(rawValue: CONSTANTS.KEYS.NOTIFICATION.RELOAD.MESSAGES), object: nil)
        DatatHandler.init().initReporters()
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.transitionToChildOverlapContainer(viewName: "EnableRemoteNotifications", nil, .coverVertical, false, nil)
            }
        } else {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.notificationTransactions(nil)
            UIApplication.shared.registerForRemoteNotifications()
        }
        if let userInfo: [String: Any] = CONSTANTS.GLOBAL.getUserInfo([CONSTANTS.KEYS.JSON.FIELD.ID.USER, CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY]), let userId: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String, let randomKey: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY] as? String {
            let ref: DatabaseReference! = Database.database().reference()
            ref.child(CONSTANTS.KEYS.JSON.COLLECTION.USERS).child(userId).child(CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY).observe(.value, with: { snapshot in
                if randomKey != snapshot.value as! String {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        ref.child("\(CONSTANTS.KEYS.JSON.COLLECTION.USERS)/\(userId)/\(CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY)").removeAllObservers()
                        self.transitionToChildOverlapContainer(viewName: "LoginView", nil, .coverVertical, false, {
                            UserDefaults.standard.set(false, forKey: CONSTANTS.KEYS.USERDEFAULTS.USER.LOGIN)
                        })
                    }
                }
            })
        }
    }
    
}

