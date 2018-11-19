//
//  AMGData.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

enum DATABASE_FAMILY {
    case NONE
    case SQLLITE
    case ORACLE
    case MSSQL
    
}

class AMGData {
    internal var databaseSource   : String = "";
    internal var databaseUsername : String = "";
    internal var databasePassword : String = "";
    internal var databaseFaily    : DATABASE_FAMILY = .NONE;
    
    
    /// This is the default constructor
    init() {
        
    }
    
    
    /// This is the common constructor
    ///
    /// - Parameter source: Source for the data
    init (source : String = "") {
        self.databaseSource = source;
    }
    
    
    /// This method connects to the database
    private func connet() {
        
    }
    
    
    /// This method disconnects from the database
    private func disconnect() {
        
    }
    
    
    /// This method runs a query that doesn't audit if failure
    ///
    /// - Parameter sql: Query to run
    private func runSafeQuery(sql : String) {
        
    }
    
    
    /// This method runs a query against the database
    ///
    /// - Parameter sql: Query to run
    /// - Returns: True if successful, false if not
    public func runQuery(sql : String) -> Bool {
        return true;
    }
    
    
    /// This method retrieves data from the database
    ///
    /// - Parameter sql: Query to run
    /// - Returns: Collection of strings from the database
    public func query(sql : String) -> AMGDataTable {
        let temp : AMGDataTable = AMGDataTable();
        return temp;
    }
    
    /// This method finds the rowid value in the provided query for the table row
    ///
    /// - Parameters:
    ///   - sql: Query to lookup
    ///   - tableRow: Row in the table
    /// - Returns: Row ID value in the database
    public func findRowID(sql : String,tableRow : NSInteger) -> NSInteger{
        return 0;
    }
    
    /// This method retrieves the columns for the query
    ///
    /// - Parameter sql: Query to retrieve columns for
    /// - Returns: Names of the columns
    public func columns(sql : String) -> [String] {
        let temp : NSMutableArray = NSMutableArray();
        return ((temp as NSArray) as! [String]);
    }
    
    public func setDataSource(source : String) {
        self.databaseSource = source;
    }
    
    public func getDataSource() -> String {
        return self.databaseSource;
    }
    
    public func setUsername(username : String) {
        self.databaseUsername = username;
    }
    
    public func getUsername() -> String {
        return self.databaseUsername;
    }
    
    public func setPassword(password : String) {
        self.databasePassword = password;
    }
}
