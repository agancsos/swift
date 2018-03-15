//
//  AMGProgram.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGProgram {
    var id              : String = "";
    var college         : AMGCollege = AMGCollege();
    var name            : String = "";
    var category        : String = "";
    var chair           : AMGUser = AMGUser();
    var lastUpdatedDate : String = "";
    var lastUpdatedBy   : String = "";

    public init(){
        
    }
    
    public init(row : [String]){
        id = row[0];
        //college = row[1];
        name = row[2];
        category = row[3];
        //chair = row[4];
        lastUpdatedDate = row[5];
        lastUpdatedBy = row[6 ];
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
        case "program_id":
            mResult.type = .TEXT_FIELD;
            mResult.value = [id];
            mResult.editable = false;
            break;
        case "program_name":
            mResult.type = .TEXT_FIELD;
            mResult.value = [name];
            mResult.editable = true;
            break;
        case "college_id":
            mResult.type = .POPUP;
            mResult.value = [college];
            mResult.editable = true;
            break;
        case "program_category":
            mResult.type = .TEXT_FIELD;
            mResult.value = [category];
            mResult.editable = true;
            break;
        case "program_chair":
            mResult.type = .POPUP;
            mResult.value = [chair];
            mResult.editable = true;
            break;
        case "last_updated_date":
            mResult.type = .TEXT_FIELD;
            mResult.value = [lastUpdatedDate];
            mResult.editable = false;
            break;
        case "last_updated_by":
            mResult.type = .TEXT_FIELD;
            mResult.value = [lastUpdatedBy];
            mResult.editable = false;
            break;
        default:
            break;
        }
        return mResult;
    }
}
