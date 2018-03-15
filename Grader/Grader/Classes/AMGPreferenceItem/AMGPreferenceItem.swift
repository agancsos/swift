//
//  AMGPreferenceItem.swift
//  Grader
//
//  Created by Abel Gancsos on 8/31/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation

/// This class is a structur that helps build out the Preference Window faster
class AMGPreferenceItem{
    
    var name : String = "";
    var type : NSInteger = 0;
    
    /// This is the default constructor
    public init(){
    }
    
    
    /// This is the constructor with all values
    ///
    /// - Parameters:
    ///   - name2: Name of the preference
    ///   - type2: Type of preference
    public init(name2 : String, type2 : NSInteger){
        name = name2;
        type = type2;
    }
}
