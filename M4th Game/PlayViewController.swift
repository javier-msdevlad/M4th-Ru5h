//
//  PlayViewController.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 10/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio
import OpenAL

class PlayViewController: ViewControllerIdentityViewController, AVAudioPlayerDelegate {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //Stacks
    
    @IBOutlet weak var mainStack: UIStackView!
    
    @IBOutlet weak var topElementsStack: UIStackView!
    
    //Stacks
    
    //UI IBOutlets
    
    @IBOutlet var symbolInputCollection: [RoundButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    @IBOutlet weak var operationLabel: UILabel!
    
    @IBOutlet weak var checkedLabel: UILabel!
    
    @IBOutlet weak var checkLabelPosition: NSLayoutConstraint!
    
    @IBOutlet weak var ceroButton: RoundButton!
    
    @IBOutlet weak var eraseButton: RoundButton!
    
    @IBOutlet weak var minusButton: RoundButton!
    
    @IBOutlet weak var enterButton: RoundButton!
    
    @IBOutlet weak var oneButton: RoundButton!
    
    @IBOutlet weak var twoButton: RoundButton!
    
    @IBOutlet weak var threeButton: RoundButton!
    
    @IBOutlet weak var fourButton: RoundButton!
    
    @IBOutlet weak var fiveButton: RoundButton!
    
    @IBOutlet weak var sixButton: RoundButton!
   
    @IBOutlet weak var sevenButton: RoundButton!
    
    @IBOutlet weak var eightButton: RoundButton!
    
    @IBOutlet weak var nineButton: RoundButton!
    
    //UI IBOutlets
    
    
    var playTime = 20
    
    var startTime = 3
    
    var timePenalty = 0
    
    var startTimer = Timer()
    var playTimer  = Timer()
    
    var currentScore:Int = 0
    var currentAnswer:String = ""
    var canPushAside: Bool = false
    
    var expression:Expression = Expression()
    
    var chalkPlayer: AVAudioPlayer?
    var wrongPlayer: AVAudioPlayer?
    var rightPlayer: AVAudioPlayer?
    
    let writtingSound = Bundle.main.url(forResource: "chalk1", withExtension: "wav")!
    let wrongSound = Bundle.main.url(forResource: "wrong", withExtension: "aif")!
    let rightSound = Bundle.main.url(forResource: "correct", withExtension: "aif")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewIdentifier = "playView"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
        reColorUI()
        audioSetUp()
        //checkLabelPosition.constant -= view.bounds.width
        timeLeftLabel.text = ""
        startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayViewController.startCount), userInfo: nil, repeats: true)
        
        for button in symbolInputCollection {
            button.isEnabled = false
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func CountDown() {
        
        if playTime == 0
        {
            performSegue(withIdentifier: "GameOver", sender: nil)
            playTimer.invalidate()
            return
        }
        
        playTime -= 1
        timePenalty += 1
        timeLeftLabel.text = String(playTime)
        
    }
    
    @objc func startCount(){
        
        if startTime == 0 {
            timeLeftLabel.text = NSLocalizedString("StartGame", comment: "Game started")
            startTimer.invalidate()
            playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayViewController.CountDown), userInfo: nil, repeats: true)
            _ = createExpression()
            
            for button in symbolInputCollection {
                button.isEnabled = true
            }
        }
        else{
            timeLeftLabel.text = String(startTime)
            startTime -= 1
        }
        
    }

    func createExpression() -> Expression{
        expression = Expression()
        operationLabel.text = expression.operation
        return expression
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func eraseButton(_ sender: UIButton) {
        operationLabel.text = expression.operation;
        currentAnswer = ""
        EnableOrDisableButton(tag: -1, changeToState: true)
    }
    
    @IBAction func enterResultButton(_ sender: UIButton) {
        
        canPushAside = true
        
        guard let validAnswer = Int(currentAnswer) else {
            
            DispatchQueue.global().async {
                do {
                    
                    self.wrongPlayer = try AVAudioPlayer(contentsOf: self.wrongSound)
                    self.wrongPlayer!.play()
                    
                } catch  {
                    print(error)
                }
            }
            
            EnableOrDisableButton(tag: 11, changeToState: false)
            
            let bounds = operationLabel.bounds
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:  0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                self.operationLabel.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
            }) { (success:Bool) in
                if success {
                    self.operationLabel.bounds = bounds
                    self.EnableOrDisableButton(tag: 11, changeToState: true)
                }
            }
            
            return
        }
        
        if expression.checkIfCorrect(answer: validAnswer)
        {
            rightPlayer!.play()
            if (timePenalty >= 5)
            {
                expression.SetScore(penalty: timePenalty)
            }
            else
            {
                expression.SetScore(penalty: 0)
            }
            
            currentScore += expression.score
            scoreLabel.text = NSLocalizedString("CurrentScore", comment: "") + ": \(currentScore)"
            expression.wasAnsweredCorrectly = true;
            
            checkedLabel.text = "✓"
            checkedLabel.textColor = UIColor.green
            
        }
        else {
            DispatchQueue.global().async {
                do {
                    
                    self.wrongPlayer = try AVAudioPlayer(contentsOf: self.wrongSound)
                    self.wrongPlayer!.play()
                    
                } catch  {
                    print(error)
                }
            }
            checkedLabel.text = "✕"
            checkedLabel.textColor = UIColor.red
        }

        ExpressionList.sharedInstance.list.append(expression)
        timePenalty = 0
        currentAnswer = ""
        _ = createExpression()
        EnableOrDisableButton(tag: -1, changeToState: true)
    
    }
    
    @IBAction func enterSymbol(_ sender: UIButton) {
        
        DispatchQueue.global().async {
            do {
                
                self.chalkPlayer = try AVAudioPlayer(contentsOf: self.writtingSound)
                self.chalkPlayer!.play()
                
            } catch  {
                print(error)
            }
        }
        
        if(sender.tag != -1) {
            EnableOrDisableButton(tag: -1, changeToState: false)
        }
        
       currentAnswer = "\(currentAnswer)\(sender.titleLabel!.text!)"
       operationLabel.text = "\(expression.operation)\(currentAnswer)"
    }
    
    func EnableOrDisableButton(tag:Int, changeToState:Bool)
    {
        let buttonToChange = self.symbolInputCollection.first(where: {$0.tag == tag})
        
        if changeToState {
            
            buttonToChange?.isEnabled = true;
            buttonToChange?.titleLabel?.textColor = UserDefaults.standard.themeColor()
            buttonToChange?.borderColor = UserDefaults.standard.themeColor()!
            
        }
        else {
            
            buttonToChange?.isEnabled = false;
            buttonToChange?.setTitleColor(UIColor.gray, for: .disabled)
            buttonToChange?.borderColor = UIColor.gray
            
        }
        
    }
    
    func audioSetUp() {
        
        
        do {
            
            wrongPlayer = try AVAudioPlayer(contentsOf: wrongSound)
            wrongPlayer?.prepareToPlay()
            
            chalkPlayer = try AVAudioPlayer(contentsOf: writtingSound)
            chalkPlayer?.prepareToPlay()
            
            rightPlayer = try AVAudioPlayer(contentsOf: rightSound)
            rightPlayer?.prepareToPlay()
            
        } catch  {
            
            print("Error de audio")
            
        }
        
        wrongPlayer?.delegate = self
        chalkPlayer?.delegate = self
        rightPlayer?.delegate = self
        
    }
    
    func reColorUI() {
        
        scoreLabel.textColor = UserDefaults.standard.themeColor()
        timeLeftLabel.textColor = UserDefaults.standard.themeColor()
        operationLabel.textColor = UserDefaults.standard.themeColor()
        
        ceroButton.borderColor = UserDefaults.standard.themeColor()!
        ceroButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        oneButton.borderColor = UserDefaults.standard.themeColor()!
        oneButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        twoButton.borderColor = UserDefaults.standard.themeColor()!
        twoButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        threeButton.borderColor = UserDefaults.standard.themeColor()!
        threeButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        fourButton.borderColor = UserDefaults.standard.themeColor()!
        fourButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        fiveButton.borderColor = UserDefaults.standard.themeColor()!
        fiveButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        sixButton.borderColor = UserDefaults.standard.themeColor()!
        sixButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        sevenButton.borderColor = UserDefaults.standard.themeColor()!
        sevenButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        eightButton.borderColor = UserDefaults.standard.themeColor()!
        eightButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        nineButton.borderColor = UserDefaults.standard.themeColor()!
        nineButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        eraseButton.borderColor = UserDefaults.standard.themeColor()!
        eraseButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        minusButton.borderColor = UserDefaults.standard.themeColor()!
        minusButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
        
        enterButton.borderColor = UserDefaults.standard.themeColor()!
        enterButton.setTitleColor(UserDefaults.standard.themeColor(), for: .normal)
    }
    
   /* var engine = AVAudioEngine()
    var playerNode = AVAudioPlayerNode()
    var mixerNode: AVAudioMixerNode?
    var audioFile: AVAudioFile?
    
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        engine.attach(playerNode)
        mixerNode = engine.mainMixerNode
        
        engine.connect(playerNode, to: mixerNode!, format: mixerNode!.outputFormat(forBus: 0))
        
        do {
            try engine.start()
        }
            
        catch let error {
            print("Error starting engine: \(error.localizedDescription)")
        }
        
        let url = Bundle.main.url(forResource: "click_04", withExtension: ".wav")
        
        do {
            try audioFile = AVAudioFile(forReading: url!)
        }
            
        catch let error {
            print("Error opening audio file: \(error.localizedDescription)")
        }
    }
    
    @IBAction func playSound(_ sender: Any) {
        
        engine.connect(playerNode, to: engine.mainMixerNode, format: audioFile?.processingFormat)
        playerNode.scheduleFile(audioFile!, at: nil, completionHandler: nil)
        
        if engine.isRunning{
            playerNode.play()
        } else {
            print ("engine not running")
        }
    }*/
}
