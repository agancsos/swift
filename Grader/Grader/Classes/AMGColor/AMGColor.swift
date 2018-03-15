//
//  AMGColor.swift
//
//  Created by Abel Gancsos on 1/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class is a wrapper for the NSColor class
class AMGColor : NSColor{
    public override init(){
        super.init();
    }
    
    public func make(raw : String) -> NSColor{
        let comps = raw.components(separatedBy: ",");
        var redValue   : CGFloat = 0.0;
        var greenValue : CGFloat = 0.0;
        var blueValue  : CGFloat = 0.0;
        if(comps.count == 3){
            for i in 0 ..< comps.count{
                if((comps[i] as NSString).floatValue > -1.0){
                    switch(i){
                    case 0:
                        redValue = CGFloat((comps[i] as NSString).floatValue);
                        break;
                    case 1:
                        greenValue = CGFloat((comps[i] as NSString).floatValue);
                        break;
                    case 2:
                        blueValue = CGFloat((comps[i] as NSString).floatValue);
                        break;
                    default:
                        break;
                    }
                }
            }
        }
        return NSColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    required init?(pasteboardPropertyList propertyList: Any, ofType type: String) {
        fatalError("init(pasteboardPropertyList:ofType:) has not been implemented")
    }
}

