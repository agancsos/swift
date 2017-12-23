//
//  AMGListView.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/3/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGListView : NSOutlineView, NSOutlineViewDelegate, NSOutlineViewDataSource{
	public var session : AMGReminderData = AMGReminderData();

	/// This is the empty constructor
	public init(){
		super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
		initializeComponents();
	}
	
	/// This is the basic constructor
	public init(frame2 : CGRect){
		super.init(frame: frame2);
		initializeComponents();
	}
	
	/// This is the common constructor
	public init(frame2 : CGRect, session2 : AMGReminderData){
		
		super.init(frame: frame2);
		session = session2;
		initializeComponents();
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initializeComponents(){
		self.addTableColumn(NSTableColumn(identifier: "Reminder"));
		self.outlineTableColumn = self.tableColumn(withIdentifier: "Reminder");
		self.tableColumns[0].headerCell.title = "Reminder";
		self.indentationPerLevel = 10.0;
		self.indentationMarkerFollowsCell = true;
		if(AMGRegistry().getValue(key: "GUI.ConnectionTree.Identation") != ""){
			self.indentationPerLevel = CGFloat(Int(AMGRegistry().getValue(key: "GUI.ConnectionTree.Identation"))!);
		}
		self.headerView = nil;
		self.delegate = self;
		self.dataSource = self;
		refresh();
	}
	
	private func getChildren(id : String) -> [AMGList]{
		var mFinal : [AMGList] = [];
		mFinal = session.getChildLists(id : id);
		return mFinal;
	}
	
	private func getReminders(parent : AMGList) -> [AMGReminder]{
		var mFinal : [AMGReminder] = [];
		mFinal = session.getReminders(parent : parent);
		return mFinal;
	}

	
	public func refresh(){
		self.reloadData();
	}
	
	// Tree view delegates
	func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
		return true;
	}
	
	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		var tempBasic : AMGBasicGUI? = nil;
		if(self.enclosingScrollView != nil){
			tempBasic = (self.enclosingScrollView?.superview?.superview as! AMGBasicGUI);
		}
		if(item == nil){
			if(tempBasic != nil){
				tempBasic!.rowCountLabel.stringValue = String(format: "Children: %d", session.getAllChildren(parent: AMGList(n: "/", id2: "0", pid2: "-1")).count);
			}
			return session.getAllChildren(parent: AMGList(n: "/", id2: "0", pid2: "-1")).count;
		}
		else if((item as? AMGList) != nil){
			if(tempBasic != nil){
				tempBasic!.rowCountLabel.stringValue = String(format: "Children: %d", session.getAllChildren(parent: (item as! AMGList)).count);
			}
			return (session.getChildLists(id: (item as! AMGList).id).count + (session.getReminders(parent: (item as! AMGList))).count);
		}
		return 1;
	}
	
	func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
		if(item == nil){
			return AMGList(n: "", id2: "0", pid2: "-1").name;
		}
		else if((item as? AMGList) != nil){
			return (item as! AMGList).name;
		}
		else if((item as? AMGReminder) != nil){
			return (item as! AMGReminder).description;
		}
		return "";
	}
	
	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		if(item == nil){
			return AMGList(n: "", id2: "0", pid2: "-1");
		}
		else if((item as? AMGList) != nil){
			return session.getAllChildren(parent: (item as? AMGList)!).object(at: index);
		}
		return "";
	}
	
	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		return true;
	}
	
	func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool {
		if(AMGRegistry().getValue(key: "GUI.ListView.Lock") == "1"){
			return false;
		}
		return true;
	}
	
	func outlineViewSelectionDidChange(_ notification: Notification) {
		let tempView : AMGRemindersView = (self.enclosingScrollView?.superview as? AMGRemindersView)!;
		if((self.item(atRow: self.selectedRow) as? AMGList) != nil){
			tempView.currentList = (self.item(atRow: self.selectedRow) as! AMGList);
			tempView.property.clearAll();
		}
		else if((self.item(atRow: self.selectedRow) as? AMGReminder) != nil){
			tempView.currentReminder = (self.item(atRow: self.selectedRow) as! AMGReminder);
			tempView.property.currentReminder = tempView.currentReminder;
			tempView.property.refreshAll();
		}
	}
	
	func outlineViewItemWillExpand(_ notification: Notification) {
		self.outlineViewSelectionDidChange(notification);
	}
	
	func outlineView(_ outlineView: NSOutlineView, willDisplayOutlineCell cell: Any, for tableColumn: NSTableColumn?, item: Any) {
		if((item as? AMGList) != nil){
			if((item as! AMGList).id == "0"){
				if(FileManager().fileExists(atPath: String(format:"%@/Contents/Resources/root.png",Bundle.main.bundlePath))){
					(cell as! NSButtonCell).image = NSImage(contentsOfFile: String(format:"%@/Contents/Resources/root.png",Bundle.main.bundlePath));
				}
			}
			else{
				if(FileManager().fileExists(atPath: String(format:"%@/Contents/Resources/list_item.png",Bundle.main.bundlePath))){
					(cell as! NSButtonCell).image = NSImage(contentsOfFile: String(format:"%@/Contents/Resources/list_item.png",Bundle.main.bundlePath));
				}
			}
		}
		else if((item as? AMGReminder) != nil){
			if(FileManager().fileExists(atPath: String(format:"%@/Contents/Resources/reminder_item.png",Bundle.main.bundlePath))){
				(cell as! NSButtonCell).image = NSImage(contentsOfFile: String(format:"%@/Contents/Resources/reminder_item.png",Bundle.main.bundlePath));
			}
		}
		else{
			(cell as! NSButtonCell).image = NSImage();
		}
	}
	
	func outlineView(_ outlineView: NSOutlineView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, byItem item: Any?) {
		if((item as? AMGReminder) != nil){
			if(!session.updateDescription(reminder: (item as! AMGReminder), value: (object as! String))){
				if(AMGRegistry().getValue(key: "Silent") != "1"){
					AMGCommon().alert(message: "Failed to update reminder description", title: "Error 1139", fontSize: 13);
				}
			}
			else{
				if(AMGRegistry().getValue(key: "Verbose") != "1"){
					AMGCommon().alert(message: "Updated description", title: "Success", fontSize: 13);
				}
			}
		}
		else{
			if((item as? AMGList) != nil){
				if(!session.updateList(list: (item as! AMGList), value: (object as! String))){
					if(AMGRegistry().getValue(key: "Silent") != "1"){
						AMGCommon().alert(message: "Failed to update list", title: "Error 1140", fontSize: 13);
					}
				}
				else{
					if(AMGRegistry().getValue(key: "Verbose") != "1"){
						AMGCommon().alert(message: "Updated list", title: "Success", fontSize: 13);
					}
				}
			}
		}
	}
}
