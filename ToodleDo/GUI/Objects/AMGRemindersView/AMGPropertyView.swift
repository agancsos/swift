//
//  AMGPropertyView.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/8/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGPropertyView : NSView{
	public var session         : AMGReminderData = AMGReminderData();
	public var currentReminder : AMGReminder? = nil;
	public var labelNames      : [String] = [];
	public var labelHeight     : CGFloat = 30.0;
	
	public init(){
		super.init(frame: NSMakeRect(0, 0, 0, 0));
		initializeComponents();
	}
	
	public init(frame : CGRect, session2 : AMGReminderData){
		super.init(frame: frame);
		session = session2;
		initializeComponents();
	}
	
	required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func clearAll(){
		session.audit(action: "GUI", msg: "Clearing values in property fields");
			var index : Int = 0;
			for view in self.subviews{
				if((view.className.contains("AMGLabel")) || (view.className.contains("NSTextField"))){
					if(index < labelNames.count){
						if(currentReminder != nil){
							if((view.className.contains("AMGLabel"))){
								if((view as? AMGLabel)?.placeholderString != nil){
									(view as! AMGLabel).stringValue = "";
									index += 1;
								}
							}
							else{
								if((view as? NSTextField)?.placeholderString != nil){
									(view as! NSTextField).stringValue = "";
									index += 1;
								}
							}
						}
					}
				}
			}
	}
	
	public func refreshAll(){
		session.audit(action: "GUI", msg: "Reloading values in property fields");
		if(currentReminder != nil){
			var index : Int = 0;
			for view in self.subviews{
				if((view.className.contains("AMGLabel")) || (view.className.contains("NSTextField"))){
					if(index < labelNames.count){
						if(currentReminder != nil){
							if((view.className.contains("AMGLabel"))){
								if((view as? AMGLabel)?.placeholderString != nil){
									(view as! AMGLabel).stringValue = (currentReminder?.getValue(key: labelNames[index]))!;
									index += 1;
								}
							}
							else{
								if((view as? NSTextField)?.placeholderString != nil){
									(view as! NSTextField).stringValue = (currentReminder?.getValue(key: labelNames[index]))!;
									index += 1;
								}
							}
						}
					}
				}
			}
		}
	}
	
	private func reloadObject(){
		currentReminder = session.getReminder(id: (currentReminder?.id)!);
		refreshAll();
	}
	
	private func initializeComponents(){
		session.audit(action: "GUI", msg: "Building property pane");
		labelNames = session.getReminderLabels();
		initializeLabels();
		initializeFields();
		refreshAll();
	}
	
	private func initializeLabels(){
		session.audit(action: "GUI", msg: "Building property labels");
		var index : Int = 0;
		for label in labelNames{
			let tempLabel : AMGLabel = AMGLabel(frame: NSMakeRect(0, (NSApp.mainWindow?.contentView!.frame.size.height)! - (CGFloat(index) * labelHeight + 40),
								     self.frame.size.width / 2, labelHeight),
									 msg: label.replacingOccurrences(of: "_", with: " ").uppercased());
			tempLabel.isBordered = true;
			tempLabel.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin];
			tempLabel.layer?.borderColor = NSColor.black.cgColor;
			tempLabel.layer?.borderWidth = 3.0;
			self.addSubview(tempLabel);
			index += 1;
		}
	}
	
	private func initializeFields(){
		session.audit(action: "GUI", msg: "Building property fields");
		var index : Int = 0;
		for label in labelNames{
			if(label.lowercased().replacingOccurrences(of: "reminder_", with: "") == "description"){
				let tempLabel : NSTextField = NSTextField(frame: NSMakeRect(self.frame.size.width / 2,
							(NSApp.mainWindow?.contentView!.frame.size.height)! - (CGFloat(index) * labelHeight + 40.0),
							self.frame.size.width / 2,labelHeight));
				tempLabel.placeholderString = label.replacingOccurrences(of: "_", with: " ").uppercased();
				tempLabel.isBordered = true;
				tempLabel.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin];
				tempLabel.tag = index;
				tempLabel.target = self;
				tempLabel.action = #selector(updateDescription);
				tempLabel.layer?.borderColor = NSColor.black.cgColor;
				tempLabel.layer?.borderWidth = 3.0;
				self.addSubview(tempLabel);
			}
			else if(label.lowercased().replacingOccurrences(of: "reminder_", with: "") == "summary"){
				let tempLabel : NSTextField = NSTextField(frame: NSMakeRect(self.frame.size.width / 2,
							(NSApp.mainWindow?.contentView!.frame.size.height)! - (CGFloat(index) * labelHeight + 40.0),
							self.frame.size.width / 2,labelHeight));
				tempLabel.placeholderString = label.replacingOccurrences(of: "_", with: " ").uppercased();
				tempLabel.isBordered = true;
				tempLabel.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin];
				tempLabel.layer?.borderColor = NSColor.black.cgColor;
				tempLabel.layer?.borderWidth = 3.0;
				tempLabel.target = self;
				tempLabel.action = #selector(updateSummary);
				tempLabel.tag = index;
				self.addSubview(tempLabel);
			}
			else if(label.lowercased().replacingOccurrences(of: "reminder_", with: "") == "priority"){
				let tempLabel : NSTextField = NSTextField(frame: NSMakeRect(self.frame.size.width / 2,
																			(NSApp.mainWindow?.contentView!.frame.size.height)! - (CGFloat(index) * labelHeight + 40.0),
																			self.frame.size.width / 2,labelHeight));
				tempLabel.placeholderString = label.replacingOccurrences(of: "_", with: " ").uppercased();
				tempLabel.isBordered = true;
				tempLabel.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin];
				tempLabel.layer?.borderColor = NSColor.black.cgColor;
				tempLabel.layer?.borderWidth = 3.0;
				tempLabel.target = self;
				tempLabel.action = #selector(updatePriority);
				tempLabel.tag = index;
				self.addSubview(tempLabel);
			}
			else if(label.lowercased().replacingOccurrences(of: "reminder_", with: "") == "status"){
				let tempLabel : NSTextField = NSTextField(frame: NSMakeRect(self.frame.size.width / 2,
																			(NSApp.mainWindow?.contentView!.frame.size.height)! - (CGFloat(index) * labelHeight + 40.0),
																			self.frame.size.width / 2,labelHeight));
				tempLabel.placeholderString = label.replacingOccurrences(of: "_", with: " ").uppercased();
				tempLabel.isBordered = true;
				tempLabel.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin];
				tempLabel.layer?.borderColor = NSColor.black.cgColor;
				tempLabel.layer?.borderWidth = 3.0;
				tempLabel.target = self;
				tempLabel.action = #selector(updateStatus);
				tempLabel.tag = index;
				self.addSubview(tempLabel);
			}
			else{
				let tempLabel : AMGLabel = AMGLabel(frame: NSMakeRect(self.frame.size.width / 2,
										(NSApp.mainWindow?.contentView!.frame.size.height)! - (CGFloat(index) * labelHeight + 40),
										self.frame.size.width / 2, labelHeight),
													msg: "");
				tempLabel.isBordered = true;
				tempLabel.autoresizingMask = [.viewMinYMargin,.viewMaxXMargin];
				tempLabel.placeholderString = label.replacingOccurrences(of: "_", with: " ").uppercased();
				tempLabel.layer?.borderColor = NSColor.black.cgColor;
				tempLabel.layer?.borderWidth = 3.0;
				self.addSubview(tempLabel);

			}
			index += 1;
		}
	}
	
	private func getValue(field : String) -> String{
		for view in self.subviews{
			if((view as? NSTextField) != nil && (view as? AMGLabel) == nil){
				if((view as! NSTextField).placeholderString?.lowercased().contains(field))!{
					return (view as! NSTextField).stringValue;
				}
			}
		}
		return "";
	}
	
	public func updateSummary(){
		if(!session.updateSummary(reminder: currentReminder!, value: getValue(field:"summary"))){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Failed to update reminder summary", title: "Error 1139", fontSize: 13);
			}
		}
		else{
			if(AMGRegistry().getValue(key: "Verbose") == "1"){
				AMGCommon().alert(message: "Updated summary", title: "Success", fontSize: 13);
			}
		}
		reloadObject();
	}
	
	public func updateDescription(){
		if(!session.updateDescription(reminder: currentReminder!, value: getValue(field:"description"))){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Failed to update reminder description", title: "Error 1139", fontSize: 13);
			}
		}
		else{
			if(AMGRegistry().getValue(key: "Verbose") == "1"){
				AMGCommon().alert(message: "Updated description", title: "Success", fontSize: 13);
			}
		}
		reloadObject();
	}
	
	public func updatePriority(){
		if(!session.updatePriority(reminder: currentReminder!, value: getValue(field:"priority"))){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Failed to update reminder priority", title: "Error 1139", fontSize: 13);
			}
		}
		else{
			if(AMGRegistry().getValue(key: "Verbose") == "1"){
				AMGCommon().alert(message: "Updated priority", title: "Success", fontSize: 13);
			}
		}
		reloadObject();
	}
	
	public func updateStatus(){
		if(!session.updateStatus(reminder: currentReminder!, value: getValue(field:"status"))){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				AMGCommon().alert(message: "Failed to update reminder status", title: "Error 1139", fontSize: 13);
			}
		}
		else{
			if(AMGRegistry().getValue(key: "Verbose") == "1"){
				AMGCommon().alert(message: "Updated status", title: "Success", fontSize: 13);
			}
		}
		reloadObject();
	}
}
