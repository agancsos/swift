//
//  AMGTextView.swift
//
//  Created by Abel Gancsos on 9/10/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGTextView : NSTextView, NSTextViewDelegate{
    var placeholderString : String = "";
    
    public init(){
        super.init(frame: NSRect(x: 0, y: 0, width: 0, height: 0));
		self.drawsBackground = true;
    }
    
    public init(frame2 : CGRect, placeholder : String){
        super.init(frame : frame2);
        placeholderString = placeholder;
        self.string = placeholderString;
        self.delegate = self;
		self.drawsBackground = true;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container);
		self.drawsBackground = true;
    }
	
	func textDidEndEditing(_ notification: Notification) {
		if(self.string == ""){
			self.string = placeholderString;
		}
		self.setSelectedRange(NSRange(location: 0,length: 0));
	}
	
	override func becomeFirstResponder() -> Bool {
		if(self.string == placeholderString){
			self.string = "";
		}
		return true;
	}
}
