//
//  AMGCommon.swift
//
//  Created by Abel Gancsos on 11/11/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGCommon {
	
	/// Prompt user for input
	///
	/// - Parameters:
	///   - prompt: Message to display in prompt
	///   - defaultValue: Default value to us in the prompt
	///   - frame: Size and location of the message box
	/// - Returns: New string value from the user input
	public static func input(prompt : String, defaultValue : String, frame: NSRect) -> String{
		let alert : NSAlert = NSAlert();
		alert.messageText = prompt;
		alert.alertStyle = .informational;
		alert.addButton(withTitle: "OK");
		alert.addButton(withTitle: "Cancel");
		
		let input : NSTextField = NSTextField(frame: frame);
		input.stringValue = defaultValue;
		alert.accessoryView = input;
		input.needsUpdateConstraints = false;
		let button = alert.runModal();
		if(button == .OK){
			input.validateEditing();
			return input.stringValue;
		}
		return "";
	}
	
	/// Displays a popup message
	///
	/// - Parameters:
	///   - message: Message to display
	///   - title: Title for message box
	///   - fontSize: Size of the text
	public static func alert(message : String,title : String, fontSize : CGFloat){
		let alert : NSAlert = NSAlert();
		alert.window.title = title ;
		alert.messageText = "";
		alert.informativeText = message ;
		alert.alertStyle = NSAlert.Style.warning;
		alert.addButton(withTitle: "Close");
		let views : [NSView] = alert.window.contentView!.subviews;
		let titleFont : NSFont = NSFont(name: "Arial", size: fontSize + 1)!;
		let font : NSFont = NSFont(name: "Arial", size: fontSize)!;
		(views[4] as! NSTextField).font = titleFont;
		(views[5] as! NSTextField).font = font;
		alert.runModal();
	}
	
	/// Runs a command on the system
	///
	/// - Parameters:
	///   - path: Path to command to run
	///   - params: Parameters to pass along to the command
	/// - Returns: Standard output of the command
	public static func runCMD(path : String, params : NSArray) -> String{
		var mfinal : String = "";
		if(FileManager.default.fileExists(atPath: path )){
			let proc : Process = Process();
			proc.launchPath = path ;
			proc.arguments = params as? [String];
			let socket : Pipe = Pipe();
			proc.standardOutput = socket;
			proc.launch();
			proc.waitUntilExit();
			let reader : FileHandle = socket.fileHandleForReading;
			let raw : Data = reader.readDataToEndOfFile();
			mfinal = String(data: raw, encoding: String.Encoding.utf8)!;
		}
		return mfinal;
	}
	
	public static func clearSubViews(view : NSView) {
		for view in view.subviews {
			view.removeFromSuperview();
		}
	}
	
	public static func changeApplicationView(view : NSView) {
		let mainViewController : AMGBaseViewController = (NSApplication.shared.keyWindow?.contentViewController as! AMGBaseViewController);
		let applicationView    : NSView = mainViewController.applicationView;
		clearSubViews(view: applicationView);
		applicationView.addSubview(view);
	}
}
