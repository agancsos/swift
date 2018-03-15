//
//  AMGCollege.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGCollege {
    var id              : String = "";
    var institute       : AMGInstitution = AMGInstitution();
    var name            : String = "";
    var address         : String = "";
    var city            : String = "";
    var state           : String = "";
    var zip             : String = "";
    var country         : String = "";
    var dean            : AMGUser = AMGUser();
    var lastUpdatedDate : String = "";
    var lastUpdatedBy   : String = "";
    let children        : [BRANCH] = [.STUDENTS,.INSTRUCTORS,.COURSES,.PROGRAMS];
    var students        : [AMGStudent] = [];
    var instructors     : [AMGInstructor] = [];
    var programs        : [AMGProgram] = [];
    var courses         : [AMGCourse] = [];

    
    public init(){
        
    }
    
    public init(row : [String]){
        id = row[0];
        //instructors = row[1];
        name = row[2];
        address = row[3];
        city = row[4];
        state = row[5];
        zip = row[6];
        country = row[7];
        //dean = row[8];
        lastUpdatedDate = row[0];
        lastUpdatedBy = row[0];
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
            case "college_id":
                mResult.type = .TEXT_FIELD;
                mResult.value = [id];
                mResult.editable = false;
                break;
            case "college_name":
                mResult.type = .TEXT_FIELD;
                mResult.value = [name];
                mResult.editable = true;
                break;
            case "college_address":
                mResult.type = .TEXT_FIELD;
                mResult.value = [address];
                mResult.editable = true;
                break;
            case "institution_id":
                mResult.type = .POPUP;
                mResult.value = [institute];
                mResult.editable = true;
                break;
            case "college_dean":
                mResult.type = .POPUP;
                mResult.value = [dean];
                mResult.editable = true;
                break;
            case "college_city":
                mResult.type = .TEXT_FIELD;
                mResult.value = [city];
                mResult.editable = true;
                break;
            case "college_state":
                mResult.type = .TEXT_FIELD;
                mResult.value = [state];
                mResult.editable = true;
                break;
            case "college_zip":
                mResult.type = .TEXT_FIELD;
                mResult.value = [zip];
                mResult.editable = true;
                break;
            case "college_country":
                mResult.type = .TEXT_FIELD;
                mResult.value = [country];
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
