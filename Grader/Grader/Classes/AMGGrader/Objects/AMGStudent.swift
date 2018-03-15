//
//  AMGStudent.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class represents a student user
class AMGStudent : AMGUser {
    var number          : String = "";
    var startDate       : String = "";
    var currentGPA      : CGFloat = 0.00;
    var program         : AMGProgram = AMGProgram();
    
    public override init(){
        super.init();
    }
    
    public init(base : AMGUser){
        super.init();
        firstName = base.firstName;
        lastName = base.lastName;
        id = base.id;
        type = base.type;
        address = base.address;
        city = base.city;
        state = base.state;
        zip = base.zip;
        country = base.country;
        lastUpdatedDate = base.lastUpdatedDate;
        lastUpdatedBy = base.lastUpdatedBy;
    }
    
    public init(row : [String], program2 : AMGProgram){
        super.init(row: row);
        program = program2;
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public override func getProperty(a : String) -> AMGFormField {
        var mResult : AMGFormField = AMGFormField();
        mResult = super.getProperty(a: a);
        if(mResult.type == .DEFAULT){
            switch(a.lowercased()){
                case "student_number":
                    mResult.type = .TEXT_FIELD;
                    mResult.value = [number];
                    mResult.editable = true;
                    break;
                case "student_startdate":
                    mResult.type = .TEXT_FIELD;
                    mResult.value = [startDate];
                    mResult.editable = true;
                    break;
                case "student_current_gpa":
                    mResult.type = .TEXT_FIELD;
                    mResult.value = [currentGPA];
                    mResult.editable = false;
                    break;
                case "program_id":
                    mResult.type = .POPUP;
                    mResult.value = [program];
                    mResult.editable = true;
                    break;
                default:
                    break;
            }
        }
        return mResult;
    }
}
