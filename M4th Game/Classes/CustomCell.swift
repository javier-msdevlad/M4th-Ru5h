//
//  CustomCell.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 29/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var correctLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.font = UIFont(name: "Chalkduster", size: 20)
        correctLabel.textColor = UIColor.white
        correctLabel.textAlignment = .center
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showCorrectOrIncorrect(wasCorrect: Bool)
    {
        if wasCorrect{
            correctLabel.text = "✓"
            correctLabel.textColor = UIColor.green
        }
        else{
            correctLabel.text = "✕"
            correctLabel.textColor = UIColor.red
        }
    }
}
