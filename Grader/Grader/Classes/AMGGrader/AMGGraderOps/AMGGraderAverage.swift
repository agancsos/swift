//
//  AMGGraderAverage.swift
//  Grader
//
//  Created by Abel Gancsos on 3/14/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps calculate the weighted average
class AMGGraderAverage{
    
    var grades      : [AMGGrade] = [];
    var average     : CGFloat = 0.00;
    var totalWeight : CGFloat = 0.0;
    
    /// This is the default constructor
    public init(){
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter a: Collection of Grade objects
    public init(a : [AMGGrade]){
        grades = a;
    }
    
    
    /// This method is the public calculate method for the class
    ///
    /// - Returns: Weighted average
    public func calculateWeightedAverage() -> CGFloat {
        for grade in grades{
            let value : CGFloat = grade.grade / 100.0;
            let weight : CGFloat = CGFloat(grade.weight.weight) / 100.0;
            totalWeight += CGFloat(grade.weight.weight);
            average += (value * weight);
        }
        average = average * totalWeight;
        return average;
    }
}
