//
//  ViewController.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 07/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import UIKit

class ViewController: ViewControllerIdentityViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var tittleLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var aboutButton: RoundButton!
    
    @IBOutlet weak var optionsButton: RoundButton!
    
    @IBOutlet weak var scoresButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.areDefaultsSet() {
            UserDefaults.standard.setDefaults()
        }
        
        self.viewIdentifier = "mainMenu"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
        playButton.layer.cornerRadius = playButton.layer.frame.size.width / 2
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
       
    }

    @IBAction func playButton(_ sender: Any) {
        
    }
    
    @IBAction func optionsButton(_ sender: Any) {

    }
    
    @IBAction func scoreButton(_ sender: Any) {
        
    }
    
    @IBAction func aboutButton(_ sender: Any) {
        
    }

    
    override func viewDidLayoutSubviews() {
    
        playButton.layer.cornerRadius = playButton.layer.frame.size.width / 2
        playButton.titleLabel?.adjustsFontSizeToFitWidth = true
        playButton.titleLabel?.font = UIFont(name: (playButton.titleLabel?.font.fontName)!, size: 120)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "UpToDownSegue1":
            if let dest = segue.destination as? OptionsViewController {
                dest.viewIdentifier = "optionsMenu"
            }
            break
            
        case "UpToDownSegue2":
            if let dest = segue.destination as? AboutViewController {
                dest.viewIdentifier = "aboutMenu"
            }
            break
            
        case "UpToDownSegue3":
            if let dest = segue.destination as? BestScoresViewController {
                dest.viewIdentifier = "scoresMenu"
            }
            break
            
        default:
            break
        }
        
        if segue.identifier == "UpToDownSegue1" {
            if let dest = segue.destination as? OptionsViewController {
                dest.viewIdentifier = "optionsMenu"
            }
        }
    }
    
}

