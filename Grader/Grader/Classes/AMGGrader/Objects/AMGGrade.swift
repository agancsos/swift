//
//  AMGGrade.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa


class AMGGrade {
    var id              : String = "";
    var course          : AMGCourse = AMGCourse();
    var type            : AMGGradeType = AMGGradeType();
    var weight          : AMGGradeWeight = AMGGradeWeight();
    var student         : AMGStudent = AMGStudent();
    var name            : String = "";
    var notes           : String = "";
    var grade           : CGFloat = 0.00;
    var lastUpdatedDate : String = "";
    var lastUpdatedBy   : String = "";

    public init(){
        
    }
    
    public init(row : [String]){
        id = row[0];
        //course = row[1];
        //type = row[2];
        //weight = row[3];
        //student = row[4];
        name = row[5];
        notes = row[7];
        grade = CGFloat((row[6] as NSString).floatValue);
        lastUpdatedDate = row[8];
        lastUpdatedBy = row[9];
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
            case "grade_id":
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
                mResult.type = .POPUP;
                mResult.value = [weight];
                mResult.editable = true;
                break;
            case "grade_type":
                mResult.type = .POPUP;
                mResult.value = [type];
                mResult.editable = true;
                break;
            case "grade_name":
                mResult.type = .TEXT_FIELD;
                mResult.value = [name];
                mResult.editable = true;
                break;
            case "grade_notes":
                mResult.type = .TEXT_FIELD;
                mResult.value = [notes];
                mResult.editable = true;
            break;
            case "grade_value":
                mResult.type = .TEXT_FIELD;
                mResult.value = [grade];
                mResult.editable = true;
                break;
            case "student_id":
                mResult.type = .POPUP;
                mResult.value = [student];
                mResult.editable = false;
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
