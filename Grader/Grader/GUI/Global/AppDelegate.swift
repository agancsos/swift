//
//  AppDelegate.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // Global application objects
    var session : AMGGrader? = nil;
    var mainBasic : AMGBasicGUI? = nil;
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
        }
        
        
        // Customize GUI
        session = AMGGrader();
        var guiWidth  : CGFloat = 900;
        var guiHeight : CGFloat = 506;
        
        NSApp.mainWindow?.title = "Grader";
        if(AMGRegistry().getValue(key: "GUI.Ratio") == "4:3"){
            guiWidth = 800;
            guiHeight = 600;
        }
        
        NSApp.mainWindow?.isOpaque = false;
        NSApp.mainWindow?.minSize = NSSize(width: guiWidth, height: guiHeight);
        NSApp.mainWindow?.setFrame(NSRect(x: (NSApp.mainWindow?.frame.origin.x)!, y: (NSApp.mainWindow?.frame.origin.y)!, width: guiWidth, height: guiHeight), display: true);
        NSApp.mainMenu = AMGMainMenu.init(session2: session!);
        mainBasic = AMGBasicGUI.init(frame: NSApp.mainWindow!.frame,session2 : session!);
        NSApp.mainWindow?.contentView = mainBasic;
        NSApp.mainWindow?.autorecalculatesKeyViewLoop = true;
        NSApp.mainWindow?.makeFirstResponder(mainBasic?.appWrapper?.institutionTree);
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

