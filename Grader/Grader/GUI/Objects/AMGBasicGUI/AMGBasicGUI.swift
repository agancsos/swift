//
//  AMGBasicGUI.swift
//
//  Created by Abel Gancsos on 8/27/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps manage and display core objects in the GUI
class AMGBasicGUI : NSView, NSAlertDelegate{
    /// Attributes
    var session        : AMGGrader = AMGGrader();
    var copyrightLabel : AMGLabel = AMGLabel();
    var versionLabel   : AMGLabel = AMGLabel();
    var rowCountLabel  : AMGLabel = AMGLabel();
    var appWrapper     : AMGGraderView? = nil;
    
    /// List of menu items
    /// DeveloperNOTE: items must be organized based on parent menu
    
    // Default Menu Items
    var defaultMenu : NSMenuItem = NSMenuItem();
    
    /// This is the constructor based on a session and frame
    ///
    /// - Parameters:
    ///	  - frame: Margin information for the view
    ///   - session: Grader session for the GUI
    public init(frame : CGRect, session2 : AMGGrader){
        super.init(frame : frame);
        session = session2;
        initializeComponents();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// This method initializes all menu items
    private func initializeComponents(){
        //session.databaseHandler.runQuery(sql: "insert into connection_cache (connection_cache_host) values ('test')");
        self.layer?.backgroundColor = NSColor.white.cgColor;
        session.databaseHandler.errorTable = "error_table";
        setCopyright();
        setRowCount();
        setVersion();
        setWallpaper();
        setMenuFunctions();
        setHotkeys();
        setAppWrapper();
    }
    
    /// This method sets the owner information
    private func setCopyright(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Loading copyright label");
        }
        copyrightLabel = AMGLabel.init(frame: NSRect.init(x: 0, y: 0, width: 300, height: 20), msg: String(format: "(c) %@ Abel Gancsos Productions", AMGCommon().getYear()));
        self.addSubview(copyrightLabel);
    }
    
    /// This method sets the row count number that will be updated by the table Grader table delegate
    private func setRowCount(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Loading row count label");
        }
        rowCountLabel = AMGLabel.init(frame: NSRect.init(x: copyrightLabel.frame.origin.x + copyrightLabel.frame.size.width, y: 0, width: 300, height: 20), msg: String(format: "Rows: 0"));
        self.addSubview(rowCountLabel);
    }
    
    /// This method sets the version information
    private func setVersion(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Loading version label");
        }
        versionLabel = AMGLabel.init(frame: NSRect.init(x: self.frame.size.width - 100, y: 0, width: 100, height: 20), msg: String(format: "v. %@", AMGCommon().getVersion()));
        versionLabel.alignment = NSTextAlignment.right;
        self.addSubview(versionLabel);
    }
    
    /// This method sets the wallpaper for the application as well as the text color
    public func setWallpaper(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Loading wallpaper");
        }
        if(AMGRegistry().getValue(key: "Wallpaper") != ""){
            self.wantsLayer = true;
            if(FileManager.default.fileExists(atPath: AMGRegistry().getValue(key: "Wallpaper"))){
                self.layer?.contents = NSImage(contentsOfFile: AMGRegistry().getValue(key: "Wallpaper"))!;
                for view in self.subviews{
                    if(view.className == String(format: "%@.AMGLabel",(Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!)){
                        (view as! AMGLabel).textColor = NSColor.white;
                    }
                }
            }
        }
        else{
            for view in self.subviews{
                if(view.className == String(format: "%@.AMGLabel",(Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!)){
                    (view as! AMGLabel).textColor = NSColor.black;
                }
            }
        }
    }
    
    /// This method sets a custom hotkey for the specific menu items
    private func setHotkeys(){
        for pair in AMGRegistry().getAll(){
            if((pair.key as! String).contains("GUI.Menu.Hotkey.")){
                let currentKey   = (pair.key as! String).replacingOccurrences(of: "GUI.Menu.Hotkey.", with: "");
                let currentValue = (pair.value as! String);
                for parentMenu in (NSApp.mainMenu as! AMGMainMenu).items{
                    if(currentKey.components(separatedBy: ".").count > 1){
                        if(parentMenu.title.replacingOccurrences(of: " ", with: "") == currentKey.components(separatedBy: ".")[0]){
                            for childMenu in (parentMenu.submenu?.items)!{
                                if(childMenu.title.replacingOccurrences(of: " ", with: "") == currentKey.components(separatedBy: ".")[1]){
                                    childMenu.keyEquivalentModifierMask = [.control,.option];
                                    childMenu.keyEquivalent = currentValue;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// This method sets the functions for the menus
    private func setMenuFunctions(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Setting non-default menu functions");
        }
        
        let tempMenu : AMGMainMenu = NSApp.mainMenu as! AMGMainMenu;
        tempMenu.prefMenu.target = self;
        tempMenu.prefMenu.action = #selector(showPreferences);
        
        //tempMenu.openMenu.target = self;
        //tempMenu.openMenu.action = #selector(showOpenFile);
        
        tempMenu.logMenu.target = self;
        tempMenu.logMenu.action = #selector(showLog);
        
        tempMenu.refreshMenu.target = self;
        tempMenu.refreshMenu.action = #selector(refreshAll);
        
        tempMenu.addRecordMenu.target = self;
        tempMenu.addRecordMenu.action = #selector(addSelectedObjectType);
        
        tempMenu.deleteRecordMenu.target = self;
        tempMenu.deleteRecordMenu.action = #selector(deleteSelectedObject);
    }
    
    /// This method sets the application specific view
    private func setAppWrapper(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Building Grader view");
        }
        
        appWrapper = AMGGraderView(frame2: CGRect(x: 0, y: 20, width: self.frame.size.width, height: self.frame.size.height - 30), session2: session);
        appWrapper?.autoresizingMask = [.viewWidthSizable,.viewHeightSizable];
        self.addSubview(appWrapper!);
    }
    
    public func refreshAll(){
        //let tempContent : AMGBasicGUI = (NSApp.windows[0] as? AMGBasicGUI)!;
        
        switch(NSApp.mainWindow?.title.lowercased()){
        	case "Grader"?:
                appWrapper?.refresh();
            	break;
        	case "messages"?:
            	(NSApp.mainWindow as! AMGTableWindow).refresh();
            	break;
        	default:
            	break;
        }
    }
}
