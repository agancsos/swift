//
//  AMGFiles.swift
//  SafePurge
//
//  Created by Abel Gancsos on 11/4/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

enum FILES_TYPE {
	case NONE
	case FILE_TYPE
	case DIRECTORY_TYPE
	
	public func getName() -> String {
		switch(self) {
			case .NONE:
				return "None";
			case .FILE_TYPE:
				return "File";
			case .DIRECTORY_TYPE:
				return "Folder";
		}
	}
}

class AMGFiles : Codable {
	private var fullPath : String = "";
	private var type     : FILES_TYPE = .NONE;
	private var size     : Float = 0.0;
	
	init() {
		
	}
	
	required init(from decoder: Decoder) throws {
	}
	
	func encode(to encoder: Encoder) throws {
	}
	
	init(path : String, type : FILES_TYPE = .NONE, size : Float = 0.0) {
		self.fullPath = path;
		self.type = type;
		self.size = size;
	}
	
	public static func getObjects(path : String, recursive : Bool) -> [AMGFiles] {
		var results : [AMGFiles] = [];
		do{
			let objects = try FileManager.default.contentsOfDirectory(atPath: path);
			for cursor in objects {
				if(AMGSystem.directoryExists(path: String(format: "%@/%@", path, cursor))){
					let tempObject = AMGFiles(path: String(format: "%@/%@", path, cursor), type: .DIRECTORY_TYPE, size: 0.0);
					tempObject.size = try FileManager.default.attributesOfItem(atPath: String(format: "%@/%@", path, cursor))[.size] as! Float;
					results.append(tempObject);
					if(recursive) {
						let subItems = getObjects(path: String(format: "%@/%@", path, cursor), recursive: recursive);
						for item in subItems {
							results.append(item);
						}

					}
				}
				else {
					let tempObject = AMGFiles(path: String(format: "%@/%@", path, cursor), type: .FILE_TYPE, size: 0.0);
					tempObject.size = try (FileManager.default.attributesOfItem(atPath: String(format: "%@/%@", path, cursor))[.size] as? NSNumber)?.floatValue ?? 0.0;
					results.append(tempObject);
				}
			}
		}
		catch { }
		return results;
	}
	
	/**
	 * Getters and setters
	 */
	public func getFullPath() -> String { return self.fullPath; }
	public func getType() -> FILES_TYPE { return self.type; }
	public func getSize() -> Float { return self.size; }
	public func getParentPath() -> String {
		var result : String = "";
		let components : [String.SubSequence] = self.fullPath.split(separator: "/");
		var i : Int = 0;
		for component in components {
			if(i < components.count - 1) {
				result = (result + "/" + component);
			}
			i += 1;
		}
		return result;
	}
}
