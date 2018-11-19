//
//  AMGSystem.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGSystem {
    private var source : String = "";
    private var target : String = "";
    
    
    /// This is the default constructor
    init() {
        
    }
	
	public static func urlEncode(text : String) -> String{
		var mfinal : String = "";
		mfinal = text;
		mfinal = mfinal.replacingOccurrences(of: " ", with: "%20");
		mfinal = mfinal.replacingOccurrences(of: "\n", with: "%2A");
		return mfinal;
	}
	
	// Checks if there is an internet connection
	///
	/// - Returns: True if yes, False if no
	public static func internet() -> Bool{
		do{
			let rawContent : String = try (String(contentsOf: URL.init(string: "https://www.google.com")!,
												  encoding: String.Encoding(rawValue: String.Encoding.isoLatin2.rawValue)));
			if(rawContent == ""){
				return false;
			}
			else{
				return true;
			}
		}
		catch{
			
		}
		return false;
	}
	
	// Check if site is available
	///
	/// - Parameter domain: URL to site
	/// - Returns: True if accessible, False if not
	public static func server(domain : String) -> Bool{
		if(internet()){
			do{
				let rawContent : String = try (String(contentsOf: URL.init(string: domain)!,
													  encoding: String.Encoding(rawValue: String.Encoding.isoLatin2.rawValue)));
				if(rawContent == ""){
					return false;
				}
				else{
					return true;
				}
			}
			catch{
				
			}
		}
		return false;
	}
    
    
    /// This is the common constructor
    ///
    /// - Parameter s: Full path of the source object
    init(s : String) {
        self.source = s;
    }
    
    
    /// This is the full constructor
    ///
    /// - Parameters:
    ///   - s: Full path of the source object
    ///   - t: Full path of the target object
    init(s : String, t: String) {
        self.source = s;
        self.target = t;
    }
    
    
    /// This method checks if the file exists at a given path
    ///
    /// - Parameter path: Full path of the file
    /// - Returns: True if it exists, false if not
    public static func fileExists(path : String) -> Bool {
        return FileManager.default.fileExists(atPath: path);
    }
    
    
    /// This method checks if a directory exists
    ///
    /// - Parameter path: Full path of the directory
    /// - Returns: True if it exists, false if not
    public static func directoryExists(path : String) -> Bool {
        var isdir : ObjCBool = false;
        if(FileManager.default.fileExists(atPath: path, isDirectory: &isdir)) {
            if(isdir.boolValue) {
                return true;
            }
        }
        return false;
    }
    
    
    /// This method retrieves the contents of a file
    ///
    /// - Returns: Data from file
    public func readFile() -> String {
        var result : String = "";
        do {
            try result = (NSString(contentsOfFile: self.source, encoding: String.Encoding.utf8.rawValue) as String);
        }
        catch {
            
        }
        return result;
    }
    
    
    /// This method writes data to a file
    ///
    /// - Parameter data: Data to write
    /// - Returns: Successful if no errors, false if there was
    public func writeFile(data : String) -> Bool {
        do {
            try data.write(to: URL.init(string: self.target)!, atomically: true, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue));
        }
        catch {
            return false;
        }
        return true;
    }
    
    
    /// This method retrieves the version of the application
    ///
    /// - Returns: Version
    public func getVersion() -> AMGVersion {
        var version : AMGVersion = AMGVersion();
        let comps : [String.SubSequence] = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String).split(separator: ".");
        version = AMGVersion(major: (Int(comps[0]) != nil ? Int(comps[0])! : 0),
                             minor: (Int(comps[1]) != nil ? Int(comps[1])! : 0),
                             build: (Int(comps[2]) != nil ? Int(comps[2])! : 0));
        return version;
    }
}
