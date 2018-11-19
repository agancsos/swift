//
//  AMGDataTable.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/2/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGDataTable {
    private var tableName : String = "";
    private var tableRows : [AMGDataRow] = [];
    
    
    /// This is the default constructor
    init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter rows: Rows
    init(rows : [AMGDataRow]) {
        self.tableRows = rows;
    }
    
    
    /// This is the full constructor
    ///
    /// - Parameters:
    ///   - name: Name of the table
    ///   - rows: Rows in the table
    init(name : String, rows : [AMGDataRow]) {
        self.tableName = name;
        self.tableRows = rows;
    }
    
    public func getTableName() -> String {
        return self.tableName;
    }
    
    public func getTableRows() -> [AMGDataRow] {
        return self.tableRows;
    }
    
    
    /// This method adds a new row to the table
    ///
    /// - Parameter row: Row to add
    public func addRow(row : AMGDataRow) {
        self.tableRows.append(row);
    }
}
