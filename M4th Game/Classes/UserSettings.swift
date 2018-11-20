//
//  UserSettings.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 11/09/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    
    func setDefaults() {
        UserDefaults.standard.set(1, forKey: "Difficulty")
        UserDefaults.standard.set(true, forKey: "AllowSound")
        setColor(color: UIColor.white)
        UserDefaults.standard.set(true, forKey: "DefaultsSet")
    }
    
    func areDefaultsSet() -> Bool {
        return UserDefaults.standard.object(forKey: "DefaultsSet") != nil
    }
    
    func changeDifficulty(value:Int) {
        
        UserDefaults.standard.set(value, forKey: "Difficulty")
        UserDefaults.standard.synchronize()
    }
    
    func difficulty() -> Int{
        return integer(forKey: "Difficulty")
    }
    
    func themeColor() -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: "Theme") {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        
        set(colorData, forKey: "Theme")
        synchronize()
    }
    
    func toggleSound(value:Bool) {
        
        UserDefaults.standard.set(value, forKey: "AllowSound")
        UserDefaults.standard.synchronize()
    }
    
    func isSoundAllowed() -> Bool{
        return bool(forKey: "AllowSound")
    }
}
