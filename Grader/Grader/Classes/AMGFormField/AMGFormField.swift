//
//  AMGFormField.swift
//
//  Created by Abel Gancsos on 3/7/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

enum FORM_FIELD_TYPE : NSInteger {
    case TEXT_FIELD = 100;
    case PASSWORD = 101;
    case POPUP = 102;
    case TEXTAREA = 103;
    case SWITCH = 104;
    case DEFAULT = 105;
}

class AMGFormField {
    
    var type     : FORM_FIELD_TYPE = FORM_FIELD_TYPE.DEFAULT;
    var label    : String = "";
    var value    : [Any] = [];
    var options  : [Any] = [];
    var editable : Bool = false;
    
    public init(){
        
    }
}
