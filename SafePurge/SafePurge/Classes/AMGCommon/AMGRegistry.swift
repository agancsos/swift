//
//  AMGRegistry.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGRegistry {
    private var registry : String = "";
    
    
    /// This is the default constructor
    init() {
        self.registry = (Bundle.main.path(forResource: "Info", ofType: "plist"))!;
    }
    
    private func prepare(){
        if(!FileManager.default.fileExists(atPath: self.registry)){
            NSDictionary.init().write(toFile: self.registry, atomically: false);
        }
    }

    
    /// This is the common constructor
    ///
    /// - Parameter path: Full path of the property file
    init(path : String) {
        self.registry = path;
		let basePath = (self.registry as NSString).deletingLastPathComponent;
		if(!AMGSystem.directoryExists(path: basePath)) {
			do{
				try FileManager.default.createDirectory(
					atPath: basePath,
					withIntermediateDirectories: true, attributes: [:]);
			}
			catch { }
		}
        self.prepare();
    }
    
    
    /// This method retrieves the registry path
    ///
    /// - Returns: Full path of the registry file
    public func getRegistry() -> String {
        return self.registry;
    }
    
    public func purge(){
        let dict : NSMutableDictionary = NSMutableDictionary(dictionary: NSDictionary.init(contentsOfFile: self.registry)!);
        for pair in dict{
            if((pair.value as! String) == ""){
                dict.removeObject(forKey: pair.key as! String);
            }
        }
        dict.write(toFile: self.registry, atomically: false);
    }

    
    /// This method returns all keys
    public func getAll() -> NSDictionary{
        let dict : NSDictionary = NSDictionary.init(contentsOfFile: self.registry)!;
        return dict;
    }
    
    /// This method retrieves the value for a given key
    ///
    /// - Parameter key: Name of the key to return
    /// - Returns: Key value
    public func lookupKey(key : String) -> String {
        var mfinal : String = "";
        let dict : NSDictionary = NSDictionary.init(contentsOfFile: self.registry)!;
        for cursorKey in dict.allKeys{
            if(cursorKey as! String == key){
                mfinal = dict.value(forKey: (cursorKey as! String)) as! String;
            }
        }
        return mfinal;
    }
    
    
    /// This method sets the value of a key
    ///
    /// - Parameters:
    ///   - key: Name of the key to set
    ///   - value: Value of the key
    public func writeKey(key : String, value : String) {
        do{
            let dict : NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: self.registry)!;
            dict.setValue(value , forKey: key );
            dict.write(toFile: self.registry, atomically: false);
        }
    }
}
