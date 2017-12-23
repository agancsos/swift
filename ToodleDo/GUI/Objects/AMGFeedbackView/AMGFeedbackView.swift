//
//  AMGFeedbackView.swift
//
//  Created by Abel Gancsos on 9/1/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps the user provide feedback to the developer
class AMGFeedbackView : NSWindow{
    
    var apiBase  : String = "http://www.abelgancsos.com:1137/API/feedback.php";
    var apiAdd   : String = "";
    var inputView: NSTextView = NSTextView();
    
    
    /// This is the default constructor for the view
    ///
    /// - Parameter frame: Margin information for the new view
    public init(frame : NSRect){
        super.init(contentRect: frame, styleMask: [.borderless,.titled,.closable], backing: .retained, defer: true);
        initializeComponents();
        self.title = "Feedback";
        self.autorecalculatesKeyViewLoop = true;
    }
    
    
    /// This method sets up all the objects for the view
    private func initializeComponents(){
        //self.contentView = NSView();
        apiAdd = String(format: "%@?m=add&a=%@&t=",apiBase,(Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!);
        initializeTextInput();
        initializeButtons();
    }
    
    
    /// This method sets up the input field
    private func initializeTextInput(){
        //(self.contentView?.frame.size.height)! / 3
        inputView = NSTextView(frame:NSRect(x: 0, y: 40,
											width: (self.contentView?.frame.size.width)!, height: (self.contentView?.frame.size.height)! / 2 + 60));
        
        inputView.autoresizingMask = [.viewWidthSizable];
        inputView.backgroundColor = NSColor.white;
        self.contentView?.addSubview(inputView);
    }
    
    
    /// This method sets up the buttons for the view
    private func initializeButtons(){
        let cancelButton : NSButton = NSButton(frame: NSRect(x: 0, y: 0, width: self.contentView!.frame.size.width / 2, height: 40));
        cancelButton.autoresizingMask = [.viewHeightSizable, .viewWidthSizable];
        cancelButton.title = "Cancel";
        cancelButton.target = self;
        cancelButton.isBordered = true;
        if(AMGRegistry().getValue(key: "GUI.Buttons.Borders") == "0"){
            cancelButton.isBordered = false;
        }
        cancelButton.action = #selector(cancel);
        self.contentView?.addSubview(cancelButton);

        let submitButton : NSButton = NSButton(frame: NSRect(x: cancelButton.frame.size.width, y: cancelButton.frame.origin.y, width: self.contentView!.frame.size.width / 2, height: 40));
        submitButton.autoresizingMask = [.viewHeightSizable, .viewWidthSizable];
        submitButton.title = "Submit";
        submitButton.target = self;
        submitButton.isBordered = true;
        if(AMGRegistry().getValue(key: "GUI.Buttons.Borders") == "0"){
            submitButton.isBordered = false;
        }
        submitButton.action = #selector(submitFeedback);
        self.contentView?.addSubview(submitButton);
    }
    
    /// This method will submit the feedback
    public func submitFeedback(){
        var result : String = "";
        if(AMGCommon().server(domain: apiBase)){
            do{
                try result = String(contentsOf: URL(string: String(format: "%@%@",apiAdd,AMGCommon().urlEncode(text: inputView.string!)))!, encoding: String.Encoding.isoLatin2);
                if(result == "SUCCESS"){
                    if(AMGRegistry().getValue(key: "Silent") != "1"){
                        AMGCommon().alert(message: "Feedback has been submitted", title: "SUCCESS", fontSize: 13);
						self.close();
                    }
                }
            }
            catch{
                
            }
        }
    }
    
    public func cancel(){
        self.close();
    }
    
    /// This method will display the view
    public func show(){
        self.makeKeyAndOrderFront(self);
    }
}
