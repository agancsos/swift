//
//  AMGMessages.swift
//  Grader
//
//  Created by Abel Gancsos on 9/2/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation

enum AMGError : NSInteger{
    case DEFAULT_ERROR = 1137;
    case FEATURE_NOT_SUPPORTED = 1138;
}

/// This class is a custom exception class for throwing expected errors
class AMGMessage : NSError{
    
    var message   : String = "";
    var errorCode : NSInteger = 1137;
    var exitCode  : AMGError = .DEFAULT_ERROR;
    
    public init(){
        super.init(domain: "ERROR", code: errorCode, userInfo: nil);
    }
    
    public init(msg : String){
        message = msg;
        super.init(domain: message, code: errorCode, userInfo: nil);
    }

    public init(msg : String, code : NSInteger){
        message = msg;
        errorCode = code;
        super.init(domain: message, code: errorCode, userInfo: nil);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
