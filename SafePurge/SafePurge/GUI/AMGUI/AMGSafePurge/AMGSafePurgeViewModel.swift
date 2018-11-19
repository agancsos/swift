//
//  File.swift
//  SafePurge
//
//  Created by Abel Gancsos on 11/7/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGSafePurgeViewModel : NSView, NSTableViewDelegate, NSTableViewDataSource {
	var objects       : [AMGPurgeItem] = [];
	var grid          : NSTableView?   = nil;
	var gridContainer : NSScrollView   = NSScrollView();
	var session       : AMGSafePurge?  = nil;
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect);
		self.prepare();
	}
	
	init(frame : NSRect, session : AMGSafePurge) {
		super.init(frame: frame);
		self.session = session;
		prepare();
	}
	
	private func prepare() {
		self.gridContainer = NSScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
		self.gridContainer.autoresizingMask = [.width, .height];
		self.addSubview(self.gridContainer);
		self.addGrid();
		self.grid!.dataSource = self;
		self.grid!.delegate = self;
		if(self.session != nil) {
		}
	}
	
	private func addGrid() {
		self.grid = NSTableView(frame:
			CGRect(
				x: 0,
				y: 0,
				width: self.frame.size.height,
				height: self.frame.size.height));
		let column1 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "Path"));
		let column2 = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "Reason"));
		column1.title = "Path";
		column2.title = "Reason";
		self.grid!.addTableColumn(column1);
		self.grid!.addTableColumn(column2);
		self.grid!.usesAlternatingRowBackgroundColors = true;
		for column in self.grid!.tableColumns {
			column.width = self.frame.size.width / 2;
		}
		self.grid!.rowSizeStyle = .medium;
		self.gridContainer.documentView = self.grid!;
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return objects.count;
	}
	
	func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
		return false;
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let item : AMGPurgeItem = self.objects[row];
		var view = NSTextField(string: "");
		if(tableColumn!.identifier.rawValue == "Path"){
			view = NSTextField(string: item.getFullPath());
		}
		else if(tableColumn!.identifier.rawValue == "Reason") {
			view = NSTextField(string: item.getReason());
		}
		view.isBordered = true;
		view.backgroundColor = .clear;
		view.isEditable = false;
		view.isSelectable = true;
		return view;
	}
	
	/**
	 * Handlers
	 */
	@objc func refresh() {
		self.objects = self.session!.preview();
		self.grid!.reloadData();
	}
}
