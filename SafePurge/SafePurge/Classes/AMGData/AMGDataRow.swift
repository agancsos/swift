//
//  AMGDataRow.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/2/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGDataRow {
    private var rowIndex   : Int = 0;
    private var rowColumns : [AMGDataColumn] = [];
    
    
    /// This is the default constructor
    init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter columns: Columns
    init(columns : [AMGDataColumn]) {
        self.rowIndex = self.rowColumns.count + 1;
        self.rowColumns = columns;
    }
    
    
    /// This is the full constructor
    ///
    /// - Parameters:
    ///   - index: Row index
    ///   - columns: Row columns
    init(index : Int, columns : [AMGDataColumn]) {
        self.rowIndex = index;
        self.rowColumns = columns;
    }
    
    public func getRowIndex() -> Int {
        return self.rowIndex;
    }
    
    public func getRowColumns() -> [AMGDataColumn] {
        return self.rowColumns;
    }
    
    
    /// This method helps build the row by adding a new column
    ///
    /// - Parameter column: Column
    public func addColumn(column : AMGDataColumn) {
        self.rowColumns.append(column);
    }
}
