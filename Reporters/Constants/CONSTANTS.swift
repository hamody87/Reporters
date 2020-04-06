//
//  CONSTANTS.swift
//  Reporters
//
//  Created by Muhammad Jbara on 17/03/2020.
//  Copyright © 2020 Muhammad Jbara. All rights reserved.
//

import UIKit

public class CONSTANTS {
    
    static let GLOBAL: Global = Global()
    
    struct APPDELEGATE {
        
        static func WINDOW() -> UIWindow! {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                return window
            }
            return nil
        }
        
    }
    
    struct INFO {
        
        struct APP {
            
            struct BUNDLE {
                
                static let NAME: String = Bundle.main.infoDictionary!["CFBundleName"] as! String
                static let DISPLAY_NAME: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
                static let VERSION: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                
            }
            
            struct APPSTORE {
                
                static let URL: String = "https://itunes.apple.com/us/app/hkmt-wmw-zt/id665705246?ls=1&mt=8"
                static let ID: Int = 665705246
                
            }
            
            struct ONESIGNAL {
                static let ID: String = "17aecdf1-b07b-4f8c-bb85-b446c9bd2a58"
            }
            
        }
        
        struct GLOBAL {
            
            struct COUNTRY {
                
                static let CODE: String = {
                    if let nameCountry: String = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                        return nameCountry
                    }
                    return "Unknown".localized
                }()

                static func NAME(code: String) -> String {
                    if let nameCountry: String = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: code) {
                        return nameCountry
                    }
                    return "Unknown".localized
                }
                
                static let PHONE_CODE: [String: Int] = ["AF": 93,
                                                        "AL": 355,
                                                        "DZ": 213,
                                                        "AS": 1,
                                                        "AD": 376,
                                                        "AO": 244,
                                                        "AI": 1,
                                                        "AG": 1,
                                                        "AR": 54,
                                                        "AM": 374,
                                                        "AW": 297,
                                                        "AU": 61,
                                                        "AT": 43,
                                                        "AZ": 994,
                                                        "BS": 1,
                                                        "BH": 973,
                                                        "BD": 880,
                                                        "BB": 1,
                                                        "BY": 375,
                                                        "BE": 32,
                                                        "BZ": 501,
                                                        "BJ": 229,
                                                        "BM": 1,
                                                        "BT": 975,
                                                        "BA": 387,
                                                        "BW": 267,
                                                        "BR": 55,
                                                        "IO": 246,
                                                        "BG": 359,
                                                        "BF": 226,
                                                        "BI": 257,
                                                        "KH": 855,
                                                        "CM": 237,
                                                        "CA": 1,
                                                        "CV": 238,
                                                        "KY": 345,
                                                        "CF": 236,
                                                        "TD": 235,
                                                        "CL": 56,
                                                        "CN": 86,
                                                        "CX": 61,
                                                        "CO": 57,
                                                        "KM": 269,
                                                        "CG": 242,
                                                        "CK": 682,
                                                        "CR": 506,
                                                        "HR": 385,
                                                        "CU": 53,
                                                        "CY": 537,
                                                        "CZ": 420,
                                                        "DK": 45,
                                                        "DJ": 253,
                                                        "DM": 1,
                                                        "DO": 1,
                                                        "EC": 593,
                                                        "EG": 20,
                                                        "SV": 503,
                                                        "GQ": 240,
                                                        "ER": 291,
                                                        "EE": 372,
                                                        "ET": 251,
                                                        "FO": 298,
                                                        "FJ": 679,
                                                        "FI": 358,
                                                        "FR": 33,
                                                        "GF": 594,
                                                        "PF": 689,
                                                        "GA": 241,
                                                        "GM": 220,
                                                        "GE": 995,
                                                        "DE": 49,
                                                        "GH": 233,
                                                        "GI": 350,
                                                        "GR": 30,
                                                        "GL": 299,
                                                        "GD": 1,
                                                        "GP": 590,
                                                        "GU": 1,
                                                        "GT": 502,
                                                        "GN": 224,
                                                        "GW": 245,
                                                        "GY": 595,
                                                        "HT": 509,
                                                        "HN": 504,
                                                        "HU": 36,
                                                        "IS": 354,
                                                        "IN": 91,
                                                        "ID": 62,
                                                        "IQ": 964,
                                                        "IE": 353,
                                                        "IL": 972,
                                                        "IT": 39,
                                                        "JM": 1,
                                                        "JP": 81,
                                                        "JO": 962,
                                                        "KZ": 77,
                                                        "KE": 254,
                                                        "KI": 686,
                                                        "KW": 965,
                                                        "KG": 996,
                                                        "LV": 371,
                                                        "LB": 961,
                                                        "LS": 266,
                                                        "LR": 231,
                                                        "LI": 423,
                                                        "LT": 370,
                                                        "LU": 352,
                                                        "MG": 261,
                                                        "MW": 265,
                                                        "MY": 60,
                                                        "MV": 960,
                                                        "ML": 223,
                                                        "MT": 356,
                                                        "MH": 692,
                                                        "MQ": 596,
                                                        "MR": 222,
                                                        "MU": 230,
                                                        "YT": 262,
                                                        "MX": 52,
                                                        "MC": 377,
                                                        "MN": 976,
                                                        "ME": 382,
                                                        "MS": 1,
                                                        "MA": 212,
                                                        "MM": 95,
                                                        "NA": 264,
                                                        "NR": 674,
                                                        "NP": 977,
                                                        "NL": 31,
                                                        "AN": 599,
                                                        "NC": 687,
                                                        "NZ": 64,
                                                        "NI": 505,
                                                        "NE": 227,
                                                        "NG": 234,
                                                        "NU": 683,
                                                        "NF": 672,
                                                        "MP": 1,
                                                        "NO": 47,
                                                        "OM": 968,
                                                        "PK": 92,
                                                        "PW": 680,
                                                        "PA": 507,
                                                        "PG": 675,
                                                        "PY": 595,
                                                        "PE": 51,
                                                        "PH": 63,
                                                        "PL": 48,
                                                        "PT": 351,
                                                        "PR": 1,
                                                        "QA": 974,
                                                        "RO": 40,
                                                        "RW": 250,
                                                        "WS": 685,
                                                        "SM": 378,
                                                        "SA": 966,
                                                        "SN": 221,
                                                        "RS": 381,
                                                        "SC": 248,
                                                        "SL": 232,
                                                        "SG": 65,
                                                        "SK": 421,
                                                        "SI": 386,
                                                        "SB": 677,
                                                        "ZA": 27,
                                                        "GS": 500,
                                                        "ES": 34,
                                                        "LK": 94,
                                                        "SD": 249,
                                                        "SR": 597,
                                                        "SZ": 268,
                                                        "SE": 46,
                                                        "CH": 41,
                                                        "TJ": 992,
                                                        "TH": 66,
                                                        "TG": 228,
                                                        "TK": 690,
                                                        "TO": 676,
                                                        "TT": 1,
                                                        "TN": 216,
                                                        "TR": 90,
                                                        "TM": 993,
                                                        "TC": 1,
                                                        "TV": 688,
                                                        "UG": 256,
                                                        "UA": 380,
                                                        "AE": 971,
                                                        "GB": 44,
                                                        "US": 1,
                                                        "UY": 598,
                                                        "UZ": 998,
                                                        "VU": 678,
                                                        "WF": 681,
                                                        "YE": 967,
                                                        "ZM": 260,
                                                        "ZW": 263,
                                                        "BO": 591,
                                                        "BN": 673,
                                                        "CC": 61,
                                                        "CD": 243,
                                                        "CI": 225,
                                                        "FK": 500,
                                                        "GG": 44,
                                                        "VA": 379,
                                                        "HK": 852,
                                                        "IR": 98,
                                                        "IM": 44,
                                                        "JE": 44,
                                                        "KP": 850,
                                                        "KR": 82,
                                                        "LA": 856,
                                                        "LY": 218,
                                                        "MO": 853,
                                                        "MK": 389,
                                                        "FM": 691,
                                                        "MD": 373,
                                                        "MZ": 258,
                                                        "PS": 970,
                                                        "PN": 872,
                                                        "RE": 262,
                                                        "RU": 7,
                                                        "BL": 590,
                                                        "SH": 290,
                                                        "KN": 1,
                                                        "LC": 1,
                                                        "MF": 590,
                                                        "PM": 508,
                                                        "VC": 1,
                                                        "ST": 239,
                                                        "SO": 252,
                                                        "SJ": 47,
                                                        "SY": 963,
                                                        "TW": 886,
                                                        "TZ": 255,
                                                        "TL": 670,
                                                        "VE": 58,
                                                        "VN": 84,
                                                        "VG": 284,
                                                        "VI": 340]
                
            }
            
            static func LANDING_VIEW() -> String {
                if UserDefaults.standard.bool(forKey: KEYS.USERDEFAULTS.USER.LOGIN) {
                    return "LandingView"
                }
                return "LoginView"
            }
            
            struct CALCULATION {
                
                struct TIME {
                    
                    static func HOUR(postDate: Date) -> String {
                        var time: String!
                        let dateFormat: DateFormatter = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        if let gmt: TimeZone = TimeZone(abbreviation: "GMT") {
                            dateFormat.timeZone = gmt
                            if let expDate = dateFormat.date(from: postDate.debugDescription) {

                            let unitFlags = Set<Calendar.Component>([.day, .weekday, .month, .year, .hour, .minute, .second])
                            let components: DateComponents = Calendar.current.dateComponents(unitFlags, from: expDate, to: Date())

                                if components.year != 0 {
                                    if components.year == 1 {
                                        time = "1 year".localized
                                    } else {
                                        time = String(format: "%ld years".localized, components.year ?? 0)
                                    }
                                } else if components.month != 0 {
                                    if components.month == 1 {
                                        time = "1 month".localized
                                    } else {
                                        time = String(format: "%ld months".localized, components.month ?? 0)
                                    }
                                } else if components.weekday != 0 {
                                    if components.weekday == 1 {
                                        time = "1 week".localized
                                    } else {
                                        time = String(format: "%ld weeks".localized, components.weekday ?? 0)
                                    }
                                } else if components.day != 0 {
                                    if components.day == 1 {
                                        time = "1 day".localized
                                    } else {
                                        time = String(format: "%ld days".localized, components.day ?? 0)
                                    }
                                } else if components.hour != 0 {
                                    if components.hour == 1 {
                                        time = "1 hour".localized
                                    } else {
                                        time = String(format: "%ld hours".localized, components.hour ?? 0)
                                    }
                                } else if components.minute != 0 {
                                    if components.minute == 1 {
                                        time = "1 min".localized
                                    } else {
                                        time = String(format: "%ld mins".localized, components.minute ?? 0)
                                    }
                                } else if components.second ?? 0 >= 0 {
                                    if components.second ?? 0 == 0 {
                                        time = "1 sec".localized
                                    } else {
                                        time = String(format: "%ld secs".localized, components.second ?? 0)
                                    }
                                }


                            }

                        }
                        return String(format: "%@ ago".localized, time)
                    }
                    
                    static func AGE(birthday: Date) -> Int {
                        let now = Date()
                        let calendar = Calendar.current
                        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
                        return ageComponents.year!
                    }
                    
                }
                
            }
            
            static func RANDOM_KEY(length: Int) -> String {
                return String((0..<length).map{ _ in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789^&$*#_-+!@".randomElement()! })
            }
            
        }
        
    }
    
    struct DEVICE {
        
        enum TYPE: Int {
            case IPHONE = 0
            case IPAD
            case RETINA
            case IPHONE_4
            case IPHONE_5
            case IPHONE_6
            case IPHONE_6_PLUS
            case IPHONE_7
            case IPHONE_7_PLUS
            case IPHONE_8
            case IPHONE_8_PLUS
            case IPHONE_X
        }
        
        static let NAME: String = UIDevice.current.name
        static let VERSION: String = UIDevice.current.systemVersion
        struct LANGUAGE {
            static let CODE: String = Locale.current.languageCode ?? "en"
        }
        static let MODEL: String = {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            func mapToDevice(identifier: String) -> String {
                #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return "iPod touch (5th generation)"
                case "iPod7,1":                                 return "iPod touch (6th generation)"
                case "iPod9,1":                                 return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
                case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
                case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
                }
                #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
                #endif
            }

            return mapToDevice(identifier: identifier)
        }()
        
        static func IS(device: TYPE) -> Bool {
            switch device {
                
            case TYPE.IPHONE:
                return (UIDevice().userInterfaceIdiom == .phone)
                
            case TYPE.IPAD:
                return (UIDevice().userInterfaceIdiom == .pad)
                
            case TYPE.RETINA:
                return (UIScreen.main.scale == 2.0)
                
            case TYPE.IPHONE_4:
                return (SCREEN.MAX_SIZE == 480.0)
                
            case TYPE.IPHONE_5:
                return (SCREEN.MAX_SIZE == 568.0)
                
            case TYPE.IPHONE_6, TYPE.IPHONE_7, TYPE.IPHONE_8:
                return (SCREEN.MAX_SIZE == 667.0)
                
            case TYPE.IPHONE_6_PLUS, TYPE.IPHONE_7_PLUS, TYPE.IPHONE_8_PLUS:
                return (SCREEN.MAX_SIZE == 736.0)
                
            case TYPE.IPHONE_X:
                return (SCREEN.MAX_SIZE == 812.0)
                
            }
        }
        
    }
    
    struct SCREEN {
        
        static let ENABLE_AUTO_ROTATE: Bool = false
        static let MAX_SIZE: CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        static let MIN_SIZE: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        
        static func WIDTH() -> CGFloat {
            return UIScreen.main.bounds.width
        }
        static func HEIGHT() -> CGFloat {
            return UIScreen.main.bounds.height
        }
        
        static func MARGIN(_ times: Float = 0) -> CGFloat {
            return 10.0 * CGFloat(times > 0 ? times : 1)
        }

        static let LEFT_DIRECTION: Bool = {
            return "DIRECTION".localized != "rtl"
        }()
        
        struct SAFE_AREA {
            
            static func TOP() -> CGFloat {
                if #available(iOS 12.0, *) {
                    let window = UIApplication.shared.windows[0]
                    let insets: UIEdgeInsets = window.safeAreaInsets
                    return insets.top
                }
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.windows[0]
                    let insets: UIEdgeInsets = window.safeAreaInsets
                    return max(STATUSBAR.HEIGHT, insets.top)
                }
                return STATUSBAR.HEIGHT
            }
            
            static func BOTTOM() -> CGFloat {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.windows[0]
                    let insets: UIEdgeInsets = window.safeAreaInsets
                    return insets.bottom
                }
                return 0
            }
            
            static func LEFT() -> CGFloat {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.windows[0]
                    let insets: UIEdgeInsets = window.safeAreaInsets
                    return insets.left
                }
                return 0
            }
            
            static func RIGHT() -> CGFloat {
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.windows[0]
                    let insets: UIEdgeInsets = window.safeAreaInsets
                    return insets.right
                }
                return 0
            }
            
        }
        
    }
    
    struct STATUSBAR {
        
        static let HEIGHT: CGFloat = 20.0
        
        struct DEFAULT {
            
            static let HIDDEN: Bool = false
            struct STYLE {
                static let ANY: UIStatusBarStyle = UIStatusBarStyle.default
                static let DARK: UIStatusBarStyle = UIStatusBarStyle.lightContent
            }
            static let ANIMATION: UIStatusBarAnimation = UIStatusBarAnimation.none
            
        }
        
    }
    
    struct KEYS {
        
        struct USERDEFAULTS {
            
            struct USER {
                static let LOGIN: String = "isLogin"
            }
            
        }

        struct SQL {
            
            struct ENTITY {
                static let USER: String = "User"
            }
            static let FIELDS: String = "fields"
            static let NAME_ENTITY: String = "nameEntity"
            static let FROM: String = "from"
            static let WHERE: String = "where"
            struct ORDER_BY {
                static let SELF: String = "order by"
                static let KEYWORD: String = "keyword"
                static let SORT: String = "sort"
                static let ASC: String = "asc"
                static let DESC: String = "desc"
            }
            
        }
        
        struct ELEMENTS {
            static let SELF: String = "element"
            static let TAG: String = "tag"
            static let DELEGATE: String = "delegate"
            struct COLOR {
                static let BACKGROUND: String = "background"
                static let TEXT: String = "textColor"
                static let LINK: String = "linkColor"
            }
            struct CORNER {
                static let RADIUS: String = "cornerRadius"
            }
            static let FONT: String = "font"
            static let TEXT: String = "text"
            static let ALIGNMENT: String = "alignment"
            static let ALPHA: String = "alpha"
            static let NUMLINES: String = "numberOfLines"
            static let IMAGE: String = "image"
            static let HIDDEN: String = "hidden"
            static let CLIPS: String = "clips"
            struct ALLOW {
                static let ENABLE: String = "enable"
                static let UPDATE: String = "update"
            }
            struct BUTTON {
                static let SELF: String = "button"
                static let SELECTOR: String = "selector"
                static let TARGET: String = "target"
                static let EVENT: String = "event"
            }
            struct KEYBOARD {
                static let APPEARANCE: String = "appearance"
                static let TYPE: String = "type"
                static let RETURNKEY: String = "returnKey"
            }
            struct TEXTFIELD {
                struct MARGIN {
                    static let LEFT: String = "left"
                    static let RIGHT: String = "right"
                }
            }
            struct LEVELS {
                static let RECEIVER: String = "receiver"
                static let REPORTER: String = "reporter"
            }
        }
        
        struct JSON {

            struct COLLECTION {
                static let USERS: String = "Users"
            }
            
            struct FIELD {
                
                struct ID {
                    static let SELF: String = "ID"
                    static let USER: String = "userID"
                    static let VERIFICATION: String = "verificationID"
                }
                
                struct PHONE {
                    static let SELF: String = "phone"
                    static let NUMBER: String = "number"
                    static let CODE: String = "code"
                }
                
                struct COUNTRY {
                    static let SELF: String = "country"
                    static let CODE: String = "code"
                    static let NAME: String = "name"
                }
                
                struct DATE {
                    static let SELF: String = "date"
                    static let REGISTER: String = "register"
                    static let LOGIN: String = "login"
                    static let UPDATE: String = "update"
                }
                
                struct INFO {
                    static let SELF: String = "info"
                    struct APP {
                        static let SELF: String = "app"
                        static let VERSION: String = "version"
                    }
                    struct DEVICE {
                        static let SELF: String = "device"
                        static let TYPE: String = "type"
                        static let OPERATING_SYSTEM: String = "operatingSystem"
                    }
                }
                
                static let NAME: String = "fullName"
                static let LEVEL: String = "level"
                static let RANDOM_KEY: String = "randomKey"
                static let THUMB: String = "thumb"
                
            }
            
        }
        
    }

}
