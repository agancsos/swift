//
//  AppDelegate.swift
//  SafePurge
//
//  Created by Abel Gancsos on 11/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var toolbar : AMGToolbarController = AMGToolbarController();

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		if(NSApplication.shared.mainMenu != nil) {
			self.toolbar = AMGToolbarController(toolbar: NSApplication.shared.mainMenu!);
			toolbar.prepare();
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
}

