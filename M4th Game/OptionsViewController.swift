//
//  OptionsViewController.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 10/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import UIKit

class OptionsViewController: ViewControllerIdentityViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var difficultySegment: UISegmentedControl!
    
    @IBOutlet weak var themeSegment: UISegmentedControl!
    
    @IBOutlet weak var soundSwitch: UISwitch!
    
    @IBOutlet weak var tittleLabel: UILabel!
    
    @IBOutlet weak var dificultyLabel: UILabel!
    
    @IBOutlet weak var themeLabel: UILabel!
    
    @IBOutlet weak var soundLabel: UILabel!
    
    @IBOutlet weak var backButton: RoundButton!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
        difficultySegment.selectedSegmentIndex = UserDefaults.standard.difficulty()
        
        switch  UserDefaults.standard.themeColor()?.description {
        case UIColor.white.description:
            themeSegment.selectedSegmentIndex = 0

        case UIColor(red:1.00, green:0.98, blue:0.43, alpha:1.0).description:
            themeSegment.selectedSegmentIndex = 1

        case UIColor(red:1, green:0.5, blue:0.83, alpha:1).description:
            themeSegment.selectedSegmentIndex = 2

        default:
            themeSegment.selectedSegmentIndex = 0

        }
        
        reColorUI()
        soundSwitch.isOn = UserDefaults.standard.isSoundAllowed()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeDifficulty(_ sender: UISegmentedControl) {
        
        UserDefaults.standard.changeDifficulty(value: sender.selectedSegmentIndex)
        
    }
    
    
    @IBAction func changeTheme(_ sender: UISegmentedControl) {
        
        var color:UIColor
        
        switch sender.selectedSegmentIndex {
        case 0:
            color = UIColor.white
            
        case 1:
            color = UIColor(red:1.00, green:0.98, blue:0.43, alpha:1.0)
            
        case 2:
            color = UIColor(red:1.00, green:0.50, blue:0.83, alpha:1.0)
            
        default:
            color = UIColor.white
        }
        
        UserDefaults.standard.setColor(color: color)
        reColorUI()
    }
    
    
    @IBAction func changeLanguage(_ sender: UISegmentedControl) {
    }
    
    @IBAction func toggleSounds(_ sender: UISwitch) {
        
        UserDefaults.standard.toggleSound(value: sender.isOn)

    }
    
    func reColorUI() {
        
        difficultySegment.tintColor = UserDefaults.standard.themeColor()
        themeSegment.tintColor = UserDefaults.standard.themeColor()
        soundSwitch.tintColor = UserDefaults.standard.themeColor()
        tittleLabel.textColor = UserDefaults.standard.themeColor()
        dificultyLabel.textColor = UserDefaults.standard.themeColor()
        themeLabel.textColor = UserDefaults.standard.themeColor()
        soundLabel.textColor = UserDefaults.standard.themeColor()
        backButton.borderColor = UserDefaults.standard.themeColor()!
        languageLabel.textColor = UserDefaults.standard.themeColor()
        languageSegment.tintColor = UserDefaults.standard.themeColor()
        backButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "DownToUpSegue1", sender: self)
    }
    
}
