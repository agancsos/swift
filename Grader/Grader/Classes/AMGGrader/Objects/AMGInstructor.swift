//
//  AMGInstructor.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class represents an instructor user
class AMGInstructor : AMGUser {
    
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
    
    /// This method retrieves the class property by name
    ///
    /// - Parameter a: Name of the property
    /// - Returns: Property value as an object
    public override func getProperty(a : String) -> AMGFormField {
        var mResult : AMGFormField = AMGFormField();
        mResult = super.getProperty(a: a);
        return mResult;
    }
}
