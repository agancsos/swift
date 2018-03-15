//
//  AMGLabel.swift
//
//  Created by Abel Gancsos on 8/31/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class is to make non-modifiable labels
class AMGLabel : NSTextField{
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.stringValue = "";
        self.isEditable = false;
        self.isSelectable = false;
        self.backgroundColor = NSColor.clear;
        self.autoresizingMask = [.viewWidthSizable];
        self.isBordered = false;
    }
    
    public init(frame frameRect: NSRect, msg : String){
        super.init(frame: frameRect);
        self.stringValue = msg;
        self.isEditable = false;
        self.isSelectable = false;
        self.backgroundColor = NSColor.clear;
        self.autoresizingMask = [.viewWidthSizable];
        self.isBordered = false;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
