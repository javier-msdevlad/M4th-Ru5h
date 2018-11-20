//
//  BestScoresViewController.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 10/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import UIKit
import CoreData
import Charts

class BestScoresViewController: ViewControllerIdentityViewController, UITableViewDelegate, UITableViewDataSource {
  
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var mistakeChart: PieChartView!
    
    @IBOutlet weak var bestScoresTable: UITableView!
    
    var bestScores:[Score] = []
    
    var managedContext: NSManagedObjectContext!
    
    let dateFormatter:DateFormatter = DateFormatter()

    var mistakesEntry = PieChartDataEntry(value: 0)
    var correctsEntry = PieChartDataEntry(value: 0)
    var numberOfEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mistakeChart.chartDescription?.textColor = UIColor.white
        mistakeChart.chartDescription?.font = UIFont(name: "Chalkduster", size: 12)!
        mistakeChart.chartDescription?.text = "Global mistake chart"
        mistakeChart.entryLabelFont = UIFont(name: "Chalkduster", size: 12)!
        mistakeChart.entryLabelColor = UIColor.white
        
        mistakesEntry.value = 5
        mistakesEntry.label = "Mistakes"
        
        correctsEntry.value = 5
        correctsEntry.label = "Correct answers"
        
        numberOfEntries = [mistakesEntry, correctsEntry]
        
        updatePieChart()
        
        //managedObject.value(forkey: ) as?
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blackBoard")!)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate!.persistentContainer.viewContext
        
        bestScoresTable.delegate = self
        bestScoresTable.dataSource = self
        bestScoresTable.tableFooterView = UIView()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let request: NSFetchRequest<Score> = Score.fetchRequest()
        do {
            let scores = try! managedContext.fetch(request).sorted(by: {$0.score > $1.score})
            self.bestScores = scores
        } catch  {
            
        }
        
        if(bestScores.count == 0)
        {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
  self.performSegue(withIdentifier: "DownToUpSegue3", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bestScoresTable.dequeueReusableCell(withIdentifier: "bestScoreCell")
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.font = UIFont(name: "Chalkduster", size: 20)
        cell?.textLabel?.textColor = UIColor.white
        let info:String = "score: \(bestScores[indexPath.row].score) | \(bestScores[indexPath.row].checks) of \(bestScores[indexPath.row].answers) | \(dateFormatter.string(from: bestScores[indexPath.row].date! as Date))"
        cell?.textLabel?.text = info
        return cell!
    }
    
    func updatePieChart() {
        
        let dataset = PieChartDataSet(values:  numberOfEntries, label: nil)
        let chartData = PieChartData(dataSet: dataset)
        let colors = [UIColor(red:1.00, green:0.0, blue:0.0, alpha:0.2), UIColor(red:0.0, green:1.00, blue:0.0, alpha:0.2)]
        dataset.colors = colors
        
        mistakeChart.data = chartData
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
