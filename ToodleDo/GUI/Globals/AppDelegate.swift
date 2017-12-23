//
//  AppDelegate.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/2/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		var session   : AMGReminderData = AMGReminderData();
		var mainBasic : AMGBasicGUI? = nil;
		var mainMenu  : AMGMainMenu? = nil;
		
		// Customize GUI
		session = AMGReminderData();
		var guiWidth  : CGFloat = 900;
		var guiHeight : CGFloat = 506;
		
		NSApp.mainWindow?.title = "ToodleDo";
		if(AMGRegistry().getValue(key: "GUI.Ratio") == "4:3"){
			guiWidth = 800;
			guiHeight = 600;
		}
		
		session.audit(action: "GUI", msg: "Starting GUI");
		
		//NSApp.mainWindow?.isOpaque = false;
		NSApp.mainWindow?.minSize = NSSize(width: guiWidth, height: guiHeight);
		NSApp.mainWindow?.setFrame(NSRect(x: (NSApp.mainWindow?.frame.origin.x)!, y: (NSApp.mainWindow?.frame.origin.y)!,
										  width: guiWidth, height: guiHeight), display: true);
		mainMenu = AMGMainMenu(session2: session);
		NSApp.mainMenu = mainMenu;
		mainBasic = AMGBasicGUI.init(frame: NSApp.mainWindow!.frame,session2 : session);
		NSApp.mainWindow?.contentView = mainBasic;
		NSApp.mainWindow?.autorecalculatesKeyViewLoop = true;
		NSApp.mainWindow?.makeFirstResponder(mainBasic?.appWrapper?.list);
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

