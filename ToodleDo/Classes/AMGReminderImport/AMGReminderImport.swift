//
//  AMGReminderImport.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/2/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGReminderImport{
	public var filePath : String = "";
	
	public init(){
		
	}
	
	public init(path : String){
		filePath = path;
	}
	
	public func extractReminders() -> [AMGReminder]{
		var mFinal : [AMGReminder] = [];
		var rawText : String = "";
		do{
			try rawText = (NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String);
		}
		catch{
			
		}
		var regexRowPattern : String = "begin:vtodo(.*?)end:vtodo";
		if(AMGRegistry().getValue(key: "Import.Pattern") != ""){
			regexRowPattern = AMGRegistry().getValue(key: "Import.Pattern");
		}
		var regexRowEngine : NSRegularExpression = NSRegularExpression();
		do{
			try regexRowEngine = NSRegularExpression(pattern: regexRowPattern, options: [.caseInsensitive,.dotMatchesLineSeparators]);
		}
		catch{
			
		}
		if(regexRowEngine.numberOfMatches(in: rawText, options: [.reportCompletion], range: NSMakeRange(0, rawText.count)) > 0){
			for rowMatch in regexRowEngine.matches(in: rawText, options: [.reportCompletion], range: NSMakeRange(0, rawText.count)){
				let lower = String.UTF16Index(encodedOffset: rowMatch.range.location);
				let upper = String.UTF16Index(encodedOffset: rowMatch.range.location + rowMatch.range.length);
				let newRecord = AMGReminder(rawData: String(rawText.utf16[lower ..< upper])!);
				mFinal.append(newRecord);
			}
		}
		else{
		}
		return mFinal;
	}
}
