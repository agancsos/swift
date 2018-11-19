//
//  AMGLabel.swift
//
//  Created by Abel Gancsos on 11/7/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGLabel : NSTextField{
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect);
		self.prepare();
	}
	
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
		self.prepare();
	}
	
	private func prepare() {
		self.isEnabled = false;
		self.isSelectable = false;
		self.isEditable = false;
		self.stringValue = "";
		self.backgroundColor = .clear;
		self.isBordered = false;
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
