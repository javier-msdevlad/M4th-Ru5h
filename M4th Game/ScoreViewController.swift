//
//  ScoreViewController.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 10/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import UIKit
import CoreData

class ScoreViewController: ViewControllerIdentityViewController, UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var correctAnswersLabel: UILabel!
    
    @IBOutlet weak var resultTable: UITableView!
    
    var bestScore:[NSManagedObject] = []
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var managedContext:NSManagedObjectContext!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate!.persistentContainer.viewContext
        self.viewIdentifier = "scoreView"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
        resultTable.dataSource = self
        resultTable.delegate = self
        resultTable.tableFooterView = UIView()
        scoreLabel.text = "Final Score: \(ExpressionList.sharedInstance.finalScore)"
        correctAnswersLabel.text = "Correct answers: \(ExpressionList.sharedInstance.correctTotal) of \(ExpressionList.sharedInstance.list.count)"
        SaveScore()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = ExpressionList.sharedInstance.list.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "resultCell") as! CustomCell
        cell.textLabel?.text = ExpressionList.sharedInstance.list[indexPath.row].operation
        cell.showCorrectOrIncorrect(wasCorrect: ExpressionList.sharedInstance.list[indexPath.row].wasAnsweredCorrectly)
        return cell
    }
    
    private func CheckIfHigher() {
        
    }
    
    private func SaveScore() {
        
        let entity = NSEntityDescription.entity(forEntityName: "Score", in: managedContext)
        let entity2 = NSEntityDescription.entity(forEntityName: "Totals", in: managedContext)
        
        let score = Score(entity: entity!, insertInto: managedContext)
        let total = Totals(entity: entity2!, insertInto: managedContext)
        
        //total.corrects += Int64(ExpressionList.sharedInstance.correctTotal)
        //total.mistakes += Int64(ExpressionList.sharedInstance.list.count - ExpressionList.sharedInstance.correctTotal)
        
        print(Int64(ExpressionList.sharedInstance.correctTotal))
        print(Int64(ExpressionList.sharedInstance.list.count - ExpressionList.sharedInstance.correctTotal))
        
        score.answers = Int16(ExpressionList.sharedInstance.list.count)
        score.checks = Int16(ExpressionList.sharedInstance.correctTotal)
        score.score = Int16(ExpressionList.sharedInstance.finalScore)
        score.dificulty = "Easy"
        score.date = Date() as NSDate
        
        let request: NSFetchRequest<Score> = Score.fetchRequest()

        request.predicate = NSPredicate(value: true)
        
        let cantidad = try! managedContext.count(for: request)
        
        if cantidad < 6 {

                try! managedContext.save()
        }
        else {
            do {
                let scores = try! managedContext.fetch(request).sorted(by: {$0.score < $1.score})
                for bestScore in scores {
                    if score.score > bestScore.score {
                        managedContext.delete(bestScore)
                        break
                    }
                    else{
                        managedContext.delete(score)
                    }
                }
                
                try! managedContext.save()
                
            } catch  {
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func playAgainButton(_ sender: Any) {
        ExpressionList.sharedInstance.list.removeAll()
    }
    
    @IBAction func menuButton(_ sender: Any) {
        ExpressionList.sharedInstance.list.removeAll()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "LeftToRight":
            if let dest = segue.destination as? ViewController {
                dest.viewIdentifier = "mainMenu"
            }
            break
            
        case "RightToLeft":
            if let dest = segue.destination as? PlayViewController {
                dest.viewIdentifier = "playView"
            }
            break
            
        default:
            break
        }
        
    }
}
