//
//  AMGFeature.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/23/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGFeature {
    var name       : String = "";
    var label      : String = "";
    var display    : Bool = true;
	
    init() {
        
    }
    
    convenience init(name : String) {
        self.init();
        self.name = name;
    }
    
    convenience init(name : String, label : String) {
        self.init(name : name);
        self.label = label;
    }
    
    convenience init(name : String, label : String, display : Bool) {
        self.init(name : name, label : label);
        self.display = display;
    }
}
