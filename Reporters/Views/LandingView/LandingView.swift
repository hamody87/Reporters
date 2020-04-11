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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messagesArray.count + 10
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
            

            let date: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellView.frame.width, height: 15.0))
            date.backgroundColor = .clear
            date.textColor = UIColor(named: "Font/Basic")
            date.textAlignment = .center
            date.text = "23 MAR, 17:22"
            date.font = CONSTANTS.GLOBAL.createFont(ofSize: 16.0, false)
            cellView.addSubview(date)

            let thumb: AsyncImageView! = AsyncImageView(withFrame: CGRect(x: 0, y: cellView.frame.height - 50.0, width: 50.0, height: 50.0))
            thumb.backgroundColor = UIColor.black
            cellView.addSubview(thumb)
            
            
            let reporterName: UILabel = UILabel(frame: CGRect(x: thumb.frame.width + 3.0, y: cellView.frame.height - 25.0, width: 0, height: 25.0))
            reporterName.backgroundColor = UIColor(named: "Background/Basic")
            reporterName.textColor = UIColor(named: "Font/Third")
            reporterName.textAlignment = .center
            reporterName.text = "23 MAR, 17:22"
            reporterName.font = CONSTANTS.GLOBAL.createFont(ofSize: 14.0, false)
            cellView.addSubview(reporterName)
            
            
            let messageView: UIView = UIView(frame: CGRect(x: reporterName.frame.origin.x, y: date.frame.height + CONSTANTS.SCREEN.MARGIN(), width: cellView.frame.width - reporterName.frame.origin.x, height: 160.0))
            messageView.backgroundColor = UIColor(named: "Background/Third")
            messageView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 16.0)
            cellView.addSubview(messageView)
            
            let messageLabel: UILabel = UILabel(frame: CGRect(x: CONSTANTS.SCREEN.MARGIN(), y: CONSTANTS.SCREEN.MARGIN(), width: messageView.frame.width - CONSTANTS.SCREEN.MARGIN(2), height: messageView.frame.height - CONSTANTS.SCREEN.MARGIN(2)))
            messageLabel.textColor = UIColor(named: "Font/Basic")
            messageLabel.textAlignment = .left
            messageLabel.numberOfLines = 0
            messageLabel.text = "At this point your workspace should build without error you are having problem, post to the Issue and the community can help you solve What you need to know."
            messageLabel.font = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
            messageView.addSubview(messageLabel)
            
        }
        let thumb: AsyncImageView = cellView.subviews[1] as! AsyncImageView

        thumb.setImage(withUrl: NSURL(string: "https://firebasestorage.googleapis.com/v0/b/reporters-3bf40.appspot.com/o/Images%2FWnFUkkAXaPeVxqvT5qZOnN5Bm553%2FThumb%2F1586300369705_WnFUkkAXaPeVxqvT5qZOnN5Bm553_tb?alt=media&token=d21bbd6d-8700-4efa-936a-62cafb789466")!)
       
        let reporterName: UILabel = cellView.subviews[2] as! UILabel
        reporterName.text = "Ivana Kottasov"
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
        return CGSize(width: collectionView.frame.width - CONSTANTS.SCREEN.MARGIN(4), height: 213.0)
        
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
    
    // MARK: - Declare Basic Variables

    private var tabBar: TabBarView!
    private var messagesList: UICollectionView!
    private var messagesArray: [[String: Any]] = [[String: Any]]()
    
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
        self.messagesArray.append(["text": "What you need to know about coronavirus on Friday, April 10", "name": "Ivana Kottasová"])
        
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
//        self.messagesList.scrollToItem(at: <#T##IndexPath#>, at: <#T##UICollectionView.ScrollPosition#>, animated: true)
//        self.messagesList.scrollRectToVisible(self.messagesList., animated: <#T##Bool#>)
        
        
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
        ref.child("messages/123456").observe(.childAdded, with: { snapshot in

            print(snapshot.value)
        })
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
