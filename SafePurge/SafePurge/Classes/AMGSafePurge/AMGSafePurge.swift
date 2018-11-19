//
//  AMGSafePurge.swift
//  SafePurge
//
//  Created by Abel Gancsos on 11/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
class AMGSafePurge {
	private var purgeObjects : [AMGPurgeItem] = [];
	var configurationFile   : String = "";
	var registry            : AMGRegistry = AMGRegistry(path: "");
	
	init() {
		self.configurationFile = String(format: "%s/safepurge.plist", SR.settingsBasePath);
		self.registry = AMGRegistry(path: self.configurationFile);
	}
	
	internal func gatherPurgeItems() {
		var basePaths : [String] = [
			SR.pathProfileCache,
			SR.pathSystemCache,
			SR.pathPadUpdates,
			SR.pathPhoneUpdates,
			SR.pathIOSBackups,
			SR.pathTuneLibrary];
		
		if(self.registry.lookupKey(key: SR.keyIncludedBasePaths) != "") {
			for basePath in self.registry.lookupKey(key: SR.keyIncludedBasePaths).split(separator: ";") {
				basePaths.append(String(basePath));
			}
		}
		
		for basePath in basePaths {
			for object in AMGFiles.getObjects(path: basePath, recursive: true) {
				if(AMGSafePurgeHelpers.applyRules(object: object, registry: self.registry) != nil) {
					self.purgeObjects.append(AMGSafePurgeHelpers.applyRules(object: object, registry: self.registry)!);
				}
			}
		}
	}
	
	public func preview() -> [AMGPurgeItem] {
		self.purgeObjects.removeAll();
		self.gatherPurgeItems();
		return self.purgeObjects;
	}
	
	public func purge() {
		self.purgeObjects.removeAll();
		self.gatherPurgeItems();
		
		for file in self.purgeObjects {
			if(self.registry.lookupKey(key: "SAFEMODE") != "1") {
				do {
					try FileManager.default.removeItem(atPath: file.getFullPath());
				}
				catch { }
			}
		}
	}
}
