//
//  AMGConfiguration.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGConfiguration {
    private var configurationFile : String = "";
    
    
    /// This is the default constructor
    init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter path: Full path of the text configuration file
    init(path : String) {
        self.configurationFile = path;
    }
    
    
    /// This method retrieves the configuration file path
    ///
    /// - Returns: Full path of the configuration file
    public func getConfigurationFile() -> String {
        return self.configurationFile;
    }
    
    
    /// This method retrieves the value of a "key" or parameter
    ///
    /// - Parameter key: Name of the key/parameter
    /// - Returns: Value of the key or blank if it doesn't exist
    public func lookupKey(key : String) -> String {
        if(AMGSystem.fileExists(path: self.configurationFile)) {
            let rawConfiguration : String = AMGSystem(s: self.configurationFile).readFile();
            let rawPairs = rawConfiguration.split(separator: "\n");
            for rawPair in rawPairs {
                let comps = rawPair.split(separator: "=");
                if(comps.count == 2) {
                    return String(comps[1]);
                }
            }
        }
        return "";
    }
}
