//
//  AMGReminder.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/2/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGReminder{
	
	public var id           : String = "0";
	public var pid          : String = "-1";
	public var description  : String = "";
	public var priority     : String = "5";
	public var summary      : String = "";
	public var createdDate  : String = "";
	public var status       : String = "0";
	public var completedDate: String = "";
	public var lastModified : String = "";
	
	/// This is the default constructor
	public init(){
		
	}
	
	private func findSummary(rawData : String) -> String{
		if(rawData.components(separatedBy: "DESCRIPTION:").count > 1){
			return (rawData.components(separatedBy: "DESCRIPTION:")[1].replacingOccurrences(of: "END:VTODO", with: ""));
		}
		return "";
	}
	
	
	/// This is the common constructor
	///
	/// - Parameter rawData: Raw value from the import file
	public init(rawData: String){
		let regexRowPattern : String = "(.+?):(.*)";
		var regexRowEngine : NSRegularExpression = NSRegularExpression();
		do{
			try regexRowEngine = NSRegularExpression(pattern: regexRowPattern, options: [.caseInsensitive]);
		}
		catch{
			
		}
		if(regexRowEngine.numberOfMatches(in: rawData, options: [.reportCompletion], range: NSMakeRange(0, rawData.count)) > 0){
			for rowMatch in regexRowEngine.matches(in: rawData, options: [.reportCompletion], range: NSMakeRange(0, rawData.count)){
				let lower = String.UTF16Index(encodedOffset: rowMatch.range.location);
				let upper = String.UTF16Index(encodedOffset: rowMatch.range.location + rowMatch.range.length);
				let set : String = String(rawData.utf16[lower ..< upper])!;
				let name : String = set.components(separatedBy: ":")[0];
				switch name.lowercased(){
					case "summary":
						description = set.components(separatedBy: ":")[1];
						break;
					case "created":
						createdDate = set.components(separatedBy: ":")[1];
						break;
					case "status":
						status = (set.components(separatedBy: ":")[1] == "COMPLETED" ? "1" : "0");
						break;
					case "completed":
						completedDate = set.components(separatedBy: ":")[1];
						break;
					case "priority":
						priority = set.components(separatedBy: ":")[1];
						break;
					default:
						break;
				}
			}
		}
		else{
		}
		summary = findSummary(rawData: rawData);
	}
	
	
	/// This is the full constructor
	///
	/// - Parameters:
	///   - id2: Identifier in the database
	///   - pid2: Parent identifier
	///   - desc: Description of the TODO item
	///   - pri: Priority of the item
	///   - sum: Notes for the item
	///   - cd: Created date of the item
	///   - stat: Status of the item
	///   - com: Completed date of the item
	///   - ld: Last updated date of the item
	public init(id2: String, pid2: String, desc: String, pri: String,
				sum: String, cd: String, stat: String, com: String, ld: String){
		id = id2;
		pid = pid2;
		description = desc;
		priority = pri;
		summary = sum;
		createdDate = cd;
		status = stat;
		completedDate = com;
		lastModified = ld;
	}
	
	
	/// This method retrieves the value for the specified property
	///
	/// - Parameter key: Name of the property
	/// - Returns: Value for the property
	public func getValue(key : String) -> String{
		var newKey : String = key;
		newKey = newKey.replacingOccurrences(of: "reminder_", with: "");
		newKey = newKey.replacingOccurrences(of: "list_id", with: "pid");
		switch (newKey){
			case "id":
				return id;
			case "pid":
				return pid;
			case "description":
				return description;
			case "priority":
				return priority;
			case "summary":
				return summary;
			case "created_date":
				return createdDate;
			case "status":
				if(status == "0"){
					return "NEW";
				}
				else if(status == "1"){
					return "COMPLETED";
				}
				else if(status == "2"){
					return "IN PROGRESS";
				}
				return status;
			case "completed_date":
				return completedDate;
			case "last_updated_date":
				return lastModified;
			default:
				return "";
		}
	}
}
