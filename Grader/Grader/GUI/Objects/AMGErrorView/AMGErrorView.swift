//
//  AMGErrorView.swift
//
//  Created by Abel Gancsos on 9/9/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps display error messages
class AMGErrorView : NSWindow, NSTableViewDelegate, NSTableViewDataSource{
    var errorTable : String = "error_log";
    var tableView  : NSTableView = NSTableView();
    var session    : AMGGrader = AMGGrader();
    var objects    : [String] = [];
    var columns    : [String] = [];
    var scrollView : NSScrollView = NSScrollView();
    
    
    /// This is the primary constructor
    ///
    /// - Parameters:
    ///   - frame2: Margin information for the window
    ///   - session2: Custom object session where the errors are being held
    public init(frame2 : CGRect, session2 : AMGGrader ){
        super.init(contentRect: frame2, styleMask: [.titled,.closable,.borderless,.resizable], backing: .retained, defer: false);
        session = session2;
        errorTable = "error_log";
        initializeComponents();
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameters:
    ///   - frame2: Margin information for the window
    ///   - session2: Custom object session where the errors are being held
    ///   - table: Error log table
    public init(frame2 : CGRect, session2 : AMGGrader , table : String){
        super.init(contentRect: frame2, styleMask: [.titled,.closable,.borderless,.resizable], backing: .retained, defer: false);
        session = session2;
        errorTable = table;
        initializeComponents();
    }
    
	/// This is the default constructor
    public init(){
        super.init(contentRect: CGRect(x: 0, y: 0, width: 800, height: 600), styleMask: [.titled,.closable,.borderless,.resizable], backing: .retained, defer: false);
        errorTable = "error_log";
        initializeComponents();
    }
    
    /// This method sets up the view with the needed objects
    public func initializeComponents(){
        scrollView = NSScrollView(frame: CGRect(x: 0, y: 0, width: (self.contentView?.frame.size.width)!, height: (self.contentView?.frame.size.height)!));
        scrollView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable];
        scrollView.hasHorizontalScroller = true;
        scrollView.hasVerticalScroller = true;
        
        columns = session.getErrorColumns();
        
        self.contentView = NSView();
        self.contentView?.wantsLayer = true;
        self.isReleasedWhenClosed = false;
        self.title = "Error Log";
        
        tableView = NSTableView(frame: CGRect(x: 0, y: 0, width: (self.contentView?.frame.size.width)!, height: (self.contentView?.frame.size.height)!));
        tableView.autoresizingMask = [.viewHeightSizable, .viewWidthSizable];
        
        scrollView.documentView = tableView;
        
        for i in 0 ..< columns.count{
            let newCol : NSTableColumn = NSTableColumn(identifier: columns[i]);
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
    
    /// This method refreshes the errors in the view
    public func refresh(){
        objects = session.getErrors();
        tableView.reloadData();
    }
    
    /// This method displays the window
    public func show(){
        refresh();
        self.makeKeyAndOrderFront(self);
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
