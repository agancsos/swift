//
//  AMGPreferenceWindowViewModel.swift
//
//  Created by Abel Gancsos on 11/11/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGPreferenceWindowViewModel : NSWindow {
	var model            : AMGPreferenceWindowModel = AMGPreferenceWindowModel();
	var fieldLabelHeight : CGFloat = 30;
	var fieldLabelSpacing: CGFloat = 10;
	var inputFields      : [AnyObject] = [];
	var inputLabels      : [AMGLabel] = [];
	
	init() {
		super.init(contentRect: CGRect(x: 0, y: 0, width: 0, height: 0),
				   styleMask: .borderless, backing: .buffered, defer: false);
		self.prepare();
	}
	
	override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask,
				  backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag);
		self.prepare();
	}
	
	private func prepare() {
		self.title = "Preferences";
		self.generateFields();
		self.placeFields();
	}
	
	private func generateFields() {
		var index : Int = 0;
		for setting in self.model.settings {
			var originY = (self.contentView!.frame.size.height - (self.fieldLabelHeight * CGFloat(index) + self.fieldLabelHeight));
			if(index > 0) {
				originY -= self.fieldLabelSpacing;
			}
			let newLabel = AMGLabel(frame:
				CGRect(
					x: 0,
					y: originY,
					width: self.contentView!.frame.size.width / 2,
					height: self.fieldLabelHeight));
			newLabel.stringValue = setting.label;
			newLabel.isBordered = true;
			newLabel.autoresizingMask = [.width, .maxXMargin, .minYMargin];
			self.inputLabels.append(newLabel);
			var newInput : NSView? = nil;
			switch(setting.type) {
				case .SWITCH:
					newInput = NSSegmentedControl(
						labels: setting.options,
						trackingMode: .selectOne,
						target: self,
						action: #selector(updateField(sender:)));
					newInput!.frame = CGRect(x: newLabel.frame.origin.x + newLabel.frame.size.width,
										   y: newLabel.frame.origin.y,
										   width: newLabel.frame.size.width, height: self.fieldLabelHeight);
					(newInput as! NSSegmentedControl).selectSegment(withTag: Int(self.model.registry.lookupKey(key: setting.name)) ?? 0);
					(newInput as! NSSegmentedControl).identifier = NSUserInterfaceItemIdentifier(rawValue: setting.name);
					break;
				case .TEXT_FIELD:
					newInput = NSTextField(frame:
						CGRect(x: newLabel.frame.origin.x + newLabel.frame.size.width,
							   y: newLabel.frame.origin.y,
							   width: newLabel.frame.size.width, height: self.fieldLabelHeight));
					(newInput as! NSTextField).placeholderString = setting.placeholder;
					(newInput as! NSTextField).target = self;
					(newInput as! NSTextField).action = #selector(updateField(sender:));
					(newInput as! NSTextField).stringValue = self.model.registry.lookupKey(key: setting.name);
					break;
				default:
					break;
			}
			newInput!.identifier = NSUserInterfaceItemIdentifier(rawValue: setting.name);
			newInput!.autoresizingMask = [.width, .minXMargin, .minYMargin];
			self.inputFields.append(newInput!);
			index += 1;
		}
	}
	
	private func placeFields() {
		for cursor in 0 ..< self.inputLabels.count {
			self.contentView?.addSubview(self.inputLabels[cursor]);
			if(cursor < self.inputFields.count) {
				switch(self.model.settings[cursor].type) {
					case .SWITCH:
						self.contentView?.addSubview(self.inputFields[cursor] as! NSSegmentedControl);
						break;
					case .TEXT_FIELD:
						self.contentView?.addSubview(self.inputFields[cursor] as! NSTextField);
						break;
					case .TEXT_VIEW:
						self.contentView?.addSubview(self.inputFields[cursor] as! NSTextView);
						break;
					default:
						break;
				}
			}
		}
	}
	
	public func show() {
		for cursor in self.inputFields{
			let setting = self.model.findSetting(name: cursor.identifier!);
			switch(setting.type) {
				case .TEXT_FIELD:
					(cursor as! NSTextField).stringValue = self.model.registry.lookupKey(key: setting.name);
					break;
				case .SWITCH:
					break;
				default:
					break;
			}
		}
		self.makeKeyAndOrderFront(self);
	}
	
	/**
	 * Handlers
	 */
	@objc func updateField(sender : AnyObject?) {
		var newValue : String = "";
		let setting = self.model.findSetting(name: sender!.identifier);
		switch(setting.type) {
			case .TEXT_FIELD:
				newValue = (sender! as! NSTextField).stringValue;
				break;
			case .SWITCH:
				newValue = String((sender! as! NSSegmentedControl).selectedSegment);
			default:
				break;
		}
		NSLog(newValue);
		self.model.registry.writeKey(key: sender!.identifier!, value: newValue);
	}
}
