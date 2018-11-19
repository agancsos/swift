//
//  AMGBaseViewController.swift
//
//  Created by Abel Gancsos on 11/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGBaseViewController : ViewController {
	private var session        : AMGSafePurge = AMGSafePurge();
	public var copyrightLabel  : AMGLabel = AMGLabel();
	public var versionLabel    : AMGLabel = AMGLabel();
	public var applicationView : NSView   = NSView();
	
	override func viewDidAppear() {
		super.viewDidAppear();
		prepare();
	}
	
	private func setCopyrightLabel() {
		self.copyrightLabel = AMGLabel(frame: CGRect(
			x: 0,
			y: 0,
			width: self.view.frame.size.width / 2,
			height: 20));
		self.copyrightLabel.autoresizingMask = [.width];
		self.copyrightLabel.stringValue = String(format: "(c) %d Abel Gancsos Productions", Calendar.current.component(.year, from: Date()));
		self.copyrightLabel.font = NSFont(name: SR.defaultLabelFontName, size: CGFloat(SR.defaultLabelFontSize));
		self.copyrightLabel.textColor = .white;
		self.view.addSubview(self.copyrightLabel);
	}
	
	private func setVersionLabel() {
		self.versionLabel = AMGLabel(frame: CGRect(
			x: self.copyrightLabel.frame.origin.x + self.copyrightLabel.frame.size.width,
			y: self.copyrightLabel.frame.origin.y,
			width: self.view.frame.size.width / 2,
			height: 20));
		self.versionLabel.autoresizingMask = [.width, .minXMargin];
		self.versionLabel.stringValue = String(format: "v. %@", AMGSystem().getVersion().version());
		self.versionLabel.font = NSFont(name: SR.defaultLabelFontName, size: CGFloat(SR.defaultLabelFontSize));
		self.versionLabel.alignment = .right;
		self.versionLabel.textColor = .white;
		self.view.addSubview(self.versionLabel);
	}
	
	private func addApplicationView() {
		self.applicationView = NSView(frame: CGRect(
			x: 0,
			y: self.copyrightLabel.frame.origin.y + self.copyrightLabel.frame.size.height,
			width: self.view.frame.size.width,
			height: self.view.frame.size.height - (self.copyrightLabel.frame.origin.y + self.copyrightLabel.frame.size.height)));
		self.applicationView.autoresizingMask = [.height, .width];
		self.applicationView.wantsLayer = true;
		self.view.addSubview(self.applicationView);
	}
	
	private func disableMenuItems() {
		for item : NSToolbarItem in self.view.window?.toolbar?.visibleItems ?? [] {
			NSLog(item.label)
		}
	}
	
	private func prepare() {
		self.view.window?.title = ((Bundle.main.infoDictionary!["CFBundleName"]) as! String);
		self.setCopyrightLabel();
		self.setVersionLabel();
		self.addApplicationView();
		self.disableMenuItems();
		let purgeViewModel = AMGSafePurgeViewModel(frame:
			CGRect(
				x: 0,
				y: 0,
				width: self.applicationView.frame.size.width,
				height: self.applicationView.frame.size.height),
												   session: self.session);
		purgeViewModel.autoresizingMask = [.width, .height];
		self.applicationView.addSubview(purgeViewModel);
	}
}
