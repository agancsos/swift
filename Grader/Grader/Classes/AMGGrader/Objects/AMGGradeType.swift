//
//  AMGGradeType.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGGradeType {
    var id              : String = "";
    var name            : String = "";
    var lastUpdatedDate : String = "";
    var lastUpdatedBy   : String = "";
    
    public init(){
        
    }
    
    public init(name2 : String){
        name = name2;
    }
    
    public init(row : [String]){
        id = row[0];
        name = row[1];
        lastUpdatedDate = row[2];
        lastUpdatedBy = row[3];
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
            case "grade_type_id":
                mResult.type = .TEXT_FIELD;
                mResult.value = [id];
                mResult.editable = false;
                break;
            case "grade_type_name":
                mResult.type = .TEXT_FIELD;
                mResult.value = [name];
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
