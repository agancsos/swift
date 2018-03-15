//
//  AMGTableView.swift
//
//  Created by Abel Gancsos on 3/5/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGTableView : NSTableView,NSTableViewDelegate,NSTableViewDataSource {
    
    var tableName     : String = "";
    var objects       : [String] = [];
    var columns       : [String] = [];
    
    public init(){
        super.init(frame: NSMakeRect(0, 0, 0, 0));
        initializeComponents();
    }
    
    public init(frame2 : CGRect, table : String){
        super.init(frame: frame2);
        tableName = table;
        initializeComponents();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func clearColumns(){
        while(self.tableColumns.count > 0){
            self.removeTableColumn(self.tableColumns.last!);
        }
    }

    private func initializeComponents(){
        drawTable();
        self.backgroundColor = NSColor.clear;
        if(AMGRegistry().getValue(key: "GUI.TableView.Backcolor") != ""){
            self.backgroundColor = AMGColor().make(raw: AMGRegistry().getValue(key: "GUI.TableView.Backcolor"));
        }
        self.dataSource = self;
        self.delegate = self;
    }
    
    private func drawTable(){
        clearColumns();
        self.gridStyleMask = [.solidVerticalGridLineMask, .dashedHorizontalGridLineMask];
        for i in 0 ..< columns.count{
            let newCol : NSTableColumn = NSTableColumn(identifier: columns[i]);
            newCol.width = 250;
            newCol.headerCell.title = columns[i].uppercased();
            newCol.isEditable = false;
            self.addTableColumn(newCol);
            self.rowSizeStyle = .small;
            self.usesAlternatingRowBackgroundColors = true;
            self.columnAutoresizingStyle = .uniformColumnAutoresizingStyle;
        }
    }
    
    // Table delegates
    public func numberOfRows(in tableView: NSTableView) -> Int {
        let rawView : NSView = NSApp.windows[0].contentView!;
        if(rawView.subviews.count > 3){
            (rawView.subviews[1] as! AMGLabel).stringValue = String(format: "Rows: %d",objects.count);
        }
        return objects.count;
    }
    
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if(self.tableColumns.index(of: tableColumn!)! < columns.count){
                return ((objects[row].components(separatedBy: "<COL>") as [String])[tableView.column(withIdentifier: (tableColumn?.identifier)!)]);
        }
        return "";
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true;
    }
    
    public func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        return false;
    }

    public func refreshView(){
        drawTable();
        reloadData();
    }
}
