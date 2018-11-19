//
//  AMGSettingItem.swift
//
//  Created by Abel Gancsos on 11/11/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

enum SETTING_TYPE {
	case NONE
	case TEXT_FIELD
	case TEXT_VIEW
	case SWITCH
	
	func getName() -> String {
		switch(self) {
			case .SWITCH:
				return "Switch";
			case .TEXT_FIELD:
				return "Textfield";
			case .TEXT_VIEW:
				return "Textview";
			default:
				return "None";
		}
	}
}

class AMGSettingItem {
	
	var name        : String = "";
	var placeholder : String = "";
	var options     : [String] = [];
	var type        : SETTING_TYPE = .NONE;
	var label       : String = "";
	
	init() {
		
	}
	
	init(name : String = "", placeholder : String = "", options : [String] = [], type : SETTING_TYPE = .NONE, label : String = "") {
		self.name = name;
		self.placeholder = placeholder;
		self.options = options;
		self.type = type;
		self.label = label;
		if(self.label == ""){
			self.label = self.name;
		}
	}
}
