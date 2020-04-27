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

class MoreOptionsGesture: UILongPressGestureRecognizer {
    
    private var _indexPath: IndexPath? = nil
    open var indexPath: IndexPath? {
        set(value) {
            self._indexPath = value
        }
        get {
            return self._indexPath
        }
    }
    private var _followMessage: Bool = false
    open var followMessage: Bool {
        set(value) {
            self._followMessage = value
        }
        get {
            return self._followMessage
        }
    }
    
}

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
        if let sectionMessages: [Any] = self.messages[indexPath.section] as? [Any], let currentMessage: [String: Any] = sectionMessages[indexPath.row] as? [String: Any], let content: [String: Any] = currentMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] as? [String: Any], let height: CGFloat = content[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.HEIGHT] as? CGFloat, let isFollowMessage: Bool = currentMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.FOLLOW] as? Bool  {
            return CONSTANTS.SCREEN.MARGIN() + height + DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT + DEFAULT.TABLENVIEW.CELL.MARGIN + (isFollowMessage ? 0 : DEFAULT.TABLENVIEW.CELL.REPORTER.SIZE.HEIGHT + CONSTANTS.SCREEN.MARGIN(3))
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
        let cellFollowView: UIView!
        if let view: UIView = cell.viewWithTag(111) {
            cellView = view
        } else {
            cellView = UIView()
            cellView.tag = 111
            cellView.backgroundColor = .clear
            cell.addSubview(cellView)
            let thumb: AsyncImageView! = AsyncImageView(withFrame: CGRect(x: 0, y: 0, width: DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH, height: DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH))
            thumb.backgroundColor = UIColor(named: DEFAULT.TABLENVIEW.CELL.THUMB.COLOR)
            cellView.addSubview(thumb)
            let reporterNameView: UILabel = UILabel(frame: CGRect(x: thumb.frame.width + DEFAULT.TABLENVIEW.CELL.MARGIN, y: 0, width: 0, height: DEFAULT.TABLENVIEW.CELL.REPORTER.SIZE.HEIGHT))
            reporterNameView.backgroundColor = UIColor(named: "Background/Basic")
            cellView.addSubview(reporterNameView)
            let img_starBtn: UIImage! = UIImage(named: "\(self.classDir())StarOnBtn")
            let margin: CGFloat = (reporterNameView.frame.height - img_starBtn.size.height) / 2.0
            let starBtn: UIButton = UIButton(frame: CGRect(x: margin, y: margin, width: img_starBtn.size.width, height: img_starBtn.size.height))
            starBtn.setImage(img_starBtn, for: UIControl.State.normal)
            reporterNameView.addSubview(starBtn)
            let reporterName: UILabel = UILabel(frame: CGRect(x: starBtn.frame.width + margin * 2.0, y: 0, width: 0, height: DEFAULT.TABLENVIEW.CELL.REPORTER.SIZE.HEIGHT))
            reporterName.backgroundColor = UIColor(named: "Background/Basic")
            reporterName.textColor = UIColor.white
            reporterName.textAlignment = .center
            reporterName.font = CONSTANTS.GLOBAL.createFont(ofSize: 15.0, false)
            reporterNameView.addSubview(reporterName)
            let messageView: UIView = UIView()
            messageView.backgroundColor = UIColor(named: "Background/Third")
            cellView.addSubview(messageView)
            let messageLabel: UILabel = UILabel()
            messageLabel.backgroundColor = .clear
            messageLabel.textColor = UIColor(named: "Font/Basic")
            messageLabel.numberOfLines = 0
            messageLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: DEFAULT.TABLENVIEW.CELL.MESSAGE.FONT.SIZE, false)
            messageView.addSubview(messageLabel)
            let dateLabel: UILabel = UILabel()
            dateLabel.backgroundColor = .clear
            dateLabel.textColor = UIColor(named: "Font/Basic")
            dateLabel.textAlignment = .right
            dateLabel.alpha = 0.5
            dateLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, false)
            messageView.addSubview(dateLabel)
            let img_favIcon: UIImage! = UIImage(named: "\(self.classDir())FavIcon")
            let favIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img_favIcon.size.width, height: img_favIcon.size.height))
            favIcon.image = img_favIcon
            messageView.addSubview(favIcon)
            let unreadBadge: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 6.0, height: 6.0))
            unreadBadge.layer.cornerRadius = unreadBadge.frame.width / 2.0
            unreadBadge.backgroundColor = .red
            messageView.addSubview(unreadBadge)
            let lpgr = MoreOptionsGesture(target: self, action: #selector(self.presentMoreOptions(gesture:)))
            lpgr.minimumPressDuration = 0.5
            lpgr.delaysTouchesBegan = true
            messageView.addGestureRecognizer(lpgr)
            let shareBtnView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH, height: DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH))
            cellView.addSubview(shareBtnView)
            let shareBackground: UIImageView = UIImageView(frame: shareBtnView.bounds)
            shareBackground.backgroundColor = UIColor(named: "Background/Third")
            shareBackground.alpha = 0.5
            shareBackground.layer.cornerRadius = DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH / 2.0
            shareBtnView.addSubview(shareBackground)
            let img_shareBtn: UIImage! = UIImage(named: "\(self.classDir())ShareBtn")
            let shareImg: UIImageView = UIImageView(frame: CGRect(x: (shareBtnView.frame.width - img_shareBtn.size.width) / 2.0, y: (shareBtnView.frame.height - img_shareBtn.size.height) / 2.0, width: img_shareBtn.size.width, height: img_shareBtn.size.height))
            shareImg.image = img_shareBtn
            shareBtnView.addSubview(shareImg)
        }
        if let view: UIView = cell.viewWithTag(222) {
            cellFollowView = view
        } else {
            cellFollowView = UIView()
            cellFollowView.tag = 222
            cellFollowView.backgroundColor = .clear
            cell.addSubview(cellFollowView)
            let messageView: UIView = UIView()
            messageView.backgroundColor = UIColor(named: "Background/Third")
            cellFollowView.addSubview(messageView)
            let messageLabel: UILabel = UILabel()
            messageLabel.backgroundColor = .clear
            messageLabel.textColor = UIColor(named: "Font/Basic")
            messageLabel.numberOfLines = 0
            messageLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: DEFAULT.TABLENVIEW.CELL.MESSAGE.FONT.SIZE, false)
            messageView.addSubview(messageLabel)
            let dateLabel: UILabel = UILabel()
            dateLabel.backgroundColor = .clear
            dateLabel.textColor = UIColor(named: "Font/Basic")
            dateLabel.textAlignment = .right
            dateLabel.alpha = 0.5
            dateLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, false)
            messageView.addSubview(dateLabel)
            let img_favIcon: UIImage! = UIImage(named: "\(self.classDir())FavIcon")
            let favIcon: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img_favIcon.size.width, height: img_favIcon.size.height))
            favIcon.image = img_favIcon
            messageView.addSubview(favIcon)
            let unreadBadge: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 6.0, height: 6.0))
            unreadBadge.layer.cornerRadius = unreadBadge.frame.width / 2.0
            unreadBadge.backgroundColor = .red
            messageView.addSubview(unreadBadge)
            let lpgr = MoreOptionsGesture(target: self, action: #selector(self.presentMoreOptions(gesture:)))
            lpgr.minimumPressDuration = 0.5
            lpgr.delaysTouchesBegan = true
            messageView.addGestureRecognizer(lpgr)
            let shareBtnView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH, height: DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH))
            cellFollowView.addSubview(shareBtnView)
            let shareBackground: UIImageView = UIImageView(frame: shareBtnView.bounds)
            shareBackground.backgroundColor = UIColor(named: "Background/Third")
            shareBackground.alpha = 0.5
            shareBackground.layer.cornerRadius = DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH / 2.0
            shareBtnView.addSubview(shareBackground)
            let img_shareBtn: UIImage! = UIImage(named: "\(self.classDir())ShareBtn")
            let shareImg: UIImageView = UIImageView(frame: CGRect(x: (shareBtnView.frame.width - img_shareBtn.size.width) / 2.0, y: (shareBtnView.frame.height - img_shareBtn.size.height) / 2.0, width: img_shareBtn.size.width, height: img_shareBtn.size.height))
            shareImg.image = img_shareBtn
            shareBtnView.addSubview(shareImg)
        }
        if let sectionMessages: [Any] = self.messages[indexPath.section] as? [Any], let currentMessage: [String: Any] = sectionMessages[indexPath.row] as? [String: Any], let reporterID: String = currentMessage[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String, let isFollowMessage: Bool = currentMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.FOLLOW] as? Bool {
            let messageView: UIView!
            let messageLabel: UILabel!
            let dateLabel: UILabel!
            let favIcon: UIImageView!
            let unreadBadge: UIView!
            let shareBtnView: UIView!
            if isFollowMessage {
                cellFollowView.isHidden = false
                cellView.isHidden = true
                messageView = cellFollowView.subviews[0]
                messageLabel = messageView.subviews[0] as? UILabel
                dateLabel = messageView.subviews[1] as? UILabel
                favIcon = messageView.subviews[2] as? UIImageView
                unreadBadge = messageView.subviews[3]
                shareBtnView = cellFollowView.subviews[1]
                cellFollowView.frame = CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: 0, width: cell.bounds.width - CONSTANTS.SCREEN.MARGIN(2), height: cell.frame.height - DEFAULT.TABLENVIEW.CELL.MARGIN)
                messageView.frame = CGRect(x: DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH + DEFAULT.TABLENVIEW.CELL.MARGIN, y: 0, width: 0, height: cellFollowView.frame.height)
            } else {
                cellFollowView.isHidden = true
                cellView.isHidden = false
                messageView = cellView.subviews[2]
                messageLabel = messageView.subviews[0] as? UILabel
                dateLabel = messageView.subviews[1] as? UILabel
                favIcon = messageView.subviews[2] as? UIImageView
                unreadBadge = messageView.subviews[3]
                shareBtnView = cellView.subviews[3]
                let thumb: AsyncImageView = cellView.subviews[0] as! AsyncImageView
                let reporterNameView: UIView = cellView.subviews[1]
                let _: UIButton = reporterNameView.subviews[0] as! UIButton //starBtn
                let reporterName: UILabel = reporterNameView.subviews[1] as! UILabel
                cellView.frame = CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: 0, width: cell.bounds.width - CONSTANTS.SCREEN.MARGIN(2), height: cell.frame.height - CONSTANTS.SCREEN.MARGIN(3))
                messageView.frame = CGRect(x: DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH + DEFAULT.TABLENVIEW.CELL.MARGIN, y: 0, width: 0, height: cellView.frame.height - DEFAULT.TABLENVIEW.CELL.MARGIN - DEFAULT.TABLENVIEW.CELL.REPORTER.SIZE.HEIGHT)
                thumb.frame = CGRect(x: thumb.frame.origin.x, y: cellView.frame.height - DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH, width: DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH, height: thumb.frame.height)
                if let reporter: [String: Any] = self.reporters[reporterID], let name: String = reporter[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String, let reporterThumb: String = reporter[CONSTANTS.KEYS.JSON.FIELD.THUMB] as? String {
                    thumb.setImage(withUrl: NSURL(string: reporterThumb)!)
                    reporterName.text = name
                }
                reporterName.frame = CGRect(x: reporterName.frame.origin.x, y: 0, width: reporterName.widthOfString(), height: reporterName.frame.height)
                reporterNameView.frame = CGRect(x: reporterNameView.frame.origin.x, y: cellView.frame.height - reporterNameView.frame.height, width: reporterName.frame.origin.x + reporterName.frame.width + CONSTANTS.SCREEN.MARGIN(), height: reporterNameView.frame.height)
            }
            if let lpgr = messageView.gestureRecognizers?.getElement(safe: 0) as? MoreOptionsGesture {
                lpgr.indexPath = indexPath
                lpgr.followMessage = isFollowMessage
            }
            if let content: [String: Any] = currentMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.SELF] as? [String: Any], let element: String = content[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.SELF] as? String, let value: String = content[element] as? String  {
                switch element {
            //                case CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.IMAGE:
            //                    break
            //                case CONSTANTS.KEYS.JSON.FIELD.MESSAGE.ELEMENT.IMAGE:
            //                    break
                default:
                    messageLabel.frame = CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: CONSTANTS.SCREEN.MARGIN(), width: 0, height: 0)
                    messageLabel.text = value
                    messageLabel.decideTextDirection()
                    let fullWidth: CGFloat = (isFollowMessage ? cellFollowView.frame.width : cellView.frame.width) - DEFAULT.TABLENVIEW.CELL.THUMB.SIZE.BOTH - DEFAULT.TABLENVIEW.CELL.MARGIN - CONSTANTS.SCREEN.MARGIN(1) - DEFAULT.TABLENVIEW.CELL.SHARE.SIZE.BOTH
                    messageView.frame = CGRect(x: messageView.frame.origin.x, y: messageView.frame.origin.y, width: messageLabel.widthOfString() < fullWidth ? messageLabel.widthOfString() + CONSTANTS.SCREEN.MARGIN(2) : fullWidth, height: messageView.frame.height)
                    messageView.roundCorners(corners: isFollowMessage ? [.allCorners] : [.topLeft, .topRight, .bottomRight], radius: 16.0)
                    messageLabel.frame = CGRect(x: messageLabel.frame.origin.x, y: messageLabel.frame.origin.y, width: messageView.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: messageView.frame.height - CONSTANTS.SCREEN.MARGIN() - DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT)
                    break
                }
            }
            if let date: Date = currentMessage[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as? Date {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "HH:mm"
                dateLabel.text = inputFormatter.string(from: date)
            }
            dateLabel.frame = CGRect(x: messageView.frame.width - dateLabel.widthOfString() - CONSTANTS.SCREEN.MARGIN(), y: messageLabel.frame.origin.y + messageLabel.frame.height, width: dateLabel.widthOfString(), height: DEFAULT.TABLENVIEW.CELL.DATE.SIZE.HEIGHT)
            favIcon.frame = CGRect(x: dateLabel.frame.origin.x - favIcon.frame.width - 4.0, y: messageView.frame.height - favIcon.frame.height - 9.0, width: favIcon.frame.width, height: favIcon.frame.height)
            unreadBadge.frame = CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: messageView.frame.height - CONSTANTS.SCREEN.MARGIN() - unreadBadge.frame.height, width: unreadBadge.frame.width, height: unreadBadge.frame.height)
            shareBtnView.frame = CGRect(x: messageView.frame.origin.x + messageView.frame.width + CONSTANTS.SCREEN.MARGIN(), y: (messageView.frame.height - shareBtnView.frame.height) / 2.0, width: shareBtnView.frame.width, height: shareBtnView.frame.height)
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
                
                struct SHARE {
                    
                    struct SIZE {
                        static let BOTH: CGFloat = 30.0
                    }
                    
                }
                
                struct MESSAGE {
                    
                    struct FONT {
                        static let SIZE: CGFloat = 16.0
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
    private var messageMoreOptions: UIView!
    private var backgroundMoreOptions: UIView!
    private var listOptions: UIView!
    private var isStopAutoScroll: Bool = false
    
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    @objc private func dismissMoreOptions(gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.backgroundMoreOptions.alpha = 0
            self.listOptions.alpha = 0
            self.listOptions.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }, completion: { _ in
            self.messageMoreOptions.removeFromSuperview()
            self.backgroundMoreOptions.removeFromSuperview()
            self.listOptions.removeFromSuperview()
            self.messageMoreOptions = nil
            self.backgroundMoreOptions = nil
            self.listOptions = nil
        })
    }
    
    @objc private func presentMoreOptions(gesture: UIGestureRecognizer) {
        if let longPress = gesture as? MoreOptionsGesture {
            if longPress.state == UIGestureRecognizer.State.began {
                if let indexPath: IndexPath = longPress.indexPath, let messageView: UIView = longPress.view?.clone() {
                    print(gesture.location(in: self))
                    let isFollowMessage: Bool = longPress.followMessage
                    let origin: CGPoint = self.messagesList.cellForRow(at: indexPath)?.frame.origin ?? CGPoint(x: 0, y: 0)
                    self.messageMoreOptions = messageView
                    self.backgroundMoreOptions = UIView(frame: self.bounds)
                    self.backgroundMoreOptions.backgroundColor = .black
                    self.backgroundMoreOptions.alpha = 0
                    self.addSubview(self.backgroundMoreOptions)
                    let gestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.dismissMoreOptions(gesture:)))
                    gestureBackground.numberOfTapsRequired = 1
                    self.backgroundMoreOptions.addGestureRecognizer(gestureBackground)
                    self.messageMoreOptions.frame = CGRect(x: CONSTANTS.SCREEN.MARGIN() + messageView.frame.origin.x, y: origin.y + CONSTANTS.SCREEN.SAFE_AREA.TOP(), width: messageView.frame.width, height: messageView.frame.height)
                    self.messageMoreOptions.roundCorners(corners: isFollowMessage ? [.allCorners] : [.topLeft, .topRight, .bottomRight], radius: 16.0)
                    let unreadBadge = self.messageMoreOptions.subviews[3]
                    unreadBadge.layer.cornerRadius = unreadBadge.frame.width / 2.0
                    self.addSubview(self.messageMoreOptions)
                    let gestureMessage = UITapGestureRecognizer(target: self, action: #selector(self.dismissMoreOptions(gesture:)))
                    gestureMessage.numberOfTapsRequired = 1
                    self.messageMoreOptions.addGestureRecognizer(gestureMessage)
                    
                    let sizePupup: CGSize = CGSize(width: 100.0, height: 50.0)
                    let img_arrow: UIImage! = UIImage(named: "\(self.classDir())ArrowOptions")
                    
                    self.listOptions = UIView(frame: CGRect(x: gesture.location(in: self).x - (sizePupup.width / 2.0), y: gesture.location(in: self).y - sizePupup.height - 50.0, width: sizePupup.width, height: sizePupup.height + img_arrow.size.height))
                    self.listOptions.alpha = 0
                    self.addSubview(self.listOptions)
                    
                    let coreListOptions: UIView = UIView(frame: CGRect(origin: .zero, size: sizePupup))
                    coreListOptions.layer.shadowPath = UIBezierPath(rect: coreListOptions.bounds).cgPath
                    coreListOptions.layer.cornerRadius = 10.0
                    coreListOptions.layer.shadowRadius = 10.0
                    coreListOptions.layer.shadowOffset = .zero
                    coreListOptions.layer.shadowOpacity = 0.4
                    coreListOptions.backgroundColor = UIColor(named: "Background/Options")
                    self.listOptions.addSubview(coreListOptions)
                    
                    
                    let img_saveIcon: UIImage! = UIImage(named: "\(self.classDir())SaveIcon")
                    let saveIcon: UIImageView = UIImageView(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: (coreListOptions.frame.height - img_saveIcon.size.height) / 2.0, width: img_saveIcon.size.width, height: img_saveIcon.size.height))
                    saveIcon.image = img_saveIcon
                    coreListOptions.addSubview(saveIcon)
                    
                    let label: UILabel = UILabel(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(2) + saveIcon.frame.width, y: 0, width: coreListOptions.frame.width - CONSTANTS.SCREEN.MARGIN(2) - saveIcon.frame.width, height: coreListOptions.frame.height))
                    label.backgroundColor = .clear
                    label.text = "SAVE".localized
                    label.textColor = UIColor(named: "Font/Second")
                    label.font = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
                    coreListOptions.addSubview(label)
                    
                    let arrow: UIImageView = UIImageView(frame: CGRect(x: (sizePupup.width - img_arrow.size.width) / 2.0, y: coreListOptions.frame.height, width: img_arrow.size.width, height: img_arrow.size.height))
                    arrow.image = img_arrow
                    self.listOptions.addSubview(arrow)
                    
                    
                    
                    
                    self.listOptions.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [],  animations: {
                        self.listOptions.alpha = 1.0
                        self.listOptions.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.prepare()
                        generator.impactOccurred()
                    })
                    UIView.animate(withDuration: 0.2, animations: {
                        self.backgroundMoreOptions.alpha = 0.6
                    })
                    
                    
                }
                
            }
        }
    }
    
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
                    if var message: [String: Any] = messages.getElement(safe: countMessages), let userID: String = message[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String, let date: Date = message[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as? Date {
                        print(message)
                        if startDate.stripTime().timeIntervalSince1970 == date.stripTime().timeIntervalSince1970 {
                            message[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.FOLLOW] = false
                            if let nextMessage: [String: Any] = messages.getElement(safe: countMessages + 1), let nextUserID: String = nextMessage[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String, let dateNextMessage: Date = nextMessage[CONSTANTS.KEYS.JSON.FIELD.DATE.SELF] as? Date, userID == nextUserID && startDate.stripTime().timeIntervalSince1970 == dateNextMessage.stripTime().timeIntervalSince1970 {
                                message[CONSTANTS.KEYS.JSON.FIELD.MESSAGE.FOLLOW] = true
                            }
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
            
            print("\(self.lastItem), section: \(self.lastSection)")
            self.messagesList?.reloadData(completion: {
//                self.messagesList.scrollToRow(at: IndexPath(item: self.lastItem, section: self.lastSection), at: .bottom, animated: false)
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

