//
//  AMGCommon.swift
//
//  Created by Abel Gancsos on 8/27/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//


import Foundation
import Cocoa

/// This class helps with common tasks
class AMGCommon{

    /// Prompt user for input
    ///
    /// - Parameters:
    ///   - prompt: Message to display in prompt
    ///   - defaultValue: Default value to us in the prompt
    ///   - frame: Size and location of the message box
    /// - Returns: New string value from the user input
    public func input(prompt : String, defaultValue : String, frame: NSRect) -> String{
        return "";
    }
    
    public func urlEncode(text : String) -> String{
        var mfinal : String = "";
        mfinal = text;
        mfinal = mfinal.replacingOccurrences(of: " ", with: "%20");
        mfinal = mfinal.replacingOccurrences(of: "\n", with: "%2A");
        return mfinal;
    }
    
    /// Displays a popup message
    ///
    /// - Parameters:
    ///   - message: Message to display
    ///   - title: Title for message box
    ///   - fontSize: Size of the text
    public func alert(message : String,title : String, fontSize : CGFloat){
        let alert : NSAlert = NSAlert();
        alert.window.title = title ;
        alert.messageText = "";
        alert.informativeText = message ;
		alert.alertStyle = NSAlert.Style.warning;
        alert.addButton(withTitle: "Close");
        let views : NSArray = (alert.window.contentView?.subviews as! NSArray);
        let titleFont : NSFont = NSFont(name: "Arial", size: fontSize + 1)!;
        let font : NSFont = NSFont(name: "Arial", size: fontSize)!;
        (views[4] as! NSTextField).font = titleFont;
        (views[5] as! NSTextField).font = font;
        alert.runModal();
    }

    /// Runs a command on the system
    ///
    /// - Parameters:
    ///   - path: Path to command to run
    ///   - params: Parameters to pass along to the command
    /// - Returns: Standard output of the command
    public func runCMD(path : String, params : NSArray) -> String{
        var mfinal : String = "";
        if(FileManager.default.fileExists(atPath: path )){
            let proc : Process = Process();
            proc.launchPath = path ;
            proc.arguments = params as? [String];
            let socket : Pipe = Pipe();
            proc.standardOutput = socket;
            proc.launch();
            proc.waitUntilExit();
            let reader : FileHandle = socket.fileHandleForReading;
            let raw : Data = reader.readDataToEndOfFile();
            mfinal = String(data: raw, encoding: String.Encoding.utf8)!;
        }
        return mfinal;
    }

    /// Gets application version data
    ///
    /// - Returns: String value containg version string
    public func getVersion() -> String{
        return (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String);
    }

    /// Checks if value exists in array
    ///
    /// - Parameters:
    ///   - value: Value to look up
    ///   - inArray: Array to search
    /// - Returns: True if found, False if not found
    public func search(value : String, inArray : NSArray) -> Bool{
        for cursor in inArray{
            if((cursor as! String) == value){
                return true;
            }
        }
        return false;
    }

    /// Retrieves the current timestamp
    ///
    /// - Returns: String format of the timestamp
    public func getTimeStamp() -> String{
        let date : NSDate = NSDate();
        let dateFormat : DateFormatter = DateFormatter();
        dateFormat.dateFormat = "YYYY-MM-DD HH:mm:ss";
        let dateString : String = dateFormat.string(from: date as Date) ;
        return dateString;
    }

    /// Get current year
    ///
    /// - Returns: String format of the current year
    public func getYear() -> String{
        let date : NSDate = NSDate();
        let dateFormat : DateFormatter = DateFormatter();
        dateFormat.dateFormat = "YYYY";
        let dateString : String = dateFormat.string(from: date as Date) ;
        return dateString;
    }

    /// Left pad a string
    ///
    /// - Parameters:
    ///   - str: String to pad
    ///   - length: Length of the final string
    ///   - padChar: Character to use to pad the string
    /// - Returns: Left-padded string
    public func leftPad(str : String, length : NSInteger, padChar : String) -> String{
        if(str.count > length){
            return str.substring(to: str.index(str.startIndex,offsetBy:length));
        }
        else{
            var mfinal : String = "";
            for i in str.count ..< length{
                if(i > 0){
                    
                }
                mfinal = mfinal.appending(padChar ) ;
            }
            return (mfinal.appending(str));
        }
    }

    /// Right pad a string
    ///
    /// - Parameters:
    ///   - str: String to pad
    ///   - length: Length of the final string
    ///   - padChar: Character to use to pad the string
    /// - Returns: Right-padded string
    public func rightPad(str : String, length : NSInteger, padChar : String) -> String{
        if(str.count > length){
            return str.substring(to: str.index(str.startIndex,offsetBy:length)) ;
        }
        else{
            var mfinal : String = "";
            for i in str.count ..< length{
                if(i > 0){
                    
                }
                mfinal = mfinal.appending(padChar ) ;
            }
            return (str.appending(mfinal));
        }
    }

    /// Checks if there is an internet connection
    ///
    /// - Returns: True if yes, False if no
    public func internet() -> Bool{
        do{
            let rawContent : String = try (String(contentsOf: URL.init(string: "http://www.google.com")!, encoding: String.Encoding(rawValue: String.Encoding.isoLatin2.rawValue)));
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

    /// Check if site is available
    ///
    /// - Parameter domain: URL to site
    /// - Returns: True if accessible, False if not
    public func server(domain : String) -> Bool{
        if(internet()){
            do{
                let rawContent : String = try (String(contentsOf: URL.init(string: domain )!, encoding: String.Encoding(rawValue: String.Encoding.isoLatin2.rawValue)));
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

    /// Write text to file
    ///
    /// - Parameters:
    ///   - text: Text to write
    ///   - filename: File path to write text to
    /// - Returns: True if successful, False if not
    public func writeToFile(text : String, filename : String) -> Bool{
        do{
            let handler : FileHandle = FileHandle(forWritingAtPath: filename )!;
            handler.seekToEndOfFile();
            handler.write(text.data(using: String.Encoding.utf8)!);
            handler.write("\n".data(using: String.Encoding.utf8)!);
            handler.closeFile();
            return true;
        }
    }

    /// Read from application file
    ///
    /// - Parameter filename: Name of the file located in the application bundle
    /// - Returns: String value of the text from the file
    public func readLocalFile(filename : String) -> String{
        let path : String = Bundle.main.path(forResource: filename , ofType: "dat")! ;
        var mfinal : String = "";
        do{
        	try mfinal = String(contentsOfFile: path , encoding: String.Encoding.utf8) ;
        }
        catch{
        }
        return mfinal;
    }

    /// Gets value from a generated collection
    ///
    /// - Parameters:
    ///   - allContent: Raw text to create collection from
    ///   - separator: Delimeter to build the collection
    ///   - index: Index to retrieve value for
    /// - Returns: String value from the collection
    public func extractValue(allContent : String, separator : String, index : NSInteger) -> String{
        if(allContent.components(separatedBy: separator ).count > index - 1){
            return allContent.components(separatedBy: separator )[index] ;
        }
        return "";
    }

    /// Gets value from a generated collection
    ///
    /// - Parameters:
    ///   - list: Collection of string data
    ///   - separator: Delimeter to build the collection
    ///   - index: Index to retrieve value for
    ///   - value: Name of collection to retrieve
    ///   - returnIndex: Index to return from collection
    /// - Returns: String value from the collection
    public func extractFromList(list : NSArray, separator : String, index : NSInteger, value : String, returnIndex : NSInteger) -> String{
        for i in 0 ..< list.count{
            if((extractValue(allContent: list[i] as! String, separator: separator, index: index)) == value){
                return extractValue(allContent: list[i] as! String, separator: separator, index: returnIndex) ;
            }
        }
        return "";

    }

    /// Gets the url from the root file that is most accessible
    ///
    /// - Parameter file: File containing list of URL's
    /// - Returns: String value for the proper url
    public func getRoot(file : String) -> String{
        let filePath : String = Bundle.main.path(forResource: file , ofType: "dat")! ;
        var urls : [String];
        do{
            try  urls = (String(contentsOfFile: filePath , encoding: String.Encoding.isoLatin2).components(separatedBy: "\n"));
            for i in 0 ..< urls.count{
                var urlContents : String = "";
                try urlContents = String(contentsOfFile: urls[i] , encoding: String.Encoding.isoLatin2);
                if(urlContents != ""){
                    return urls[i] ;
                }
            }
        }
        catch{
            
        }
        return "";
    }

}
