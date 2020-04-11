//
//  LandingView.swift
//  Reporters
//
//  Created by Muhammad Jbara on 04/04/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit
import FirebaseDatabase

extension LandingView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let cellView: UIView!
        if let view: UIView = cell.viewWithTag(111) {
            cellView = view
        } else {
            cellView = UIView(frame: cell.bounds)
            cellView.tag = 111
            cellView.backgroundColor = .clear
            cell.addSubview(cellView)
            

            let date: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellView.frame.width, height: DEFAULT.COLLECTIONVIEW.CELL.DATE.SIZE.HEIGHT))
            date.backgroundColor = .clear
            date.textColor = UIColor(named: "Font/Basic")
            date.textAlignment = .center
            date.text = "17:22"
            date.font = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, true)
            cellView.addSubview(date)

            let thumb: AsyncImageView! = AsyncImageView(withFrame: CGRect(x: 0, y: cellView.frame.height - DEFAULT.COLLECTIONVIEW.CELL.THUMB.SIZE.BOTH, width: DEFAULT.COLLECTIONVIEW.CELL.THUMB.SIZE.BOTH, height: DEFAULT.COLLECTIONVIEW.CELL.THUMB.SIZE.BOTH))
            thumb.backgroundColor = UIColor(named: DEFAULT.COLLECTIONVIEW.CELL.THUMB.COLOR)
            cellView.addSubview(thumb)
            
            
            let reporterName: UILabel = UILabel(frame: CGRect(x: thumb.frame.width + DEFAULT.COLLECTIONVIEW.CELL.MARGIN, y: cellView.frame.height - DEFAULT.COLLECTIONVIEW.CELL.REPORTER.SIZE.HEIGHT, width: 0, height: DEFAULT.COLLECTIONVIEW.CELL.REPORTER.SIZE.HEIGHT))
            reporterName.backgroundColor = UIColor(named: "Background/Basic")
            reporterName.textColor = UIColor(named: "Font/Third")
            reporterName.textAlignment = .center
            reporterName.font = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
            cellView.addSubview(reporterName)
            
            
            let messageView: UIView = UIView(frame: CGRect(x: reporterName.frame.origin.x, y: date.frame.height + CONSTANTS.SCREEN.MARGIN(), width: cellView.frame.width - reporterName.frame.origin.x, height: cellView.frame.height - date.frame.height - CONSTANTS.SCREEN.MARGIN() - reporterName.frame.height - DEFAULT.COLLECTIONVIEW.CELL.MARGIN))
            messageView.backgroundColor = UIColor(named: "Background/Third")
            messageView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 16.0)
            cellView.addSubview(messageView)
            
            let messageLabel: UILabel = UILabel(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: CONSTANTS.SCREEN.MARGIN(), width: messageView.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: messageView.frame.height - CONSTANTS.SCREEN.MARGIN(2)))
            messageLabel.textColor = UIColor(named: "Font/Basic")
            messageLabel.textAlignment = .left
            messageLabel.numberOfLines = 0
            messageLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: DEFAULT.COLLECTIONVIEW.CELL.MESSAGE.FONT.SIZE, false)
            messageView.addSubview(messageLabel)
            print(messageLabel.frame.width)
            
        }
        let nextMessage: [String: Any] = messagesArray[indexPath.row]
        let thumb: AsyncImageView = cellView.subviews[1] as! AsyncImageView

        thumb.setImage(withUrl: NSURL(string: "https://scontent.fsdv2-1.fna.fbcdn.net/v/t1.0-1/64254850_2861677450571813_1886639830163521536_o.jpg?_nc_cat=103&_nc_sid=dbb9e7&_nc_ohc=mL8Jxvi3o20AX8sAplJ&_nc_ht=scontent.fsdv2-1.fna&oh=ffc9a1c0aebac6b9e448d5ed1c8a71ea&oe=5EB5928A")!)

       if let message: String = nextMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE] as? String {
           let messageView: UIView = cellView.subviews[3]
           let messageLabel: UILabel = messageView.subviews[0] as! UILabel
            messageLabel.text = message
        messageLabel.decideTextDirection()
        }
        let reporterName: UILabel = cellView.subviews[2] as! UILabel
        if let reporter: String = nextMessage[CONSTANTS.KEYS.JSON.FIELD.NAME] as? String {
            reporterName.text = reporter
        }
        reporterName.frame = CGRect(x: reporterName.frame.origin.x, y: reporterName.frame.origin.y, width: reporterName.widthOfString() + CONSTANTS.SCREEN.MARGIN(2), height: reporterName.frame.height)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)
        return header
    }
    
    
}

extension LandingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nextMessage: [String: Any] = messagesArray[indexPath.row]
        if let height: CGFloat = nextMessage["height"] as? CGFloat {
            return CGSize(width: collectionView.frame.width - CONSTANTS.SCREEN.MARGIN(4), height: DEFAULT.COLLECTIONVIEW.CELL.DATE.SIZE.HEIGHT + CONSTANTS.SCREEN.MARGIN(3) + height + DEFAULT.COLLECTIONVIEW.CELL.MARGIN + DEFAULT.COLLECTIONVIEW.CELL.REPORTER.SIZE.HEIGHT)
        }
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CONSTANTS.SCREEN.MARGIN(2), left: CONSTANTS.SCREEN.MARGIN(2), bottom: CONSTANTS.SCREEN.MARGIN(2), right:CONSTANTS.SCREEN.MARGIN(2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CONSTANTS.SCREEN.MARGIN(3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CONSTANTS.SCREEN.MARGIN(3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: CONSTANTS.SCREEN.SAFE_AREA.TOP())
    }
    
}

class LandingView: SuperView {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        struct COLLECTIONVIEW {
            
            struct CELL {
                
                fileprivate static let MARGIN: CGFloat = 3.0
                
                struct DATE {
                    
                    struct SIZE {
                        fileprivate static let HEIGHT: CGFloat = 15.0
                    }
                    
                }
                
                struct THUMB {
                    
                    struct SIZE {
                        fileprivate static let BOTH: CGFloat = 50.0
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
                        fileprivate static let SIZE: CGFloat = 18.0
                    }
                    
                }
            }
            
        }
        
    }
    
    // MARK: - Declare Basic Variables

    private var tabBar: TabBarView!
    private var messagesList: UICollectionView!
    private var newDataReceived: Queue! = Queue<[String: Any]>()
    private var messagesArray: [[String: Any]] = [[String: Any]]()
    
    // MARK: - Public Methods
    
    public func prepareNewData() {
        for _ in 1 ... self.newDataReceived.count {
            if var nextMessage: [String: Any] = self.newDataReceived.dequeue() ,let message: String = nextMessage[CONSTANTS.KEYS.JSON.FIELD.MESSAGE] as? String {
                if let label: UILabel = CONSTANTS.GLOBAL.createLabelElement(withFrame: CGRect(x: 0, y: 0, width: self.messagesList.frame.width - CONSTANTS.SCREEN.MARGIN(6) - DEFAULT.COLLECTIONVIEW.CELL.MARGIN - DEFAULT.COLLECTIONVIEW.CELL.THUMB.SIZE.BOTH, height: 0), {
                    var argument: [String: Any] = [String: Any]()
                    argument[CONSTANTS.KEYS.ELEMENTS.TEXT] = message
                    argument[CONSTANTS.KEYS.ELEMENTS.NUMLINES] = 0
                    argument[CONSTANTS.KEYS.ELEMENTS.FONT] = CONSTANTS.GLOBAL.createFont(ofSize: DEFAULT.COLLECTIONVIEW.CELL.MESSAGE.FONT.SIZE, false)
                    return argument
                }())[CONSTANTS.KEYS.ELEMENTS.SELF] as? UILabel {
                    nextMessage["height"] = label.heightOfString()
                    messagesArray.append(nextMessage)
                }
            }
        }
        self.messagesList.reloadData()
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
        self.newDataReceived.enqueue(["message": "For professional athlete Irena Gillarova, from the Czech Republic, the easing of restrictions Thursday meant she could return to training at the Juliska stadium in Prague for the first time since her country locked down.", "fullName": "Laura Smith-Spark"])
        self.newDataReceived.enqueue(["message": "What you need to know about coronavirus on Friday", "fullName": "Ivana Kottasová"])
        self.newDataReceived.enqueue(["message": "Dr. Peter Drobac, a global health expert at the Oxford Saïd Business School, told CNN that those countries now easing their restrictions were \"important and hopeful examples\" for the West.", "fullName": "Ivana Kottasová"])
        self.newDataReceived.enqueue(["message": "\"They had these things in place and as a result they are already past the peak of infections there,\" he said. The numbers of coronavirus-related deaths in these nations are in the tens or hundreds, rather than the thousands, he said, and \"they are in a much better place because of proactive action.\"", "fullName": "Ivana Kottasová"])
        self.newDataReceived.enqueue(["message": "من جانبها ايضا عممت بلدية الطيبة بياناً حول الأماكن التي تواجد فيها بعض مصابي الكورونا، وارفقت رابط الوزارة للإطلاع على كافة التفاصيل.", "fullName": "محمد شيخ يوسف"])
        
        self.messagesList = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - self.tabBar.frame.height), collectionViewLayout: UICollectionViewFlowLayout())
        self.messagesList.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            self.messagesList.contentInsetAdjustmentBehavior = .never
        }
        self.messagesList.semanticContentAttribute = .forceLeftToRight
        self.messagesList.dataSource = self as UICollectionViewDataSource
        self.messagesList.delegate = self as UICollectionViewDelegateFlowLayout
        self.messagesList.register(StyleCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.messagesList.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        self.addSubview(self.messagesList)
        self.messagesList.scrollToItem(at: IndexPath(item: 10, section: 1), at: .centeredVertically, animated: false)

        
        self.prepareNewData()
        
        
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.transitionToChildOverlapContainer(viewName: "EnableRemoteNotifications", nil, .coverVertical, false, nil)
            }
        } else {
            let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.notificationTransactions(nil)
            UIApplication.shared.registerForRemoteNotifications()
        }

        let ref: DatabaseReference! = Database.database().reference()
//        ref.child("messages/123456").observe(.childAdded, with: { snapshot in
//
//            print(snapshot.value)
//        })
        if let userInfo: [String: Any] = CONSTANTS.GLOBAL.getUserInfo([CONSTANTS.KEYS.JSON.FIELD.ID.USER, CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY]), let userId: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.ID.USER] as? String, let randomKey: String = userInfo[CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY] as? String {
            let ref: DatabaseReference! = Database.database().reference()
            ref.child("\(CONSTANTS.KEYS.JSON.COLLECTION.USERS)/\(userId)/\(CONSTANTS.KEYS.JSON.FIELD.RANDOM_KEY)").observe(.value, with: { snapshot in
                
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
