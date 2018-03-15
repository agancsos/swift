//
//  AMGPreferenceWindow.swift
//
//  Created by Abel Gancsos on 8/31/17.
//  Copyright © labelHeight17 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps manage and customize the settings for the application
class AMGPreferenceWindow : NSWindow{
    var items       : [AMGPreferenceItem] = [];
    var labelHeight : CGFloat = 40;
    var variance    : CGFloat = 5;
    
    /// This is the custom constructor
    ///
    /// - Parameters:
    ///   - frame: Margin information
    ///   - items2: Items to use when building out view
    public init(frame : NSRect, items2 : [AMGPreferenceItem]){
        super.init(contentRect: frame, styleMask: [.borderless,.titled,.closable], backing: .retained, defer: true);
        items = items2;
        self.isRestorable = true;
        self.isReleasedWhenClosed = false;
        self.title = "Preferences";
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
        var cursorIndex : NSInteger = 0;
        
        self.contentView = NSView();
        for pref in items{
            let cursorLabel : AMGLabel = AMGLabel.init(frame: NSRect.init(x: 0, y: Int(self.contentView!.frame.size.height - labelHeight) - Int(labelHeight + variance) * cursorIndex,
                                                                          width: Int(self.frame.size.width / 2.0), height: Int(labelHeight)), msg: pref.name);
            self.contentView?.addSubview(cursorLabel);
            
            // 1: Image, 2: TextField, 3: Switch
            if(pref.type == 1){
                let cursorButton : NSButton = NSButton(frame: NSRect(x: cursorLabel.frame.size.width, y: cursorLabel.frame.origin.y,
                                                                     width: cursorLabel.frame.size.width, height: cursorLabel.frame.size.height));
                cursorButton.title = String(format: "Set %@",pref.name);
                cursorButton.target = self;
                cursorButton.action = #selector(showSetWallpaper);
                cursorButton.autoresizingMask = [.viewWidthSizable];
                cursorButton.isBordered = true;
                cursorButton.wantsLayer = true;
                if(AMGRegistry().getValue(key: "GUI.Buttons.Borders") == "0"){
                    cursorButton.isBordered = false;
                }
                cursorButton.layer?.backgroundColor = NSColor.green.cgColor;
                self.contentView?.addSubview(cursorButton);
            }
            else if(pref.type == 2){
                let cursorText : NSTextField = NSTextField(frame: NSRect(x: cursorLabel.frame.size.width, y: cursorLabel.frame.origin.y,
                                                                                         width: cursorLabel.frame.size.width, height: cursorLabel.frame.size.height));
                cursorText.autoresizingMask = [.viewWidthSizable];
                
                if(cursorLabel.stringValue == "Indentation"){
                    cursorText.tag = 2000;
                    cursorText.stringValue = AMGRegistry().getValue(key: "Grader.Audits.RetentionPeriod");
                    if(cursorText.stringValue == ""){
                        cursorText.stringValue = "10";
                    }
                    cursorText.action = #selector(setRetentionPeriod);
                }
                self.contentView?.addSubview(cursorText);
            }
            else if(pref.type == 3){
                let cursorSwitch : NSSegmentedControl = NSSegmentedControl(frame: NSRect(x: cursorLabel.frame.size.width, y: cursorLabel.frame.origin.y,
                                                                                         width: cursorLabel.frame.size.width, height: cursorLabel.frame.size.height));
                cursorSwitch.autoresizingMask = [.viewWidthSizable];
                cursorSwitch.segmentCount = 2;
                cursorSwitch.setLabel("On", forSegment: 1);
                cursorSwitch.setLabel("Off", forSegment: 0);
                cursorSwitch.setWidth((self.contentView?.frame.size.width)! / 4, forSegment: 0);
                cursorSwitch.setWidth((self.contentView?.frame.size.width)! / 4, forSegment: 1);
                cursorSwitch.target = self;
                if(pref.name == "Silent"){
                    cursorSwitch.tag = 1137;
                    if(AMGRegistry().getValue(key: "Silent") == "1"){
                        cursorSwitch.setSelected(false, forSegment: 0);
                        cursorSwitch.setSelected(true, forSegment: 1);
                    }
                    else{
                        cursorSwitch.setSelected(true, forSegment: 0);
                        cursorSwitch.setSelected(false, forSegment: 1);
                    }
                    cursorSwitch.action = #selector(setSilent);
                }
                else if(pref.name == "Verbose"){
                    cursorSwitch.tag = 1138;
                    if(AMGRegistry().getValue(key: "Verbose") == "1"){
                        cursorSwitch.setSelected(false, forSegment: 0);
                        cursorSwitch.setSelected(true, forSegment: 1);
                    }
                    else{
                        cursorSwitch.setSelected(true, forSegment: 0);
                        cursorSwitch.setSelected(false, forSegment: 1);
                    }
                    cursorSwitch.action = #selector(setVerbose);
                }
                else if(pref.name == "Solid Background"){
                    cursorSwitch.tag = 1139;
                    if(AMGRegistry().getValue(key: "GUI.GraderView.Background.Solid") == "1"){
                        cursorSwitch.setSelected(false, forSegment: 0);
                        cursorSwitch.setSelected(true, forSegment: 1);
                    }
                    else{
                        cursorSwitch.setSelected(true, forSegment: 0);
                        cursorSwitch.setSelected(false, forSegment: 1);
                    }
                    cursorSwitch.action = #selector(setSolidBackground);
                }
                self.contentView?.addSubview(cursorSwitch);
            }
            cursorIndex += 1;
        }
    }
    
    /// This method displays the preference window
    public func show(){
        self.makeKeyAndOrderFront(self);
    }
    
    public func showSetWallpaper(){
        let openFile = NSOpenPanel();
        
        openFile.title                   = "Select Wallpaper";
        openFile.showsResizeIndicator    = true;
        openFile.showsHiddenFiles        = false;
        openFile.canChooseDirectories    = false;
        openFile.canCreateDirectories    = false;
        openFile.allowsMultipleSelection = false;
        openFile.allowedFileTypes        = ["jpeg", "jpg", "png"];
        
        if (openFile.runModal() == NSModalResponseOK) {
            let result = openFile.url;
            
            if (result != nil) {
                let path = result!.path;
                if(AMGRegistry().setValue(key: "Wallpaper", value: path)){
                    (NSApp.windows[0].contentView as! AMGBasicGUI).setWallpaper();
                    if(FileManager.default.fileExists(atPath: AMGRegistry().getValue(key: "Wallpaper"))){
                        NSApp.mainWindow?.contentView!.layer?.contents = NSImage(contentsOfFile: AMGRegistry().getValue(key: "Wallpaper"))!;
                    }
                }
                else{
                    
                }
            }
        }
    }
    
    public func setSilent(){
        for view in self.contentView!.subviews{
            if(view.tag == 1137){
                let tempSwitch : NSSegmentedControl = view as! NSSegmentedControl;
                if(tempSwitch.selectedSegment == 1){
                    if(AMGRegistry().setValue(key: "Silent", value: "1")){
                        if(AMGRegistry().setValue(key: "Verbose", value: "0")){
                            for view2 in self.contentView!.subviews{
                                if(view2.tag == 1138){
                                    let tempSwitch2: NSSegmentedControl = view2 as! NSSegmentedControl;
                                    tempSwitch2.setSelected(true, forSegment: 0);
                                }
                            }
                        }
                    }
                }
                else{
                    if(AMGRegistry().setValue(key: "Silent", value: "0")){
                    }
                }
            }
        }
    }
    
    public func setVerbose(){
        for view in self.contentView!.subviews{
            if(view.tag == 1138){
                let tempSwitch : NSSegmentedControl = view as! NSSegmentedControl;
                if(tempSwitch.selectedSegment == 1){
                    if(AMGRegistry().setValue(key: "Verbose", value: "1")){
                        for view2 in self.contentView!.subviews{
                            if(view2.tag == 1137){
                                let tempSwitch2: NSSegmentedControl = view2 as! NSSegmentedControl;
                                tempSwitch2.setSelected(true, forSegment: 0);
                            }
                        }
                    }
                }
                else{
                    if(AMGRegistry().setValue(key: "Verbose", value: "0")){
                    }
                }
            }
        }
    }
    
    public func setSolidBackground(){
        for view in self.contentView!.subviews{
            if(view.tag == 1139){
                let tempSwitch : NSSegmentedControl = view as! NSSegmentedControl;
                if(tempSwitch.selectedSegment == 1){
                    if(AMGRegistry().setValue(key: "GUI.GraderView.Background.Solid", value: "1")){
                        (NSApp.windows[0].contentView as! AMGBasicGUI).appWrapper?.refreshBackground();
                    }
                }
                else{
                    if(AMGRegistry().setValue(key: "GUI.GraderView.Background.Solid", value: "0")){
                        (NSApp.windows[0].contentView as! AMGBasicGUI).appWrapper?.refreshBackground();
                    }
                }
            }
        }
    }
    
    public func setRetentionPeriod(){
        for view in self.contentView!.subviews{
            if(view.tag == 2000){
                let tempText : NSTextField = view as! NSTextField;
                if(!AMGRegistry().setValue(key: "Grader.Audits.RetentionPeriod", value: tempText.stringValue)){
                    
                }
            }
        }
    }

}
