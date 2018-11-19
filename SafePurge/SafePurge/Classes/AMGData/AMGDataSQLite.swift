//
//  AMGDataSQLite.swift
//  Incrypt
//
//  Created by Abel Gancsos on 9/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation

class AMGDataSQLite : AMGData {
    var databaseHandler : OpaquePointer? = nil;
    var lastError       : String = "";
    var errorTable      : String = "";
    
    override init() {
        super.init();
    }
    
    /// This is the constructor with the database file parameter
    ///
    /// - Parameter path: Path to the SQLite database file
    public init(path : String){
        super.init();
        databaseSource = path;
    }
    
    /// This is the constructor with the database file and error table parameters
    ///
    /// - Parameters:
    ///   - path: Path to the SQLite database file
    ///   - table: Name of the error table for auditing
    public init(path : String,table : String){
        super.init();
        databaseSource = path;
        errorTable = table;
    }
    
    /// This method connects to the database
    ///
    /// - Returns: True if successful, False if not
    private func connect() -> Bool{
        do{
            if(sqlite3_open(databaseSource ,&databaseHandler) == SQLITE_OK){
                return true;
            }
        }
        return false;
    }
    
    /// This method runs a query against the database without audits.
    ///
    /// - Parameter sql: Query to run against the database
    public func safeQuery(sql : String){
        var safeQuery2 : String = sql;
        safeQuery2 = safeQuery2.replacingOccurrences(of: "'", with: "''");
        do{
            var queryHandler : OpaquePointer? = nil;
            if(sqlite3_prepare_v2(databaseHandler, safeQuery2 , -1, &queryHandler, nil) == SQLITE_OK){
                if(sqlite3_step(queryHandler) == SQLITE_DONE){
                    sqlite3_finalize(queryHandler);
                }
            }
            else{
                if(AMGRegistry().lookupKey(key: "DEBUG") != ""){
                    print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
                }
                lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
            }
            close();
        }
    }
    
    /// This method closes the connection to the database
    private func close(){
        sqlite3_close(databaseHandler);
    }
    
    /// This method queries the database.
    ///
    /// - Parameter sql: Query to run against the database
    /// - Returns: Object collection of the rows
    override public func query(sql : String) -> AMGDataTable{
        let mFinal : AMGDataTable = AMGDataTable();
        if(self.connect()){
            do{
                var queryHandler : OpaquePointer? = nil;
                if(sqlite3_prepare_v2(databaseHandler, sql , -1, &queryHandler, nil) == SQLITE_OK){
                    while(sqlite3_step(queryHandler) == SQLITE_ROW){
                        let row : AMGDataRow = AMGDataRow();
                        for i in 0 ..< sqlite3_column_count(queryHandler){
                            row.addColumn(column: AMGDataColumn(n: String.init(cString:sqlite3_column_name(queryHandler, i)), v: String.init(cString:sqlite3_column_text(queryHandler, i))));
                        }
                        mFinal.addRow(row : row);
                    }
                }
                else{
                    if(errorTable != ""){
                        safeQuery(sql: String(format: "insert into %@ (%@_sql_text,%@_error_text) values ('%@','%@')", errorTable,errorTable,errorTable,sql,String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!));
                    }
                    if(AMGRegistry().lookupKey(key: "DEBUG") != ""){
                        print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
                    }
                    lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
                }
                sqlite3_finalize(queryHandler);
            }
            self.close();
        }
        return mFinal;
    }
    
    /// This method queries the database.
    ///
    /// - Parameter sql: Query to run against the database
    /// - Returns: Object collection of the column names
    override public func columns(sql : String) -> [String]{
        var mfinal : [String] = [];
        if(self.connect()){
            do{
                var queryHandler : OpaquePointer? = nil;
                if(sqlite3_prepare_v2(databaseHandler, sql , -1, &queryHandler, nil) == SQLITE_OK){
                    for i in 0 ..< sqlite3_column_count(queryHandler){
                        mfinal.append(String(cString: sqlite3_column_name(queryHandler, i)));
                    }
                }
                else{
                    if(AMGRegistry().lookupKey(key: "DEBUG") != ""){
                        print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
                    }
                    lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
                }
            }
            self.close();
        }
        return mfinal;
    }
    
    /// This method runs a query against the database
    ///
    /// - Parameter sql: Query to run against the database
    /// - Returns: True if successful, False if not
    override public func runQuery(sql : String) -> Bool{
        var status : Bool = false;
        var queryHandler : OpaquePointer? = nil;
        if(connect()){
            do{
                if(sqlite3_prepare_v2(databaseHandler, sql, -1, &queryHandler, nil) == SQLITE_OK){
                    if(sqlite3_step(queryHandler) == SQLITE_DONE){
                        status = true;
                    }
                    else{
                        if(errorTable != ""){
                            safeQuery(sql: String(format: "insert into %@ (%@_command_text,%@_error_text) values ('%@','%@')", errorTable,errorTable,errorTable,sql,String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!));
                        }
                    }
                }
                else{
                    if(AMGRegistry().lookupKey(key: "DEBUG") != ""){
                        print(String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!);
                    }
                    lastError = String(cString: sqlite3_errmsg(queryHandler), encoding: .utf8)!;
                }
            }
            sqlite3_finalize(queryHandler);
            close();
        }
        return status;
    }
    
    /// This method finds the rowid value in the provided query for the table row
    ///
    /// - Parameters:
    ///   - sql: Query to lookup
    ///   - tableRow: Row in the table
    /// - Returns: Row ID value in the database
    override public func findRowID(sql : String,tableRow : NSInteger) -> NSInteger{
        var rowid : NSInteger = 0;
        let sql2 : String = sql.replacingOccurrences(of: "select", with: "select rownum,") ;
        if(connect()){
            do{
                var queryHandler : OpaquePointer? = nil;
                if(sqlite3_prepare_v2(databaseHandler, sql2 , -1, &queryHandler, nil) == SQLITE_OK){
                    var i : NSInteger = 0;
                    while(sqlite3_step(queryHandler) == SQLITE_ROW){
                        if(i == tableRow){
                            rowid = NSInteger(sqlite3_column_int(queryHandler, 0));
                        }
                        i += 1;
                    }
                }
                close();
            }
        }
        return rowid;
    }
}
