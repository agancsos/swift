//
//  AMGMainMenu.swift
//
//  Created by Abel Gancsos on 8/27/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps manage and handle main menu events in the GUI.
class AMGMainMenu : NSMenu{
	
	/// Attributes
	var session : AMGReminderData? = AMGReminderData();
	
	/// List of menu items
	/// DeveloperNOTE: Items must be organized based on parent menu
	
	// Default Menu Items
	var defaultMenu    : NSMenuItem = NSMenuItem();
	var quitMenu       : NSMenuItem = NSMenuItem();
	var aboutMenu      : NSMenuItem = NSMenuItem();
	var prefMenu       : NSMenuItem = NSMenuItem();
	var newWindow      : NSMenuItem = NSMenuItem();
	var connectionMenu : NSMenuItem = NSMenuItem();
	
	// File Menu Items
	var fileMenu       : NSMenuItem = NSMenuItem();
	var openMenu       : NSMenuItem = NSMenuItem();
	
	// Edit Menu Items
	var myEditMenu         : NSMenuItem = NSMenuItem();
	var addListMenu        : NSMenuItem = NSMenuItem();
	var addReminderMenu    : NSMenuItem = NSMenuItem();
	var deleteListMenu     : NSMenuItem = NSMenuItem();
	var deleteReminderMenu : NSMenuItem = NSMenuItem();
	
	// View Menu Items
	var viewMenu       : NSMenuItem = NSMenuItem();
	var logMenu        : NSMenuItem = NSMenuItem();
	var refreshMenu    : NSMenuItem = NSMenuItem();
	var logWindow      : AMGTableWindow? = nil;
	var sendSearch     : NSMenuItem = NSMenuItem();
	var sendQuery      : NSMenuItem = NSMenuItem();
	var showSearchHistory : NSMenuItem = NSMenuItem();
	var showSQLHistory   : NSMenuItem = NSMenuItem();
	
	
	// Window Menu Items
	var windowMenu     : NSMenuItem = NSMenuItem();
	var closeWindowMenu: NSMenuItem = NSMenuItem();
	var feedbackMenu   : NSMenuItem = NSMenuItem();
	var feedbackWindow : AMGFeedbackView? = nil;
	var prefWindowWin  : AMGPreferenceWindow? = nil;
	
	/// This is the constructor based on a session and frame
	///
	/// - Parameters:
	///   - session: AMGReminderData session for the GUI
	public init(session2 : AMGReminderData){
		//super.init(title: (Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!);
		super.init(title: "");
		session = session2;
		initializeComponents();
	}
	
	required init(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	/// This method initializes all menu items
	private func initializeComponents(){
		initializeDefaultMenu();
		initializeFileMenu();
		initializeEditMenu();
		initializeViewMenu();
		initializeWindowMenu();
	}
	
	/// This method setups up the default menu
	private func initializeDefaultMenu(){
		defaultMenu = NSMenuItem(title: "ToodleDo", action: nil, keyEquivalent: "");
		defaultMenu.submenu = NSMenu();
		self.addItem(defaultMenu);
		
		initializeAboutMenu();
		initializePrefMenu();
		initializeNewWindowMenu();
		initializeQuitMenu();
	}
	
	private func initializeEditMenu(){
		myEditMenu.title = "Edit";
		myEditMenu.submenu = NSMenu(title: "Edit");
		for menuItem in (NSApp.mainMenu?.items[2].submenu?.items)!{
			menuItem.target = self;
			if(menuItem.title == "Copy"){
				menuItem.target = self;
				menuItem.action = #selector(copy2);
			}
			else if(menuItem.title == "Paste"){
				menuItem.target = self;
				menuItem.action = #selector(paste2);
			}
			else if(menuItem.title == "Select All"){
				menuItem.target = self;
				menuItem.action = #selector(selectAll2);
			}
			else if(menuItem.title == "Cut"){
				menuItem.target = self;
				menuItem.action = #selector(cut2);
			}
			
			NSApp.mainMenu?.items[2].submenu?.removeItem(menuItem);
			myEditMenu.submenu?.addItem(menuItem);
		}
		self.addItem(myEditMenu);
		let tempList1 : NSMenuItem = NSMenuItem(title: "List", action: nil, keyEquivalent: "");
		let tempList2 : NSMenuItem = NSMenuItem(title: "Reminder", action: nil, keyEquivalent: "");
		tempList1.submenu = NSMenu(title: "List");
		tempList2.submenu = NSMenu(title: "Reminder");
		myEditMenu.submenu?.addItem(tempList1);
		myEditMenu.submenu?.addItem(tempList2);
		addListMenu = NSMenuItem(title: "Add List", action: nil, keyEquivalent: "+");
		addListMenu.keyEquivalentModifierMask = [.command,.shift];
		deleteListMenu = NSMenuItem(title: "Delete List", action: nil, keyEquivalent: "-");
		deleteListMenu.keyEquivalentModifierMask = [.command,.shift];
		tempList1.submenu?.addItem(addListMenu);
		tempList1.submenu?.addItem(deleteListMenu);
		
		addReminderMenu = NSMenuItem(title: "Add Reminder", action: nil, keyEquivalent: "+");
		addReminderMenu.keyEquivalentModifierMask = [.command];
		deleteReminderMenu = NSMenuItem(title: "Delete Reminder", action: nil, keyEquivalent: "-");
		deleteReminderMenu.keyEquivalentModifierMask = [.command];
		tempList2.submenu?.addItem(addReminderMenu);
		tempList2.submenu?.addItem(deleteReminderMenu);

	}
	
	private func initializeQuitMenu(){
		quitMenu.title = String(format: "Quit ToodleDo");
		quitMenu.target = self;
		quitMenu.keyEquivalent = "q";
		quitMenu.keyEquivalentModifierMask = [.command];
		quitMenu.action = #selector(quitApp);
		defaultMenu.submenu?.addItem(quitMenu);
	}
	
	private func initializeAboutMenu(){
		aboutMenu.title = String(format: "About ToodleDo");
		aboutMenu.target = self;
		aboutMenu.keyEquivalent = "";
		aboutMenu.keyEquivalentModifierMask = [.command];
		aboutMenu.action = #selector(aboutApp);
		defaultMenu.submenu?.addItem(aboutMenu);
	}
	
	private func initializePrefMenu(){
		prefMenu.title = "Preferences";
		prefMenu.keyEquivalent = ",";
		prefMenu.keyEquivalentModifierMask = [.command];
		defaultMenu.submenu?.addItem(prefMenu);
	}
	
	private func initializeNewWindowMenu(){
		newWindow.title = "New Instance";
		newWindow.keyEquivalent = "w";
		newWindow.target = self;
		newWindow.action = #selector(newWindowEx);
		newWindow.keyEquivalentModifierMask = [.command, .shift];
		defaultMenu.submenu?.addItem(newWindow);
		
		// Setup the preference window
		var items : [AMGPreferenceItem] = [];
		items.append(AMGPreferenceItem.init(name2: "Wallpaper", type2: 1));
		
		prefWindowWin = AMGPreferenceWindow.init(frame: NSRect.init(x: 30, y: 200, width: 800, height: 600), items2: items);
		if(AMGRegistry().getValue(key: "Wallpaper") != ""){
			prefWindowWin?.contentView?.wantsLayer = true;
			prefWindowWin?.contentView?.layer?.contents = NSImage(contentsOfFile: AMGRegistry().getValue(key: "Wallpaper"))!;
			for view in (prefWindowWin?.contentView?.subviews)!{
				if(view.className == String(format: "%@.AMGLabel",(Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!)){
					(view as! AMGLabel).textColor = NSColor.white;
				}
			}
		}
	}
	
	private func initializeViewMenu(){
		viewMenu = NSMenuItem();
		viewMenu.title = "View";
		viewMenu.submenu = NSMenu(title: "View");
		self.addItem(viewMenu);
		
		initializeRefreshMenu();
		initializeErrorMenu();
	}
	
	private func initializeErrorMenu(){
		logMenu = NSMenuItem();
		logMenu.title = "Error Logs";
		logMenu.keyEquivalent = "l";
		logMenu.keyEquivalentModifierMask = [.command, .shift];
		viewMenu.submenu?.addItem(logMenu);
		logWindow = AMGTableWindow(frame2: NSRect.init(x: 30, y: 200, width: 800, height: 600), session2: session!, table: "error_log", window: "Messages");
	}
	
	private func initializeRefreshMenu(){
		refreshMenu = NSMenuItem();
		refreshMenu.title = "Refresh";
		refreshMenu.keyEquivalent = "r";
		refreshMenu.keyEquivalentModifierMask = [.command];
		viewMenu.submenu?.addItem(refreshMenu);
	}
	
	private func initializeWindowMenu(){
		windowMenu = NSMenuItem();
		windowMenu.title = "Window";
		windowMenu.submenu = NSMenu(title: "Window");
		self.addItem(windowMenu);
		
		initializeCloseWindowMenu();
		initializeFeedbackMenu();
	}
	
	private func initializeCloseWindowMenu(){
		closeWindowMenu = NSMenuItem();
		closeWindowMenu.title = "Close";
		closeWindowMenu.target = self;
		closeWindowMenu.keyEquivalent = "w";
		closeWindowMenu.keyEquivalentModifierMask = [.command];
		closeWindowMenu.action = #selector(closeWindowEx);
		windowMenu.submenu?.addItem(closeWindowMenu);
	}
	
	private func initializeFeedbackMenu(){
		feedbackMenu = NSMenuItem();
		feedbackMenu.title = "Feedback";
		feedbackMenu.target = self;
		feedbackMenu.keyEquivalent = "";
		feedbackMenu.keyEquivalentModifierMask = [.command];
		feedbackMenu.action = #selector(showFeedback);
		windowMenu.submenu?.addItem(feedbackMenu);
		
		feedbackWindow = AMGFeedbackView.init(frame: NSRect.init(x: 30, y: 200, width: 400, height: 200));
		feedbackWindow?.contentView?.wantsLayer = true;
	}
	
	private func initializeFileMenu(){
		fileMenu = NSMenuItem();
		fileMenu.title = "File";
		fileMenu.submenu = NSMenu(title: "File");
		self.addItem(fileMenu);
		
		
		initializeFileOpenMenu();
	}
	
	private func initializeFileOpenMenu(){
		openMenu = NSMenuItem();
		openMenu.title = "Import";
		openMenu.keyEquivalent = "o";
		openMenu.keyEquivalentModifierMask = [.command];
		fileMenu.submenu?.addItem(openMenu);
	}
	
	// Base functionality
	
	public func quitApp(){
		if(AMGRegistry().getValue(key: "Verbose") == "1"){
		}
		session?.audit(action: "GUI", msg: "Closing GUI");
		exit(0);
	}
	
	public func copy2(){
		let board = NSPasteboard.general();
		board.clearContents();
		NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self);
	}
	
	public func paste2(){
		NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self);
	}
	
	public func selectAll2(){
		NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: self);
	}
	
	public func cut2(){
		NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self);
	}
	
	public func aboutApp(){
	}
	
	public func newWindowEx(){
		if(AMGCommon().runCMD(path: "/usr/bin/open", params: ["-na",String(format:"%@",Bundle.main.bundlePath)]) != "error"){
			
		}
	}
	
	public func showFeedback(){
		feedbackWindow?.show();
	}
	
	public func closeWindowEx(){
		if(NSApp.mainWindow?.title != "ToodleDo"){
			NSApp.mainWindow?.close();
		}
		else{
			session?.audit(action: "Close window", msg: "User attempted to close main window");
		}
	}
}
