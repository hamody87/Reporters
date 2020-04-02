//
//  CountriesList.swift
//  Zabit
//
//  Created by Muhammad Jbara on 01/01/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

extension CountriesList: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DEFAULT.TABLEVIEW.CELL.HEIGHT
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37.0 + CONSTANTS.SCREEN.MARGIN()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var argument: [String: Any] = [String: Any]()
        if let dicSection: NSDictionary = self.data[indexPath.section] as? NSDictionary, let dataSection: Array = dicSection["data"] as? Array<Any>, let item: NSDictionary = dataSection[indexPath.row] as? NSDictionary, let code: String = item["value"] as? String {
            argument[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] = code
        }
        self.transferArgumentToPreviousSuperView(anArgument: argument)
        self.dismissChildOverlapContainer()
    }

}

extension CountriesList: UITableViewDataSource {
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var sectionIndexTitle: [String] = [String]()
        for dicSection: Any in self.data {
            if let dicSection: NSDictionary = dicSection as? NSDictionary,  let title: String = dicSection["title"] as? String {
                sectionIndexTitle.append(title)
            }
        }
        return sectionIndexTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dicSection: NSDictionary = self.data[section] as? NSDictionary {
            if let dataSection: Array = dicSection["data"] as? Array<Any> {
                return dataSection.count
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 37.0 + CONSTANTS.SCREEN.MARGIN()))
        sectionView.backgroundColor = UIColor(named: "Background/Secondary")
        let coreSection: UIView = UIView(frame: CGRect(x: 0, y: CONSTANTS.SCREEN.MARGIN(), width: tableView.frame.width, height: 37.0))
        coreSection.backgroundColor = UIColor(named: "Background/Basic")
        sectionView.addSubview(coreSection)
        let topBorder: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1.0))
        topBorder.backgroundColor = UIColor(named: "Background/Border")
        coreSection.addSubview(topBorder)
        let bottomBorder: UIView = UIView(frame: CGRect(x: 0, y: coreSection.frame.height - 1.0, width: tableView.frame.width, height: 1.0))
        bottomBorder.backgroundColor = UIColor(named: "Background/Border")
        coreSection.addSubview(bottomBorder)
        let char = UILabel(frame: CGRect(x: 0, y: 1.0, width: tableView.frame.width, height: 35.0))
        char.backgroundColor = .clear
        char.textColor = .white
        char.textAlignment = .center
        char.numberOfLines = 1
        char.font = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, true)
        coreSection.addSubview(char)
        if let dicSection: NSDictionary = self.data[section] as? NSDictionary {
            if let title: String = dicSection["title"] as? String {
                char.text = title
            }
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoneDesignCell.NONE_DESIGN_CELL_REUSE_ID, for: indexPath)
        let cellView: UIView!
        let flag: UIImageView!
        let nameCountry: UILabel!
        let codeCountry: UILabel!
        if let view: UIView = cell.viewWithTag(DEFAULT.TABLEVIEW.CELL.TAG) {
            cellView = view
            flag = cellView.subviews[0] as? UIImageView
            nameCountry = cellView.subviews[1] as? UILabel
            codeCountry = cellView.subviews[2] as? UILabel
        } else {
            cellView = UIView(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: DEFAULT.TABLEVIEW.CELL.HEIGHT))
            cellView.tag = DEFAULT.TABLEVIEW.CELL.TAG
            cell.contentView.addSubview(cellView)
            let img_flag: UIImage! = UIImage(named: "none")
            flag = UIImageView(frame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? CONSTANTS.SCREEN.MARGIN() : cellView.frame.width - img_flag.size.width - CONSTANTS.SCREEN.MARGIN(), y: (cellView.frame.height - img_flag.size.height) / 2.0, width: img_flag.size.width, height: img_flag.size.height))
            flag.image = img_flag
            cellView.addSubview(flag)
            let widthName: CGFloat = cellView.frame.width - flag.frame.width - CONSTANTS.SCREEN.MARGIN(4) - 50.0
            nameCountry = UILabel(frame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? flag.frame.origin.x + flag.frame.width + CONSTANTS.SCREEN.MARGIN() : CONSTANTS.SCREEN.MARGIN(2) + 50.0, y: 0, width: widthName, height: cellView.frame.height))
            nameCountry.backgroundColor = .clear
            nameCountry.textColor = UIColor(named: "Font/Basic")
            nameCountry.textAlignment = CONSTANTS.SCREEN.LEFT_DIRECTION ? .left : .right
            nameCountry.numberOfLines = 1
            nameCountry.font = CONSTANTS.GLOBAL.createFont(ofSize: 18.0, false)
            cellView.addSubview(nameCountry)
            codeCountry = UILabel(frame: CGRect(x: CONSTANTS.SCREEN.LEFT_DIRECTION ? cellView.frame.width - CONSTANTS.SCREEN.MARGIN() - 50.0 : 10.0, y: 0, width: 50.0, height: cellView.frame.height))
            codeCountry.backgroundColor = .clear
            codeCountry.textColor = UIColor(named: "Font/Basic")
            codeCountry.textAlignment = CONSTANTS.SCREEN.LEFT_DIRECTION ? .right : .left
            codeCountry.numberOfLines = 1
            codeCountry.font = CONSTANTS.GLOBAL.createFont(ofSize: 20.0, false)
            cellView.addSubview(codeCountry)
        }
        if let dicSection: NSDictionary = self.data[indexPath.section] as? NSDictionary {
            if let dataSection: Array = dicSection["data"] as? Array<Any> {
                if let item: NSDictionary = dataSection[indexPath.row] as? NSDictionary {
                    if let name: String = item["image"] as? String {
                        if let img_flag: UIImage = UIImage(named: name) {
                            flag.image = img_flag
                        }
                    }
                    if let name: String = item["text"] as? String {
                        var size: CGFloat = 18.0
                        nameCountry.text = name
                        nameCountry.font = CONSTANTS.GLOBAL.createFont(ofSize: size, false)
                        while nameCountry.widthOfString() > nameCountry.frame.width {
                            size -= 1.0
                            nameCountry.font = CONSTANTS.GLOBAL.createFont(ofSize: size, false)
                        }
                    }
                    if let code: Int = item["code"] as? Int {
                        codeCountry.text = "+\(code)"
                    }
                    cellView.backgroundColor = .clear
                    if let value: String = item["value"] as? String, value == self.codeSelected {
                        cellView.backgroundColor = UIColor(named: "Background/Fourth")
                    }
                }
            }
        }
        return cell
    }
    
}

class CountriesList: TemplateLoginView {
    
    // MARK: - Basic Constants
    
    struct DEFAULT {
        
        struct TABLEVIEW {
            
            struct CELL {
                
                fileprivate static let HEIGHT: CGFloat = 45.0
                fileprivate static let TAG: Int = 111
                
            }
            
        }
        
    }
    
    // MARK: - Declare Basic Variables
    
    private var tableView: UITableView!
    private var data: Array<Any>!
    private var codeSelected: String!
    
    // MARK: - Override Methods

    override func loadSuperView(anArgument: Any!) {
        super.loadSuperView(anArgument: anArgument)
        if let arg: [String: Any] = self.arguments as? [String: Any], let code: String = arg[CONSTANTS.KEYS.JSON.FIELD.COUNTRY.CODE] as? String {
            self.codeSelected = code
        }
        self.tableView.dataSource = self as UITableViewDataSource
        self.tableView.delegate = self as UITableViewDelegate
    }
    
    // MARK: - Interstitial SuperView
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init?(withFrame frame: CGRect!, delegate: SuperViewDelegate?) {
        super.init(withFrame: frame, delegate: delegate)!
        self.title = "COUNTRIES".localized
        self.data = Array()
        var countriesWithCodes: [String: String] = [String: String]()
        for i in 0..<NSLocale.isoCountryCodes.count {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: NSLocale.isoCountryCodes[i]])
            if let name: String = NSLocale(localeIdentifier: CONSTANTS.DEVICE.LANGUAGE.CODE).displayName(forKey: NSLocale.Key.identifier, value: id) {
                countriesWithCodes[NSLocale.isoCountryCodes[i]] = name
            }
        }
        let keyValuePairs: [(key: String, value: String)] = countriesWithCodes.sorted { $0.value < $1.value }
        var dataSection: Array<Any>!
        var firstChar: String!
        var count: Int = 0
        keyValuePairs.forEach {
            count += 1
            let text: String = $0.1
            let index = text.index(text.startIndex, offsetBy: 0)
            if count == 1 || count == keyValuePairs.count || firstChar != "\(text[index])" {
                if count > 1 {
                    var dis: [String: Any] = [String: Any]()
                    dis["title"] = firstChar
                    dis["data"] = dataSection
                    self.data.append(dis)
                }
                dataSection = Array()
                firstChar = "\(text[index])"
            }
            var dis: [String: Any] = [String: Any]()
            dis["text"] = text
            dis["code"] = (CONSTANTS.INFO.GLOBAL.COUNTRY.PHONE_CODE[$0.0] ?? 0)
            dis["value"] = $0.0
            dis["image"] = $0.0.lowercased()
            dataSection.append(dis)
        }
        let withOutHeight: CGFloat = self.safeAreaView.frame.origin.y + self.navBar.frame.height + CONSTANTS.SCREEN.MARGIN(2)
        self.tableView = UITableView(frame: CGRect(x: 0, y: withOutHeight, width: self.frame.width, height: self.frame.height - withOutHeight))
        self.tableView.backgroundColor = UIColor(named: "Background/Secondary")
        self.tableView.separatorStyle = .none
        self.tableView.sectionIndexColor = UIColor(named: "Font/Basic")
        self.tableView.semanticContentAttribute = CONSTANTS.SCREEN.LEFT_DIRECTION ? UISemanticContentAttribute.forceLeftToRight : UISemanticContentAttribute.forceRightToLeft
        self.tableView.register(NoneDesignCell.self, forCellReuseIdentifier: NoneDesignCell.NONE_DESIGN_CELL_REUSE_ID)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: CONSTANTS.SCREEN.SAFE_AREA.BOTTOM() + CONSTANTS.SCREEN.MARGIN(2)))
        self.addSubview(self.tableView)
    }
    
}

