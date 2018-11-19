//
//  AMGPreferenceWindowModel.swift
//
//  Created by Abel Gancsos on 11/11/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGPreferenceWindowModel {
	var settings : [AMGSettingItem] = [];
	var registry : AMGRegistry = AMGRegistry(path: String(format: "%@/safepurge.plsit", SR.settingsBasePath));
	
	public init() {
		self.prepare();
	}
	
	private func prepare() {
		self.settings.append(AMGSettingItem(name: SR.keyTraceLevel, placeholder: "Trace Level", options: ["0", "1", "2", "3", "4", "5"], type: .SWITCH, label: "Trace Level"));
		self.settings.append(AMGSettingItem(name: SR.keyMininumFileSize, placeholder: "Minimum File Size", options: [], type: .TEXT_FIELD, label: "Minimum File Size"));
		self.settings.append(AMGSettingItem(name: SR.keyPurgeEmptyFiles, placeholder: "Purge Empty Files", options: ["False", "True"], type: .SWITCH, label: "Purge Empty Files"));
		self.settings.append(AMGSettingItem(name: SR.keyPurgeEmptyFolders, placeholder: "Purge Empty Folders", options: ["False", "True"], type: .SWITCH, label: "Purge Empty Folders"));
		self.settings.append(AMGSettingItem(name: SR.keyRetentionPeriod, placeholder: "Retention Period", options: [], type: .TEXT_FIELD, label: "retention Period"));
		self.settings.append(AMGSettingItem(name: SR.keyIncludedBasePaths, placeholder: "Included Directories", options: [], type: .TEXT_FIELD, label: "Included Directories"));
		self.settings.append(AMGSettingItem(name: SR.keyExcludedBasePaths, placeholder: "Excluded Directories", options: [], type: .TEXT_FIELD, label: "Excluded Directories"));
	}
	
	public func refresh() {
		self.settings.removeAll();
		self.prepare();
	}
	
	public func findSetting(name : String) -> AMGSettingItem {
		for setting in self.settings {
			if(setting.name == name){
				return setting;
			}
		}
		return AMGSettingItem();
	}
}
