//
//  AMGTracer.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

enum TRACE_CATEGORY {
    case NONE
    case MISC
    case SYSTEM
    case DATABASE
    case SECURITY
    case APPLICATION
    
    func getName() -> String {
        switch(self) {
            case .NONE:
                return "None";
            case .MISC:
                return "MISC";
            case .SYSTEM:
                return "System";
            case .SECURITY:
                return "Security";
            case .DATABASE:
                return "Database";
            case .APPLICATION:
                return "Application";
        }
    }
}

class AMGTracer {
    private var logfile         : String = "";
    private var traceLevel      : Int    = 1;
    
    /// This is the default constructor
    init() {
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter file: Full path of the logfile
    init(file : String, level : Int) {
        self.logfile = file;
        self.traceLevel = level;
    }
    
    
    /// This method sets the new logfile path
    ///
    /// - Parameter path: Full path of the logfile
    public func setLogfile(path : String) {
        self.logfile = path;
    }
    
    
    /// This method retrieves the path of the log file
    ///
    /// - Returns: Log file path
    public func getLogFile() -> String {
        return self.logfile;
    }
    
    public func getTraceLevel() -> Int {
        return self.traceLevel;
    }
    
    private func shouldAudit(category : TRACE_CATEGORY, level : Int) -> Bool {
        if(self.traceLevel >= level){
            return true;
        }
        return false;
    }
    
    
    /// This method adds an audit in the log file
    ///
    /// - Parameters:
    ///   - level: Level of the audit
    ///   - category: Category of the audit
    ///   - message: Message to audit
    ///   - print: Option to display audit
    public func trace(level : Int, category : TRACE_CATEGORY, message : String, print : Bool = false) {
        let shouldTrace : Bool = self.shouldAudit(category : category, level : level);
        if(shouldTrace) {
            self.trace(message: String(format: "%s\t%d\t%s", category.getName(), level, message), display: print);
        }
    }
    
    public func traceError(message : String, print : Bool = false) {
        
    }
    
    public func traceWarning(message : String, print : Bool = false) {
        
    }
    
    public func traceInformational(message : String, print : Bool = false) {
        
    }
    
    public func traceVerbose(message : String, print : Bool = false) {
        
    }
    
    /// This method adds an audit in the log file
    ///
    /// - Parameters:
    ///   - message: Message to audit
    ///   - print: Optional flag to print the message
    public func trace(message : String, display : Bool = false) {
        var currentData : String = AMGSystem(s: self.logfile).readFile();
        let format : DateFormatter = DateFormatter();
        if(display) {
            print(message);
        }
        format.dateFormat = "yyyy-MM-dd HH:mm:ss";
        if(AMGSystem.fileExists(path: self.logfile)) {
            currentData.append(format.string(from: Date()) + " ");
            currentData.append(message);
            _ = AMGSystem(s: "", t: self.logfile).writeFile(data: currentData);
        }
    }
}
