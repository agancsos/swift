//
//  AMGRemindersView.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/3/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps display and manage reminders from the database
class AMGRemindersView : NSSplitView, NSSplitViewDelegate{
	public var session        : AMGReminderData = AMGReminderData();
	public var list           : AMGListView = AMGListView();
	public var property       : AMGPropertyView = AMGPropertyView();
	public var currentList    : AMGList = AMGList();
	public var currentReminder: AMGReminder = AMGReminder();
	
	public init(frame : CGRect, session2 : AMGReminderData){
		super.init(frame: frame);
		session = session2;
		initializeComponents();
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// This method relaods the data in this view
	public func refreshView(){
		list.refresh();
		property.refreshAll();
	}
	
	private func initializeComponents(){
		initializeMain();
		initializeListView();
		initializePropertyView();
		currentList = AMGList(n: "/", id2: "0", pid2: "-1");
	}
	
	private func initializeMain(){
		self.autoresizingMask = [.viewWidthSizable, .viewHeightSizable];
		self.addSubview(NSScrollView());
		self.addSubview(NSScrollView());
		self.setPosition(120, ofDividerAt: 0);
		self.setPosition(120, ofDividerAt: 0);
		self.isVertical = true;
		self.layer?.backgroundColor = NSColor.clear.cgColor;
		self.layer?.borderWidth = 3.0;
		initializePanes();
	}
	
	private func initializeListView(){
		list = AMGListView(frame2: self.frame, session2: session);
		list.autoresizingMask = [.viewHeightSizable,.viewWidthSizable];
		(self.subviews[0] as! NSScrollView).documentView = list;
	}
	
	private func initializePropertyView(){
		property = AMGPropertyView(frame: self.frame, session2: session);
		property.autoresizingMask = [.viewHeightSizable,.viewWidthSizable];
		(self.subviews[1] as! NSScrollView).documentView = property;
		(self.subviews[1] as! NSScrollView).documentView?.scroll(NSMakePoint(0, property.frame.size.height));
	}
	
	private func initializePanes(){
		for view in self.subviews{
			(view as! NSScrollView).backgroundColor = NSColor.clear;
			(view as! NSScrollView).alphaValue = 0.65;
		}
	}
}
