//
//  AMGSafePurgeHelpers.swift
//  SafePurge
//
//  Created by Abel Gancsos on 11/4/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGSafePurgeHelpers {
	public static func applyRules(object : AMGFiles, registry : AMGRegistry) -> AMGPurgeItem? {
		if(registry.lookupKey(key: SR.keyExcludedBasePaths) != "") {
			for excludedPath in registry.lookupKey(key: SR.keyExcludedBasePaths).split(separator: ";") {
				if(object.getFullPath().contains(String(excludedPath))) {
					return nil;
				}
			}
		}
		else {
			switch(object.getType()) {
				case .FILE_TYPE:
					if(object.getSize() == 0.0) {
						if(registry.lookupKey(key: "PurgeEmptyFiles") != "0") {
							return AMGPurgeItem(object: object, reason: "Zero-byte file");
						}
					}
					else {
						if(object.getFullPath().contains(SR.pathIOSBackups)) {
							
						}
						else if(object.getFullPath().contains(SR.pathPadUpdates) || object.getFullPath().contains(SR.pathPhoneUpdates)) {
							return AMGPurgeItem(object: object, reason: "iPad/iPhone Software Update");
						}
						else if(object.getFullPath().contains(SR.pathTuneLibrary)) {
							let retentionPeriod : Int = (registry.lookupKey(key: SR.keyRetentionPeriod) != "" ?
								Int(registry.lookupKey(key: SR.keyRetentionPeriod))! : SR.defaultRetentiondays);
							do {
								let info = try FileManager.default.attributesOfItem(atPath: object.getFullPath());
								let dateDiff = DateComponentsFormatter();
								dateDiff.allowedUnits = [.day];
								if(Int(dateDiff.string(from: (info[FileAttributeKey.modificationDate] as! Date).timeIntervalSinceNow)!) ?? SR.defaultRetentiondays > retentionPeriod) {
									return AMGPurgeItem(object: object, reason: "Retention period met");
								}
							}
							catch { }
						}
						let minimumSize : Float = (registry.lookupKey(key: SR.keyMininumFileSize) != "" ?
							Float(registry.lookupKey(key: SR.keyMininumFileSize))! : SR.defaultMinimumSize);
						if(object.getSize() >= minimumSize) {
							return AMGPurgeItem(object: object, reason: "Minimum file/folder size met");
						}
					}
					break;
				case .DIRECTORY_TYPE:
					var children : [String] = [];
					do {
						try children = FileManager.default.contentsOfDirectory(atPath: object.getFullPath());
					}
					catch { }
					if(children.count == 0) {
						if(registry.lookupKey(key: "PurgeEmptyFolders") != "0") {
							return AMGPurgeItem(object: object, reason: "Empty directory");
						}
					}
					break;
				default:
					break;
			}
		}
		return nil;
	}
}
