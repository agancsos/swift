//
//  AMGCourse.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGCourse {
    var id              : String = "";
    var number          : String = "";
    var name            : String = "";
    var description     : String = "";
    var semester        : String = "";
    var year            : String = "";
    var startDate       : String = "";
    var endDate         : String = "";
    var instructor      : AMGInstructor = AMGInstructor();
    var notes           : String = "";
    var lastUpdatedDate : String = "";
    var lastUpdatedBy   : String = "";
    var college         : AMGCollege = AMGCollege();
    let children        : [BRANCH] = [.GRADEWEIGHTS,.GRADES];
    var weights         : [AMGGradeWeight] = [];
    var grades          : [AMGGrade] = [];
    
    public init(){
        
    }
    
    public init(row : [String]){
        id = row[0];
        number = row[1];
        name = row[2];
        description = row[3];
        semester = row[4];
        year = row[5];
        startDate = row[6];
        endDate = row[7];
        //instructor = row[8];
        notes = row[9];
        lastUpdatedDate = row[10];
        lastUpdatedBy = row[11];
        // college = row[12];
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
            case "course_id":
                mResult.type = .TEXT_FIELD;
                mResult.value = [id];
                mResult.editable = false;
                break;
            case "course_number":
                mResult.type = .TEXT_FIELD;
                mResult.value = [number];
                mResult.editable = true;
                break;
            case "course_name":
                mResult.type = .TEXT_FIELD;
                mResult.value = [name];
                mResult.editable = true;
                break;
            case "course_description":
                mResult.type = .TEXT_FIELD;
                mResult.value = [description];
                mResult.editable = true;
                break;
            case "course_semester":
                mResult.type = .TEXT_FIELD;
                mResult.value = [semester];
                mResult.editable = true;
                break;
            case "course_year":
                mResult.type = .TEXT_FIELD;
                mResult.value = [year];
                mResult.editable = true;
                break;
            case "course_startdate":
                mResult.type = .TEXT_FIELD;
                mResult.value = [startDate];
                mResult.editable = true;
                break;
            case "course_enddate":
                mResult.type = .TEXT_FIELD;
                mResult.value = [endDate];
                mResult.editable = true;
                break;
            case "course_instructor":
                mResult.type = .POPUP;
                mResult.value = [instructor];
                mResult.editable = true;
                break;
            case "college_id":
                mResult.type = .POPUP;
                mResult.value = [college];
                mResult.editable = true;
                break;
            case "course_notes":
                mResult.type = .TEXTAREA;
                mResult.value = [notes];
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
