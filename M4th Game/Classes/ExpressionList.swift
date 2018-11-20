//
//  ExpressionList.swift
//  M4th Game
//
//  Created by Javier Armando Montenegro Luna on 08/08/18.
//  Copyright © 2018 Javier Armando Montenegro Luna. All rights reserved.
//

import Foundation

class ExpressionList {
    
    public var list:Array<Expression>
    static let sharedInstance = ExpressionList()
    
    public var finalScore: Int {
        get {
            var total:Int = 0
            
            for exp in list {
                total += exp.score
            }
            
           return total
        }
    }
    
    public var correctTotal: Int {
        
        get{
            var total:Int = 0
            
            for exp in list {
                if exp.wasAnsweredCorrectly {
                    total += 1
                }
            }
            
            return total
        }
    }
    
    private init() {
        self.list = Array<Expression>()
    }
}
