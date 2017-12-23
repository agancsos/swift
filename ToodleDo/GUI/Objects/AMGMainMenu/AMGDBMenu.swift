//
//  AMGDBMenu.swift
//  DBMS
//
//  Created by Abel Gancsos on 11/4/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGDBMenu : NSMenuItem{
	private var session : AMGReminderData = AMGReminderData();
	var subs : [NSMenuItem] = [];
	
	public init(){
		super.init(title: "", action: nil, keyEquivalent: "");
		initializeComponent();
	}
	
	public init(title : String){
		super.init(title: title, action: nil, keyEquivalent: "");
		initializeComponent();
	}
	
	public init(title : String, session2 : AMGDBMS){
		super.init(title: title, action: nil, keyEquivalent: "");
		session = session2;
		initializeComponent();
	}
	
	public init(title : String, session2 : AMGDBMS,act : Selector){
		super.init(title: title, action: act, keyEquivalent: "");
		session = session2;
		initializeComponent();
	}
	
	private func clearItems(){
		while((self.submenu?.items.count)! > 0){
			self.submenu?.removeItem((self.submenu?.items.last)!);
		}
	}
	
	private func buildItems(){
		clearItems();
		for index in 0 ..< subs.count{
			submenu?.addItem(subs[index]);
		}
	}
	
	public func refresh(){
		buildItems();
	}
	
	private func initializeComponent(){
		self.submenu = NSMenu(title: self.title);
	}
	
	required init(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
