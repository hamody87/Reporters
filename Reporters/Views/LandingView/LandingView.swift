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
    
}

extension LandingView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let nextMessage: [String: Any] = messagesArray[indexPath.row]
//        if let height: CGFloat = nextMessage["height"] as? CGFloat {
//            return CONSTANTS.SCREEN.MARGIN(4) + height + DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT + DEFAULT.TABLENVIEW.CELL.MARGIN + DEFAULT.TABLENVIEW.CELL.REPORTER.SIZE.HEIGHT
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CONSTANTS.SCREEN.MARGIN(3) + DEFAULT.TABLENVIEW.SECTION.HEIGHT
    }

}

extension LandingView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView: UIView = UIView()
        let title: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: DEFAULT.TABLENVIEW.SECTION.HEIGHT))
        title.textAlignment = .center
        title.textColor = UIColor(named: "Font/Basic")
        title.text = section == 0 ? "Yesterday" : "Today"
        title.font = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
        title.frame = CGRect(x: 0, y: title.frame.origin.y, width: title.widthOfString() + CONSTANTS.SCREEN.MARGIN(4), height: title.frame.height)
        let coreSectionView: UIView = UIView(frame: CGRect(x: (tableView.frame.width - title.frame.width) / 2.0, y: CONSTANTS.SCREEN.MARGIN(3), width: title.frame.width, height: title.frame.height))
        sectionView.addSubview(coreSectionView)
        if self.sectionViews.indices.contains(section) {
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
            cellView = UIView(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(2), y: CONSTANTS.SCREEN.MARGIN(3), width: cell.bounds.width - CONSTANTS.SCREEN.MARGIN(4), height: 0))
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
            dateLabel.text = "17:22"
            dateLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, false)
            messageView.addSubview(dateLabel)
        }
//        let nextMessage: [String: Any] = self.messagesArray[indexPath.row]
//        let thumb: AsyncImageView = cellView.subviews[0] as! AsyncImageView
//        let reporterName: UILabel = cellView.subviews[1] as! UILabel
//        let favBtn: UIButton = cellView.subviews[2] as! UIButton
//        let shareBtn: UIButton = cellView.subviews[3] as! UIButton
//        let messageView: UIView = cellView.subviews[4]
//        let messageLabel: UILabel = messageView.subviews[0] as! UILabel
//        let dateLabel: UILabel = messageView.subviews[1] as! UILabel
//        cellView.frame = CGRect(x: CONSTANTS.SCREEN.MARGIN(2), y: CONSTANTS.SCREEN.MARGIN(3), width: cell.bounds.width - CONSTANTS.SCREEN.MARGIN(4), height: cell.frame.height - CONSTANTS.SCREEN.MARGIN(3))
//        thumb.frame = CGRect(x: thumb.frame.origin.x, y: cellView.frame.height - DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH, width: thumb.frame.width, height: thumb.frame.height)
//        thumb.setImage(withUrl: NSURL(string: "https://miro.medium.com/fit/c/256/256/1*79d-KFdBY7bZVTgpNs7Vsg.jpeg")!)
//        if let reporter: String = nextMessage[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String {
//            reporterName.text = reporter
//        }
//        reporterName.frame = CGRect(x: reporterName.frame.origin.x, y: cellView.frame.height - reporterName.frame.height, width: reporterName.widthOfString() + CONSTANTS.SCREEN.MARGIN(2), height: reporterName.frame.height)
//        favBtn.frame = CGRect(x: reporterName.frame.origin.x + reporterName.frame.width + CONSTANTS.SCREEN.MARGIN(), y: reporterName.frame.origin.y, width: favBtn.frame.width, height: favBtn.frame.height)
//        shareBtn.frame = CGRect(x: favBtn.frame.origin.x + favBtn.frame.width + CONSTANTS.SCREEN.MARGIN(), y: reporterName.frame.origin.y, width: shareBtn.frame.width, height: shareBtn.frame.height)
//        messageView.frame = CGRect(x: messageView.frame.origin.x, y: messageView.frame.origin.y, width: messageView.frame.width, height: cellView.frame.height - reporterName.frame.height - DEFAULT.TABLENVIEW.CELL.MARGIN)
//        messageView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 16.0)
//        messageLabel.frame = CGRect(x: messageLabel.frame.origin.x, y: messageLabel.frame.origin.y, width: messageLabel.frame.width, height: messageView.frame.height - CONSTANTS.SCREEN.MARGIN() - DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT)
//        if let message: String = nextMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE] as? String {
//            messageLabel.text = message
//            messageLabel.decideTextDirection()
//        }
//        dateLabel.frame = CGRect(x: dateLabel.frame.origin.x, y: messageLabel.frame.origin.y + messageLabel.frame.height, width: dateLabel.frame.width, height: dateLabel.frame.height)
//        if messageLabel.textAlignment == .left {
//            dateLabel.textAlignment = .right
//        } else {
//            dateLabel.textAlignment = .left
//        }
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
                    fileprivate static let COLOR: String = "Font/Basic"
                    
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
    private var messagesArray: [[String: Any]] = [[String: Any]]()
    private var sectionViews: [UIView?] = [UIView?]()
    
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
    
    @objc private func reporterDidChangeName(_ notification: NSNotification) {
        print("reporterDidChangeName \(notification)")
    }
    
    @objc private func reporterDidChangeThumb(_ notification: NSNotification) {
        print("reporterDidChangeThumb \(notification)")
    }
    
    @objc private func reloadMessages() {
        let query: CoreDataStack = CoreDataStack(withCoreData: "CoreData")
        if let messages: [[String: Any]] = query.fetchRequest([CONSTANTS.KEYS.SQL.NAME_ENTITY: CONSTANTS.KEYS.SQL.ENTITY.MESSAGES]) as? [[String: Any]] {
            var sortByDate: Date?
            var newMessagesArray: [[String: Any]] = [[String: Any]]()
            var sectionArr: [String: Any]!
            var messagesArr: [Any]!
            for message in messages {
                let messageDate: Date = message[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as! Date
                if sortByDate?.timeIntervalSince1970 ?? 0 < messageDate.stripTime().timeIntervalSince1970 {
                    if sectionArr != nil {
                        sectionArr[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] = messagesArr
                        newMessagesArray.append(sectionArr)
                    }
                    sortByDate = messageDate.stripTime()
                    sectionArr = [String: Any]()
                    sectionArr[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] = sortByDate
                    messagesArr = [Any]()
                }
                messagesArr.append(message)
            }
            sectionArr[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] = messagesArr
            newMessagesArray.append(sectionArr)
        }
    }
    
    // MARK: - Override Methods

    override func superViewDidAppear() {
        super.superViewDidAppear()
        self.setStatusBarAnyStyle(statusBarStyle: .default)
        self.setStatusBarDarkStyle(statusBarStyle: .lightContent)
//        self.messagesList.scrollToRow(at: IndexPath(item: 6, section: 0), at: .bottom, animated: false)
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
        self.messagesList.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.messagesList.frame.width, height: CONSTANTS.SCREEN.MARGIN(2)))
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

