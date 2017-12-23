//
//  AMGTableWindow.swift
//
//  Created by Abel Gancsos on 9/14/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps present data in a particular database table through a new window
class AMGTableWindow : NSWindow, NSTableViewDelegate, NSTableViewDataSource{
	var tableName  : String = "";
	var windowName : String = "";
	var tableView  : NSTableView = NSTableView();
	var session    : AMGReminderData = AMGReminderData();
	var objects    : [String] = [];
	var columns    : [String] = [];
	var scrollView : NSScrollView = NSScrollView();
	
	
	/// This is the common constructor
	///
	/// - Parameters:
	///   - frame2: Margin information for the window
	///   - session2: DBMS instance to grab the details from
	///   - table: Name of the table to grab the details from
	public init(frame2 : NSRect, session2 : AMGReminderData, table : String){
		super.init(contentRect: frame2, styleMask: [.closable, .borderless, .resizable, .titled], backing: .buffered, defer: false);
		session = session2;
		tableName = table;
		initializeComponents();
	}
	
	/// This is the full constructor
	///
	/// - Parameters:
	///   - frame2: Margin information for the window
	///   - session2: DBMS instance to grab the details from
	///   - table: Name of the table to grab the details from
	///   - window: Name of the window
	public init(frame2 : NSRect, session2 : AMGReminderData, table : String, window : String){
		super.init(contentRect: frame2, styleMask: [.closable, .borderless, .resizable, .titled], backing: .buffered, defer: false);
		session = session2;
		tableName = table;
		windowName = window;
		initializeComponents();
	}
	
	private func initializeComponents(){
		self.isRestorable = true;
		self.contentView?.wantsLayer = true;
		self.isReleasedWhenClosed = false;
		scrollView = NSScrollView(frame: CGRect(x: 0, y: 0, width: (self.contentView?.frame.size.width)!, height: (self.contentView?.frame.size.height)!));
		scrollView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable];
		scrollView.hasHorizontalScroller = true;
		scrollView.hasVerticalScroller = true;
		
		columns = session.getColumns(table: tableName);
		
		self.contentView = NSView();
		self.contentView?.wantsLayer = true;
		self.isReleasedWhenClosed = false;
		self.title = windowName;
		
		tableView = NSTableView(frame: CGRect(x: 0, y: 0, width: (self.contentView?.frame.size.width)!, height: (self.contentView?.frame.size.height)!));
		tableView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable];
		
		scrollView.documentView = tableView;
		
		for i in 0 ..< columns.count{
			let newCol : NSTableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(string: columns[i]) as String);
			newCol.width = 250;
			newCol.headerCell.title = columns[i].uppercased().replacingOccurrences(of: "_", with: " ");
			newCol.isEditable = false;
			tableView.addTableColumn(newCol);
			tableView.rowSizeStyle = .small;
			tableView.usesAlternatingRowBackgroundColors = true;
			tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle;
		}
		
		tableView.delegate = self;
		tableView.dataSource = self;
		self.contentView?.addSubview(scrollView);
		refresh();

	}
	
	/// This method will display the window
	public func show(){
		refresh();
		self.makeKeyAndOrderFront(self);
	}
	
	/// This method refreshes the errors in the view
	public func refresh(){
		objects = session.getRows(table: tableName);
		tableView.reloadData();
	}
	
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return objects.count;
	}
	
	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		return ((objects[row] as String).components(separatedBy: "<COL>") as [String])[tableView.column(withIdentifier: (tableColumn?.identifier)!)];
	}
	
	public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return true;
	}
	
	public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
		return false;
	}
}
