//
//  LanguageManager.swift
//  Gratshare
//
//  Created by MAC on 12/07/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class LanguageManager: NSObject {
    
    //MARK: - Variables
    var bundle: Bundle?
    static let shared = LanguageManager()
    
    override init() {
        
        super.init()
        self.bundle = Bundle.main
    }
    
    
    //MARK: - Set/Get Selected Language Code in User Defaults
    
    func saveSelectedLanguage(languageCode : String) {
        
        UserDefaults.selectedLanguageCode = languageCode
        UserDefaults.standard.set(languageCode, forKey: UserDefaultsKey.kSelectedLanguageCode)
        setLanguageDirectoryPath()
    }
    
    func setLanguageDirectoryPath() {
        
        var langCode : String = LanguageSelection.English.languageCode
        if getSelectedLanguage() == LanguageSelection.English.languageCode{
            langCode = LanguageSelection.English.languageCode
        } else if getSelectedLanguage() == LanguageSelection.Spanish.languageCode{
            langCode = LanguageSelection.Spanish.languageCode
        } else if getSelectedLanguage() == LanguageSelection.Chinese.languageCode{
            langCode = LanguageSelection.Chinese.languageCode
        } else if getSelectedLanguage() == LanguageSelection.Russian.languageCode{
            langCode = LanguageSelection.Russian.languageCode
        }
        
        if let languageDirectoryPath = Bundle.main.path(forResource: langCode, ofType: "lproj")  {
            bundle = Bundle.init(path: languageDirectoryPath)
        } else {
            resetLocalization()
        }
    }
    
    
    func getSelectedLanguage() -> String {
        
        guard let languageCode = UserDefaults.standard.value(forKey: UserDefaultsKey.kSelectedLanguageCode) as? String else {
            return LanguageSelection.English.languageCode
        }
        return languageCode
    }
    
    func getSelectedLanguageAPIValue() -> String {
        
        var langCode : String = LanguageSelection.English.apiLanguageCode
        if getSelectedLanguage() == LanguageSelection.English.languageCode{
            langCode = LanguageSelection.English.apiLanguageCode
        } else if getSelectedLanguage() == LanguageSelection.Spanish.languageCode{
            langCode = LanguageSelection.Spanish.apiLanguageCode
        } else if getSelectedLanguage() == LanguageSelection.Chinese.languageCode{
            langCode = LanguageSelection.Chinese.apiLanguageCode
        } else if getSelectedLanguage() == LanguageSelection.Russian.languageCode{
            langCode = LanguageSelection.Russian.apiLanguageCode
        }
        return langCode
    }
    
    //MARK:- resetLocalization
    //Resets the localization system, so it uses the OS default language.
    func resetLocalization() {
        bundle = Bundle.main
    }
    
}
