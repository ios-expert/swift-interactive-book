//
//  AppData.swift
//  True Story
//
//  Created by Maxim on 13/10/2019.
//  Copyright © 2019 big-lab.com. All rights reserved.
//

import UIKit

extension String {
    func localized() -> String {
        if let _ = UserDefaults.standard.string(forKey: "AppLanguage") {} else {
            let langCode = Locale.current.languageCode
            UserDefaults.standard.set(langCode, forKey: "AppLanguage")
        }
        let lang = UserDefaults.standard.string(forKey: "AppLanguage")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

class AppData: NSObject {
    
    // Properties
    private static var sharedManager: AppData = {
        let appData = AppData()
        return appData
    }()

    // Functions
    func dbUrl() -> String {
        return "DatabaseUrl".localized()
    }
    
    // Initialization
    private override init() {
        
    }
    
    // Accessors
    class func shared() -> AppData {
        return sharedManager
    }
}
