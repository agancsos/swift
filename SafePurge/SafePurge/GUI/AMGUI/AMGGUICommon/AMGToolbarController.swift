//
//  AMGToolbarController.swift
//
//  Created by Abel Gancsos on 11/11/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGToolbarController {
	var toolbar          : NSMenu? = nil;
	var preferenceWindow : AMGPreferenceWindowViewModel = AMGPreferenceWindowViewModel();
	var feedbackWindow   : AMGFeedbackViewModel = AMGFeedbackViewModel();
	
	init() {
		
	}
	
	init(toolbar : NSMenu) {
		self.toolbar = toolbar;
	}
	
	private func findMenuItem(withName : String, menu : NSMenu) -> NSMenuItem? {
		for menuItem in menu.items {
			if(menuItem.title.contains(withName)) {
				return menuItem;
			}
			if(menuItem.hasSubmenu) {
				return findMenuItem(withName: withName, menu: menuItem.submenu!);
			}
		}
		return nil;
	}
	
	private func disableAbout() {
		let aboutMenuItem = findMenuItem(withName: "About", menu: self.toolbar!);
		if(aboutMenuItem != nil) {
			aboutMenuItem?.action = nil;
		}
	}
	
	private func redirectPreferences() {
		self.preferenceWindow = AMGPreferenceWindowViewModel(contentRect:
			CGRect(x: 200, y: 200, width: 600, height: 400),
			styleMask: [.closable, .titled, .borderless],
			backing: .buffered, defer: false);
		let preferencesMenuItem = findMenuItem(withName: "Preferences", menu: self.toolbar!);
		if(preferencesMenuItem != nil) {
			preferencesMenuItem?.target = self;
			preferencesMenuItem?.action = #selector(showPreferences);
			preferencesMenuItem?.title = "Preferences";
		}
	}
	
	private func setFeedbackItem() {
		self.feedbackWindow = AMGFeedbackViewModel(contentRect:
			CGRect(x: 200, y: 200, width: 600, height: 400),
			styleMask: [.closable, .titled, .borderless], backing: .buffered, defer: false);
		let feedbackMenuItem = NSMenuItem(title: "Feedback", action: #selector(showFeedback), keyEquivalent: "");
		feedbackMenuItem.target = self;
		self.toolbar!.item(withTitle: "Window")?.submenu?.addItem(feedbackMenuItem);
	}
	
	private func setRefresh() {
		let refreshMenuItem = NSMenuItem(title: "Refresh", action: #selector(refresh), keyEquivalent: "r");
		refreshMenuItem.keyEquivalentModifierMask = [.command, .shift];
		refreshMenuItem.target = self;
		self.toolbar!.item(withTitle: "Window")?.submenu?.addItem(refreshMenuItem);
	}
	
	private func addPurgeItem() {
		let purgeMenuItem = NSMenuItem(title: "Purge", action: #selector(purgeEx), keyEquivalent: "k");
		purgeMenuItem.keyEquivalentModifierMask = [.command, .shift];
		purgeMenuItem.target = self;
		self.toolbar!.item(withTitle: "Window")?.submenu?.addItem(purgeMenuItem);
	}

	public func prepare() {
		self.disableAbout();
		self.redirectPreferences();
		self.setFeedbackItem();
		self.setRefresh();
		self.addPurgeItem();
	}

	/**
	 * Menu Item Events
	 * These events are meant to only instantiate the actual event accordingly
	 */
	
	@objc func showPreferences() {
		self.preferenceWindow.show();
	}
	
	@objc func showFeedback() {
		self.feedbackWindow.show();
	}
	
	@objc func refresh() {
		let mainViewController : AMGBaseViewController = (NSApplication.shared.keyWindow?.contentViewController as! AMGBaseViewController);
		let applicationView    : NSView = mainViewController.applicationView;
		(applicationView.subviews[0] as! AMGSafePurgeViewModel).refresh();
	}
	
	@objc func purgeEx() {
		let mainViewController : AMGBaseViewController = (NSApplication.shared.keyWindow?.contentViewController as! AMGBaseViewController);
		let applicationView    : NSView = mainViewController.applicationView;
		(applicationView.subviews[0] as! AMGSafePurgeViewModel).session!.purge();
	}
}
