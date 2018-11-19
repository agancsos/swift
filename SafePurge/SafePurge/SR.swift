//
//  SR.swift
//  SafePurge
//
//  Created by Abel Gancsos on 11/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
class SR {
	public static var keyTraceLevel        : String = "TraceLevel";
	public static var keyMininumFileSize   : String = "MininumFileSize";
	public static var keyIncludedBasePaths : String = "IncludedBasePaths";
	public static var keyExcludedBasePaths : String = "ExcludedBasePaths";
	public static var keyPurgeEmptyFolders : String = "PurgeEmptyFolders";
	public static var keyPurgeEmptyFiles   : String = "PurgeEmptyFiles";
	public static var keyRetentionPeriod   : String = "RetentionPeriod";
	
	public static var pathProfileCache     : String = String(format: "%@/Library/Caches", NSHomeDirectory());
	public static var pathSystemCache      : String = "/Library/Caches";
	public static var pathIOSBackups       : String = "/Library/Application Support/MobileSync/Backup/";
	public static var pathPhoneUpdates     : String = String(format: "%@/Library/iTunes/iPhone Software Updates", NSHomeDirectory());
	public static var pathPadUpdates       : String = String(format: "%@/Library/iTunes/iPad Software Updates", NSHomeDirectory());
	public static var pathTuneLibrary      : String = String(format: "%@/Music/iTunes/Previous iTunes Libraries", NSHomeDirectory());
	
	public static var defaultMinimumSize   : Float = 5.0;
	public static var defaultRetentiondays : Int = 30;
	
	public static var defaultLabelFontName : String = "Times New Roman";
	public static var defaultLabelFontSize : Float = 10.0;
	
	public static var applicationName  = ((Bundle.main.infoDictionary!["CFBundleName"]) as! String);
	public static var successFeedback  = "Feedback has been submitted!";
	public static var failureFeedback  = "An error occurred while submitting feedback";
	public static var alertFontSize    = 13.0;
	public static var settingsBasePath = String(format: "%@/Library/Application Support/SafePurge", NSHomeDirectory());
}
