//
//  AMGGPAWindow.swift
//  Grader
//
//  Created by Abel Gancsos on 3/12/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps display GPA infomration related to the current user
class AMGGPAWindow : NSWindow {
    
    var session      : AMGGrader = AMGGrader();
    var titleLabel   : AMGLabel = AMGLabel();
    var gpaLabel     : AMGLabel = AMGLabel();
    
    public init(){
        super.init(contentRect: NSMakeRect(0, 0, 0, 0), styleMask: [.borderless,.titled,.closable], backing: .retained, defer: true);
        initializeComponents();
    }
    
    /// This is the custom constructor
    ///
    /// - Parameters:
    ///   - frame: Margin information
    ///   - items2: Items to use when building out view
    public init(frame : NSRect){
        super.init(contentRect: frame, styleMask: [.borderless,.titled,.closable], backing: .retained, defer: true);
        self.isRestorable = true;
        self.isReleasedWhenClosed = false;
        self.title = "GPA";
        initializeComponents();
        if(AMGRegistry().getValue(key: "Wallpaper") != ""){
            if(FileManager.default.fileExists(atPath: AMGRegistry().getValue(key: "Wallpaper"))){
                self.backgroundColor = NSColor(patternImage: NSImage(contentsOfFile: AMGRegistry().getValue(key: "Wallpaper"))!);
            }
        }
        self.autorecalculatesKeyViewLoop = true;
    }
    
    /// This method sets up all items for the window
    private func initializeComponents(){
        
        titleLabel = AMGLabel(frame: NSMakeRect(0, (self.contentView?.frame.size.height)! - 30, (self.contentView?.frame.size.width)! / 2, 30));
        titleLabel.isBordered = true;
        titleLabel.autoresizingMask = [.viewWidthSizable];
        self.contentView?.subviews.append(titleLabel);
        
        gpaLabel = AMGLabel(frame: NSMakeRect(titleLabel.frame.origin.x + titleLabel.frame.size.width, titleLabel.frame.origin.y, (self.contentView?.frame.size.width)! / 2, 30));
        gpaLabel.isBordered = true;
        gpaLabel.autoresizingMask = [.viewWidthSizable];
        self.contentView?.subviews.append(gpaLabel);
    }
    
    public func show(){
        self.makeKeyAndOrderFront(self);
    }
}
