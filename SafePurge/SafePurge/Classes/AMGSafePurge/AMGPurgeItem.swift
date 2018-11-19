//
//  AMGPurgeItem.swift
//  SafePurge
//
//  Created by Abel Gancsos on 11/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
class AMGPurgeItem : Codable {
	private var object      : AMGFiles = AMGFiles();
	private var description : String = "";
	
	public init() {
		
	}
	
	required init(from decoder: Decoder) throws {
	}
	
	func encode(to encoder: Encoder) throws {
	}
	
	public init(path : String, reason : String) {
		self.object = AMGFiles(path: path);
		self.description = reason
	}
	
	public init(object : AMGFiles, reason : String) {
		self.object = object;
		self.description = reason;
	}
	
	public func getFullPath() -> String { return self.object.getFullPath(); }
	public func getReason() -> String { return self.description; }
}
