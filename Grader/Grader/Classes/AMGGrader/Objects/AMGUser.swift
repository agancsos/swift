//
//  AMGUser.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class represents a base user for the Grader application
class AMGUser {
    var id              : String = "";
    var type            : String = "";
    var firstName       : String = "";
    var lastName        : String = "";
    var address         : String = "";
    var city            : String = "";
    var state           : String = "";
    var zip             : String = "";
    var country         : String = "";
    var lastUpdatedDate : String = "";
    var lastUpdatedBy   : String = "";
    
    public init(){
        
    }
    
    public init(row : [String]){
        id = row[0];
        type = row[1];
        firstName = row[2];
        lastName = row[3];
        address = row[4];
        city = row[5];
        state = row[6];
        zip = row[7];
        country = row[8];
        lastUpdatedDate = row[9];
        lastUpdatedBy = row[10];
    }
    
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
            case "user_id":
                mResult.type = .TEXT_FIELD;
                mResult.value = [id];
                break;
            case "user_type":
                mResult.type = .POPUP;
                mResult.value = [type];
                mResult.options = ["Student","Instructor"];
                mResult.editable = true;
                break;
            case "user_firstname":
                mResult.type = .TEXT_FIELD;
                mResult.value = [firstName];
                mResult.editable = true;
                break;
            case "user_lastname":
                mResult.type = .TEXT_FIELD;
                mResult.value = [lastName];
                mResult.editable = true;
                break;
            case "user_address":
                mResult.type = .TEXT_FIELD;
                mResult.value = [address];
                mResult.editable = true;
                break;
            case "user_city":
                mResult.type = .TEXT_FIELD;
                mResult.value = [city];
                mResult.editable = true;
                break;
            case "user_zip":
                mResult.type = .TEXT_FIELD;
                mResult.value = [zip];
                mResult.editable = true;
                break;
            case "user_state":
                mResult.type = .TEXT_FIELD;
                mResult.value = [state];
                mResult.editable = true;
                break;
            case "user_country":
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
