//
//  Expression.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 07/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import Foundation
import GameplayKit


class Expression {
    
    let difficulty:Int
    var term1:Int = 0
    var term2:Int = 0
    var term3:Int?
    var term4:Int?
    
    var result:Int = 0
    var operator1:Character?
    var operator2:Character?
    var operator3:Character?
    
    var operation:String = ""
    var calification:String = ""
    var wasAnsweredCorrectly:Bool
    //let num
    let op:GKRandomSource
    var score:Int = 0
    
    public enum difficultyMode:Int {
        case easy   = 0
        case normal = 1
        case hard   = 2
        case easyOrNormal = 3
    }
    
    init() {
        
        switch UserDefaults.standard.difficulty() {
        case 0:
            self.difficulty = difficultyMode.easy.rawValue
        case 1:
            self.difficulty = difficultyMode.normal.rawValue
        case 2:
            self.difficulty = difficultyMode.hard.rawValue
        default:
            print("Incorrect difficulty input, setting to default...")
            self.difficulty = difficultyMode.easy.rawValue
        }
        
        self.wasAnsweredCorrectly = false
        self.op = GKRandomSource.sharedRandom()
        GenerateExpression(difficulty: self.difficulty)
        ResolveOperation(difficulty: self.difficulty)
        
    }
    
    private func GenerateExpression(difficulty: Int) {
        
        switch difficulty {
            
        case difficultyMode.easy.rawValue:
            
            term1 = GiveValue(difficulty: difficulty)
            term2 = GiveValue(difficulty: difficulty)
            operator1 = GenerateRandomOperator(r: op.nextInt(upperBound: 2))
            operation = "\(term1) \(operator1!) \(term2) = "
        
        case difficultyMode.normal.rawValue:
            
            term1 = GiveValue(difficulty: difficulty)
            term2 = GiveValue(difficulty: difficulty)
            operator1 = String(term1).count == 1 ? GenerateRandomOperator(r: op.nextInt(upperBound: 3)) : GenerateRandomOperator(r: op.nextInt(upperBound: 2))
            operation = "\(term1) \(operator1!) \(term2) = "
            
        case difficultyMode.hard.rawValue:
            
            term1 = GiveValue(difficulty: 1)
            term2 = GiveValue(difficulty: difficulty)
            term3 = GiveValue(difficulty: difficulty)
            operator1 = String(term1).count == 1 ? GenerateRandomOperator(r: op.nextInt(upperBound: 3)) : GenerateRandomOperator(r: op.nextInt(upperBound: 2))
            operator2 = String(term2).count == 1 ? GenerateRandomOperator(r: op.nextInt(upperBound: 3)) : GenerateRandomOperator(r: op.nextInt(upperBound: 2))
            operation = "\(term1) \(operator1!) \(term2) \(operator2!) \(term3!) = "
       
        default:
            break
        }
    }
    
    private func GenerateRandomOperator(r: Int) -> Character {
        
        var operator0:Character?
        
        switch r {
        case 0:
            operator0 = "+"
        case 1:
            operator0 = "-"
        case 2:
            operator0 = "*"
        default:
            break
        }
        
        return operator0!
    }
    
    public func SetScore(penalty: Int) {
        
        var score:Int = 0
        
        let timePenalty = (penalty - 5) + 1
        
        switch self.difficulty {
        case difficultyMode.easy.rawValue:
            score = 10 - timePenalty
        case difficultyMode.normal.rawValue:
            score = 20 - timePenalty
        case difficultyMode.hard.rawValue:
            score = 30 - timePenalty
        default: break
        
        }
        
        self.score = score
    }
    
    private func ResolveOperation(difficulty: Int) {
        
        var res:Int?
        
        switch difficulty {
        
        case difficultyMode.hard.rawValue:
            switch self.operator1 {
            case "+":
                switch self.operator2 {
                case "+":
                    res = term1 + term2 + term3!
                case "-":
                    res = term1 + term2 - term3!
                case "*":
                    res = term1 + term2 * term3!
                default:
                    break
                }
                
            case "-":
                switch self.operator2 {
                case "+":
                    res = term1 - term2 + term3!
                case "-":
                    res = term1 - term2 - term3!
                case "*":
                    res = term1 - term2 * term3!
                default:
                    break
                }
                
            case "*":
                switch self.operator2 {
                case "+":
                    res = term1 * term2 + term3!
                case "-":
                    res = term1 * term2 - term3!
                case "*":
                    res = term1 * term2 * term3!
                default:
                    break
                }
                
            default:
                break
            }
        default:
            switch self.operator1 {
            case "+":
                res = self.term1 + self.term2
            case "-":
                res = self.term1 - self.term2
            case "*":
                res = self.term1 * self.term2
            default:
                break
            }
        }
        
        self.result = res!
    }
    
    private func GiveValue(difficulty: Int) -> Int {
        
        let randomSource = GKRandomSource.sharedRandom()
        var t:Int?
        
        switch difficulty {
            
        case difficultyMode.hard.rawValue:
            t = randomSource.nextInt(upperBound: 999) + 1
            
        default:
            t = randomSource.nextInt(upperBound: 99) + 1
            
        }
        return t!
    }
    
    public func checkIfCorrect (answer:Int) -> Bool{

        self.operation += String(self.result)
        print(answer == self.result ? true: false)
        return answer == self.result ? true: false
    }
}






