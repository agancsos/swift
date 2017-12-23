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
	var appWrapper     : AMGRemindersView? = nil;
	var session        : AMGReminderData = AMGReminderData();
	var copyrightLabel : AMGLabel = AMGLabel();
	var versionLabel   : AMGLabel = AMGLabel();
	var rowCountLabel  : AMGLabel = AMGLabel();
	
	/// List of menu items
	/// DeveloperNOTE: items must be organized based on parent menu
	
	// Default Menu Items
	var defaultMenu : NSMenuItem = NSMenuItem();
	
	/// This is the constructor based on a session and frame
	///
	/// - Parameters:
	///	  - frame: Margin information for the view
	///   - session: DBMS session for the GUI
	public init(frame : CGRect, session2 : AMGReminderData){
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
		setAppWrapper();
		var pos : Float = 150;
		if(AMGRegistry().getValue(key: "GUI.Split.SplitterLeft") != ""){
			pos = (AMGRegistry().getValue(key: "GUI.Split.SplitterLeft") as NSString).floatValue;
		}
		appWrapper!.setPosition(CGFloat(pos), ofDividerAt: 0);
	}
	
	/// This method sets the owner information
	private func setCopyright(){
		if(AMGRegistry().getValue(key: "Verbose") == "1"){
			session.audit(action: "Loading GUI", msg: "Loading copyright label");
		}
		copyrightLabel = AMGLabel.init(frame: NSRect.init(x: 0, y: 0, width: 300, height: 20), msg: String(format: "(c) %@ Abel Gancsos Productions", AMGCommon().getYear()));
		self.addSubview(copyrightLabel);
	}
	
	/// This method sets the row count number that will be updated by the table DBMS table delegate
	private func setRowCount(){
		if(AMGRegistry().getValue(key: "Verbose") == "1"){
			session.audit(action: "Loading GUI", msg: "Loading row count label");
		}
		rowCountLabel = AMGLabel.init(frame: NSRect.init(x: copyrightLabel.frame.origin.x + copyrightLabel.frame.size.width, y: 0,
														 width: 300, height: 20), msg: String(format: "Rows: 0"));
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
			self.layer?.contents = NSImage(contentsOfFile: AMGRegistry().getValue(key: "Wallpaper"))!;
			for view in self.subviews{
				if(view.className.contains("AMGLabel")){
					(view as! AMGLabel).textColor = NSColor.white;
				}
			}
		}
		else{
			for view in self.subviews{
				if(view.className.contains("AMGLabel")){
					(view as! AMGLabel).textColor = NSColor.black;
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

		tempMenu.openMenu.target = self;
		tempMenu.openMenu.action = #selector(showOpenFile);
		
		tempMenu.logMenu.target = self;
		tempMenu.logMenu.action = #selector(showLog);
		
		tempMenu.refreshMenu.target = self;
		tempMenu.refreshMenu.action = #selector(refreshAll);
		
		tempMenu.prefMenu.target = self;
		tempMenu.prefMenu.action = #selector(showPreferences);
		
		tempMenu.addListMenu.target = self;
		tempMenu.addListMenu.action = #selector(addListEx);
		
		tempMenu.addReminderMenu.target = self;
		tempMenu.addReminderMenu.action = #selector(addReminderEx);
		
		tempMenu.deleteListMenu.target = self;
		tempMenu.deleteListMenu.action = #selector(deleteListEx);
		
		tempMenu.deleteReminderMenu.target = self;
		tempMenu.deleteReminderMenu.action = #selector(deleteReminderEx);
	}
	
	/// This method sets the application specific view
	private func setAppWrapper(){
		if(AMGRegistry().getValue(key: "Verbose") == "1"){
			session.audit(action: "Loading GUI", msg: "Building RemindersView view");
		}
		
		appWrapper = AMGRemindersView(frame: CGRect(x: 0, y: 20, width: self.frame.size.width, height: self.frame.size.height - 30), session2: session);
		appWrapper?.autoresizingMask = [.viewWidthSizable,.viewHeightSizable];
		self.addSubview(appWrapper!);
	}
	
	public func refreshAll(){
		//let tempContent : AMGBasicGUI = (NSApp.windows[0] as? AMGBasicGUI)!;
		appWrapper?.refreshView();
	}
	public func showLog(){
		if(AMGRegistry().getValue(key: "Verbose") == "1"){
			session.audit(action: "Showing logs", msg: "Loading log view");
		}
		
		let tempMenu : AMGMainMenu = NSApp.mainMenu as! AMGMainMenu;
		tempMenu.logWindow?.show();
	}
	
	public func showOpenFile(){
		if(AMGRegistry().getValue(key: "Verbose") == "1"){
			session.audit(action: "Showing open file dialog", msg: "Loading open file dialog");
		}
		
		let openFile = NSOpenPanel();
		
		openFile.title                   = "Import File";
		openFile.showsResizeIndicator    = true;
		openFile.showsHiddenFiles        = false;
		openFile.canChooseDirectories    = false;
		openFile.canCreateDirectories    = false;
		openFile.allowsMultipleSelection = false; // May look into later
		
		// Must give this option if other extension
		if(AMGRegistry().getValue(key: "Legacy.AllowAllExtensions") == "1"){
			openFile.allowsOtherFileTypes    = true;
		}
		openFile.allowedFileTypes        = ["ics", "rem"];
		
		if (openFile.runModal() == NSModalResponseOK) {
			let result = openFile.url;
			
			if (result != nil) {
				let path = result!.path;
				let reader : AMGReminderImport = AMGReminderImport(path: path);
				if(!session.importReminders(reminders: reader.extractReminders(), parent: (appWrapper?.currentList)!)){
					if(AMGRegistry().getValue(key: "Silent") != "1"){
						AMGCommon().alert(message: "Failed to import reminders", title: "Error 1142", fontSize: 13);
					}
				}
				else{
					if(AMGRegistry().getValue(key: "Verbose") == "1"){
						AMGCommon().alert(message: "Successfully import reminders", title: "Success", fontSize: 13);
					}
				}
			}
		}
	}
	
	public func showPreferences(){
		if(AMGRegistry().getValue(key: "Verbose") == "1"){
			session.audit(action: "Showing preferences", msg: "Loading preference view");
		}
		
		let tempMenu : AMGMainMenu = NSApp.mainMenu as! AMGMainMenu;
		tempMenu.prefWindowWin?.show();
	}
	
	public func addListEx(){
		if(!session.addList(parent: (appWrapper?.currentList)!)){
			session.audit(action: "Add", msg: "Failed to add list");
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Failed to add list", title: "Error 1130", fontSize: 13);
			}
		}
		else{
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Added list", title: "Success", fontSize: 13);
			}
		}
	}
	
	public func addReminderEx(){
		if(!session.addReminder(parent: (appWrapper?.currentList)!)){
			session.audit(action: "Add", msg: "Failed to add reminder");
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Failed to add reminder", title: "Error 1131", fontSize: 13);
			}
		}
		else{
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Added reminder", title: "Success", fontSize: 13);
			}
		}
	}
	
	public func deleteListEx(){
		if(appWrapper?.currentList.id != "0"){
			if(!session.deleteList(parent: (appWrapper?.currentList)!)){
				session.audit(action: "Delete", msg: "Failed to delete list");
				if(AMGRegistry().getValue(key: "Silent") != "1"){
					AMGCommon().alert(message: "Failed to delete list", title: "Error 1132", fontSize: 13);
				}
			}
			else{
				if(AMGRegistry().getValue(key: "Silent") != "1"){
					AMGCommon().alert(message: "Deleted list", title: "Success", fontSize: 13);
				}
			}
		}
		else{
			session.audit(action: "Delete", msg: "User attempted to delete root container");
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "You cannot delete the container", title: "Fatal error 1138", fontSize: 13);
			}
		}
	}
	
	public func deleteReminderEx(){
		if(!session.deleteReminder(reminder: (appWrapper?.currentReminder)!)){
			session.audit(action: "Delete", msg: "Failed to delete reminder");
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Failed to delete reminder", title: "Error 1133", fontSize: 13);
			}
		}
		else{
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Deleted reminder", title: "Success", fontSize: 13);
			}
		}
	}
}
