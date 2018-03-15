//
//  AMGGradeWeight.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps determine the weighted GPA by putting a weight on each grade type
class AMGGradeWeight {
    var id     : String = "";
    var course : AMGCourse = AMGCourse();
    var type   : AMGGradeType = AMGGradeType();
    var weight : NSInteger = 0;
    
    public init(){
        
    }
    
    public init(row : [String]){
        id = row[0];
        // course = row[1];
        // type = row[2];
        weight = (row[3] as NSString).integerValue;
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
            case "grade_weight_id":
                mResult.type = .TEXT_FIELD;
                mResult.value = [id];
                mResult.editable = false;
                break;
            case "course_id":
                mResult.type = .POPUP;
                mResult.value = [course];
                mResult.editable = true;
                break;
            case "grade_weight":
                mResult.type = .TEXT_FIELD;
                mResult.value = [weight];
                mResult.editable = true;
                break;
            case "grade_type":
                mResult.type = .POPUP;
                mResult.value = [type];
                mResult.editable = false;
                break;
            
            default:
                break;
        }
        return mResult;
    }
}
