//
//  AMGDataColumn.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/2/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGDataColumn {
    private var columnName  : String = "";
    private var columnValue : String = "";
    
    
    /// This is the default constructor
    init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter v: Value of the column
    init(v : String) {
        self.columnValue = v;
    }
    
    
    /// This is the full constructor
    ///
    /// - Parameters:
    ///   - n: Name of the column
    ///   - v: Value of the column
    init(n : String, v : String) {
        self.columnName = n;
        self.columnValue = v;
    }
    
    public func getColumnName() -> String {
        return self.columnName;
    }
    
    public func getColumnValue() -> String {
        return self.columnValue;
    }
}
