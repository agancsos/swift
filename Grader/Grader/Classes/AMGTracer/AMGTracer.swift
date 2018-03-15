//
//  AMGTracer.swift
//
//  Created by Abel Gancsos on 8/29/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation

/// This class helps manage tracing details
class AMGTracer{
    var allowVerbose : Bool = false;
    var silent : Bool = false;
    var level : String = "INFO";
    var filePath : String = "";
    
    
    /// Default constructor
    public func init2() -> AMGTracer{
        return self;
    }
    
    
    /// Custom constructor
    ///
    /// - Parameter level2: Audit level
    public func initWithLevel(level2 : String) -> AMGTracer{
        level = level2;
        return self;
    }
    
    
    /// Custom constructor
    ///
    /// - Parameters:
    ///   - level2: Audit level
    ///   - verbose: Allow verbose messages
    public func initWithLevel(level2 : String, verbose : Bool) -> AMGTracer{
        level = level2;
        allowVerbose = verbose;
        return self;
    }
    
    
    /// Custom constructor
    ///
    /// - Parameters:
    ///   - level2: Audit level
    ///   - path: Path to log file
    public func initWithLevel(level2 : String, path : String) -> AMGTracer{
        level = level2;
        filePath = path;
        return self;
    }
    
    
    /// Custom constructor
    ///
    /// - Parameters:
    ///   - level2: Audit level
    ///   - path: Path to log file
    ///   - verbose: Allow verbose messages
    public func initWithLevel(level2 : String, path : String, verbose : Bool) -> AMGTracer{
        level = level2;
        filePath = path;
        allowVerbose = verbose;
        return self;
    }
    
    
    /// This method will audit the trace details
    ///
    /// - Parameter msg: Message to include in the audit
    public func trace(msg : String){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        if(!silent){
            if(filePath != ""){
                if(!AMGCommon().writeToFile(text: String(format:"%@:%@ | %@ | %@",hour,minutes,level,msg), filename: filePath)){
                    
                }
            }
            else{
                print(String(format:"%@:%@ | %@ | %@",hour,minutes,level,msg));
            }
        }
        
    }
}
