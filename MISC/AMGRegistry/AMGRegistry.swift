//
//  AMGRegistry.swift
//
//  Created by Abel Gancsos on 8/27/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation

/// This class helps manage the "registry" keys associated to the application
class AMGRegistry{
    var filePath : String = "";
    var app : String = "Sample";
    var root : String = "";
    
    private func prepare(){
        var dir : ObjCBool = false;
        if(!FileManager.default.fileExists(atPath: filePath , isDirectory: &dir)){
            if(!dir.boolValue){
                do{
                    try FileManager.default.createDirectory(atPath: filePath , withIntermediateDirectories: false, attributes: nil);
                }
                catch{
                }
            }
        }
        
        if(!FileManager.default.fileExists(atPath: ((filePath ) ) + "/" + (app ) + ".plist")){
            NSDictionary.init().write(toFile: ((filePath ) ) + "/" + (app ) + ".plist", atomically: false);
        }
    }
    
    public init(){
        filePath = String.init(format: "%@/Library/Application Support/%@", NSHomeDirectory(),app);
        root = "/";
        prepare();
    }

    /// This is the constructor with the file parameter
    ///
    /// - Parameter file: Path to the registry file
    public init(file : String){
        filePath = file;
        root = "/";
        prepare();
    }
    
    /// This is the constructor with the file and root parameters
    ///
    /// - Parameters:
    ///   - file: Path to the registry file
    ///   - root2: Root in the registry file
    public init(file : String,root2 : String){
        filePath = file;
        root = root2;
        prepare();
    }
    
    /// This method returns all keys
    public func getAll() -> NSDictionary{
        let dict : NSDictionary = NSDictionary.init(contentsOfFile: ((filePath ) ) + "/" + (app ) + ".plist")!;
        return dict;
    }
    
    /// This method retrieves the value for the specified key
    ///
    /// - Parameter key: Name of the key to get the value for
    /// - Returns: The value for the key
    public func getValue(key : String) -> String{
        var mfinal : String = "";
        let dict : NSDictionary = NSDictionary.init(contentsOfFile: ((filePath ) ) + "/" + (app ) + ".plist")!;
        for cursorKey in dict.allKeys{
            if(cursorKey as! String == key){
                mfinal = dict.value(forKey: (cursorKey as! String)) as! String;
            }
        }
        return mfinal;
    }
    
    /// This set the value for the key
    ///
    /// - Parameters:
    ///   - key: Name of the key
    ///   - value: Value for the key
    /// - Returns: True if successful, False if not
    public func setValue(key : String, value : String) -> Bool{
        do{
            let dict : NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: ((filePath ) ) + "/" + (app ) + ".plist")!;
            dict.setValue(value , forKey: key );
            dict.write(toFile: ((filePath ) ) + "/" + (app ) + ".plist", atomically: false);
            return true;
        }
    }
}
