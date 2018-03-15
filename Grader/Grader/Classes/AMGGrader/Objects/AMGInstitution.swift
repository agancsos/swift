//
//  AMGInstitution.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGInstitution {
    var id              : String = "";
    var name            : String = "";
    var address         : String = "";
    var city            : String = "";
    var state           : String = "";
    var zip             : String = "";
    var country         : String = "";
    var lastUpdatedDate : String = "";
    var lastUpdatedBy   : String = "";
    var colleges        : [AMGCollege] = [];
    let children        : [BRANCH] = [.COLLEGES];
    
    public init(){
        
    }
    
    public init(row : [String]){
        id = row[0];
        name = row[1];
        address = row[2];
        city = row[3];
        state = row[4];
        zip = row[5];
        country = row[6];
        lastUpdatedDate = row[7];
        lastUpdatedBy = row[8];
    }
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public func getProperty(a : String) -> AMGFormField {
        let mResult : AMGFormField = AMGFormField();
        switch(a.lowercased()){
            case "institution_id":
                mResult.type = .TEXT_FIELD;
                mResult.value = [id];
                mResult.editable = false;
                break;
            case "institution_name":
                mResult.type = .TEXT_FIELD;
                mResult.value = [name];
                mResult.editable = true;
                break;
            case "institution_address":
                mResult.type = .TEXT_FIELD;
                mResult.value = [address];
                mResult.editable = true;
                break;
            case "institution_state":
                mResult.type = .TEXT_FIELD;
                mResult.value = [state];
                mResult.editable = true;
                break;
            case "institution_city":
                mResult.type = .TEXT_FIELD;
                mResult.value = [city];
                mResult.editable = true;
                break;
            case "institution_zip":
                mResult.type = .TEXT_FIELD;
                mResult.value = [zip];
                mResult.editable = true;
                break;
            case "institution_country":
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
