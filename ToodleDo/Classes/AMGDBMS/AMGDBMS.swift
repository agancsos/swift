//
//  AMGDBMS.swift
//  DBMS
//
//  Created by Abel Gancsos on 8/27/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation


/// This class helps manage DBMS sessions
class AMGDBMS{
	
	var databaseFile      : String = "";
	var databaseHandler   : AMGSQLite = AMGSQLite();
	let activeConnections : [AMGHandlerBase] = [];
	var currentConnection : AMGHandlerBase = AMGHandlerBase();
	
	
	/// This is the default constructor
	public init(){
		databaseFile = String(format: "%@/Library/Application Support/DBMS/dbms.db",NSHomeDirectory());
		if(AMGRegistry().getValue(key: "Override.Data.DBFilePath") != ""){
			databaseFile = AMGRegistry().getValue(key: "Override.Data.DBFilePath");
		}
		databaseHandler = AMGSQLite(path: databaseFile);
		databaseHandler.errorTable = "error_log";
		startUp();
	}
	
	/// This method will be called each time the GUI starts up
	private func startUp(){
		var isDir : ObjCBool = ObjCBool(false);
		if(!FileManager.default.fileExists(atPath: String(format:"%@/Library/Application Support/DBMS/Themes",
		                                                  NSHomeDirectory()), isDirectory: &isDir)){
			if(!isDir.boolValue){
				do{
					try FileManager.default.createDirectory(atPath: String(format:"%@/Library/Application Support/DBMS/Themes",
					                                                       NSHomeDirectory()), withIntermediateDirectories: false, attributes: nil);
				}
				catch{
					
				}
				
			}
		}
		prepareDB();
		setFlags();
		setDBMS();
	}
	
	
	/// This method audits activity in the database
	///
	/// - Parameters:
	///   - action: Action being done
	///   - msg: Message to audit
	public func audit(action : String, msg : String){
		var command : String = action;
		var message : String = msg;
		command = command.replacingOccurrences(of: "'", with: "''");
		message = message.replacingOccurrences(of: "'", with: "''");
		if(!databaseHandler.runQuery(sql: String(format: "insert into error_log (error_log_command_text,error_log_error_text) values ('%@','%@')",command,message))){
			
		}
	}
	
	/// This method sets the DBMS flags
	private func setDBMS(){
		if(!databaseHandler.runQuery(sql: "delete from sqlite_sequence where name = 'ISDBMS'")){
			
		}
		if(!databaseHandler.runQuery(sql: "insert into sqlite_sequence (name, seq) values ('ISDBMS','1')")){
			
		}
	}
	
	/// This method ensures that the database schema is accurate
	private func prepareDB(){
		createTables();
		setTriggers();
		addProviders();
		setHistory();
	}
	
	/// This method sets the product history details
	private func setHistory(){
		if(databaseHandler.query(sql: "select * from product_history where product_history_modification = 'Created'").count == 0){
			if(!databaseHandler.runQuery(sql: String(format: "insert into product_history (product_history_modification,product_history_version) values ('Created','%@')",AMGCommon().getVersion()))){
				
			}
		}
		else{
			if(databaseHandler.query(sql: String(format:"select * from product_history where product_history_version = '%@'",AMGCommon().getVersion())).count == 0){
				if(!databaseHandler.runQuery(sql: String(format: "insert into product_history (product_history_modification,product_history_version) values ('Upgraded','%@')",AMGCommon().getVersion()))){
					
				}
			}
		}
	}
	
	/// This method retrieves the errors from the database
	public func getErrors() -> [String]{
		return databaseHandler.query(sql: "select * from error_log") as! [String];
	}
	
	/// This method retrieves the columns used for the errors
	public func getErrorColumns() -> [String]{
		return databaseHandler.columns(sql: "select * from error_log");
	}
	
	/// This method retrieves the connections that were saved
	///
	/// - Returns: Connection handler collection
	public func getConnections() -> [AMGHandlerBase]{
		let connRaw : [String] = databaseHandler.query(sql: "select* from connection") as! [String];
		var mfinal : [AMGHandlerBase] = [];
		for connection in connRaw{
			mfinal.append(AMGHandlerBase(components: connection.components(separatedBy: "<COL>")));
		}
		return mfinal;
	}
	
	
	/// This method adds a temporary connection to the database
	///
	/// - Parameter handler: Base handler object to add
	///
	/// - Returns: True if successful, False if not
	public func addConnectionCache(handler : AMGHandlerBase) -> Bool{
		var sql : String = "";
		var checkSQL : String = "";
		if((handler as? AMGHandlerSQLite) != nil){
			checkSQL = String(format:"select * from connection_cache where connection_cache_host = '%@'",(handler as! AMGHandlerSQLite).databaseFile);
			sql = String(format:"insert into connection_cache (connection_cache_host,connection_cache_provider) values ('%@','%@')",(handler as! AMGHandlerSQLite).databaseFile,handler.provider);
		}
		else{
			checkSQL = String(format:"select * from connection_cache where connection_cache_host = '%@'",handler.host);
		}
		
		if(databaseHandler.query(sql: checkSQL).count == 0){
			if(!databaseHandler.runQuery(sql: sql)){
				audit(action: "Adding connection cache", msg: "Failed to add connection");
				return false;
			}
		}
		else{
			audit(action: "Adding connection cache", msg: "Connection already exists");
			return false;
		}
		return true;
	}
	
	/// This method removes a connection from the cache
	///
	/// - Parameter id: ID of the connection
	/// - Returns: True if successful, False if not
	public func removeConnection(id : String) -> Bool{
		if(!databaseHandler.runQuery(sql: String(format: "delete from connection_cache where connection_cache_id = '%@'",id))){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				
			}
			return false;
		}
		return true;
	}
	
	/// This method retrieves the connections that were cached
	///
	/// - Returns: Connection handler collection
	public func getConnectionCache() -> [AMGHandlerBase]{
		let connRaw : [String] = databaseHandler.query(sql: "select* from connection_cache") as! [String];
		var mfinal : [AMGHandlerBase] = [];
		for connection in connRaw{
			mfinal.append(AMGHandlerBase(components: connection.components(separatedBy: "<COL>")));
		}
		return mfinal;
	}
	
	
	/// This method retrieves the list of implemented providers
	///
	/// - Returns: String collection with the values
	public func getProviders() -> [String]{
		return databaseHandler.query(sql: "select provider_name from provider") as! [String];
	}
	
	// Update operations from Connection Manager view
	
	/// This method adds a new saved connection to the DBMS database
	///
	/// - Returns: True if successful, False if not
	public func addConnection() -> Bool{
		if(!databaseHandler.runQuery(sql: "insert into connection default values")){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				
			}
			return false;
		}
		return true;
	}
	
	
	/// This method removes the saved connection from the DBMS database
	///
	/// - Parameter id: ID of the connection to remove
	/// - Returns: True if successful, False if not
	public func deleteConnection(id : String) -> Bool{
		if(!databaseHandler.runQuery(sql: String(format: "delete from connection where connection_id = '%@'",id))){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				
			}
			return false;
		}
		return true;
	}
	
	
	/// This method updates the connection information in the DBMS database
	///
	/// - Parameters:
	///   - id: ID of the connection to update
	///   - connection: Connection information
	/// - Returns: True if successful, False if not
	public func saveConnection(id : String, connection : AMGHandlerBase) -> Bool{
		if(!databaseHandler.runQuery(sql: String(format: "update connection set connection_provider = '%@', connection_host = '%@',connection_port = '%@',connection_username = '%@', connection_password = '%@' where connection_id = '%@'",connection.provider,connection.host, connection.port, connection.username, connection.password,id))){
			if(AMGRegistry().getValue(key: "Silent") != "1"){
				
			}
			return false;
		}
		return true;
	}
	/*******************************************************************/
	
	
	
	/// This method audits search details
	///
	/// - Parameters:
	///   - search: String that was used in the filter
	///   - results: Number of results found
	public func auditSearch(search : String, results : NSInteger){
		if(!databaseHandler.runQuery(sql: String(format: "insert into search (search_text,search_result_count) values ('%@','%d')", search,results))){
			
		}
	}
	
	
	/// This method audits details about queries that were ran
	///
	/// - Parameters:
	///   - query: Query that was ran
	///   - results: Number of rows returned
	public func auditQuery(query : String, results : NSInteger){
		if(!databaseHandler.runQuery(sql: String(format: "insert into query (query_text,query_result_count) values ('%@','%d')", query,results))){
			
		}
	}
	
	// Database methods
	
	/// This method sets the triggers for the database
	private func setTriggers(){
		var queries : [String] = [];
		
		queries.append("create trigger if not exists FLAG_UPDATED AFTER UPDATE on flag begin update flag set last_updated_date = current_timestamp; end;");
		queries.append("create trigger if not exists CONNECTION_UPDATED AFTER UPDATE on connection begin update connection set last_updated_date = current_timestamp; end;");
		queries.append("create trigger if not exists CONNECTION_CACHE_UPDATED AFTER UPDATE on connection_cache begin update connections_cache set last_updated_date = current_timestamp; end;");
		queries.append("create trigger if not exists AUDIT_DELETED after delete on error_log begin insert into error_log (error_log_command_text, error_log_error_text, last_updated_date) values (old.error_log_command_text,old.error_log_error_text,old.last_updated_date); end;");
		queries.append("create trigger if not exists QUERY_DELETED after delete on query begin insert into query (query_text, query_result_count, last_updated_date) values (old.query_text,old.query_result_count,old.last_updated_date); end;");
		
		for query in queries{
			if(!databaseHandler.runQuery(sql: query)){
				
			}
		}
	}
	
	/// This method adds the registry keys to the database
	private func setFlags(){
		let keys : NSDictionary = AMGRegistry().getAll();
		if(databaseHandler.runQuery(sql: "delete from flag")){
			if(!databaseHandler.runQuery(sql: String(format: "insert into flag (flag_name, flag_value) values ('CurrentUser','%@')",NSUserName()))){
				
			}
			if(!databaseHandler.runQuery(sql: String(format: "insert into flag (flag_name, flag_value) values ('HomeDirectory','%@')",NSHomeDirectory()))){
				
			}
			
			// Loop through keys and add to database
			for (key,value) in keys{
				if(!databaseHandler.runQuery(sql: String(format: "insert into flag (flag_name, flag_value) values ('%@','%@')",key as! String,value as! String))){
					
				}
			}
		}
	}
	
	/// This method returns the column names for the specific table
	///
	/// - Parameter table: Name of the table
	/// - Returns: Column names
	public func getColumns(table : String) -> [String]{
		return databaseHandler.columns(sql: String(format: "select * from %@",table));
	}
	
	
	/// This method returns the rows for the specific table
	///
	/// - Parameter table: Table name
	/// - Returns: Rows from the table
	public func getRows(table : String) -> [String]{
		return databaseHandler.query(sql: String(format: "select * from %@",table)) as! [String];
	}
	
	/// This method creates the configuration schema
	private func createTables(){
		var queries : [String] = [];
		
		// Globals
		queries.append("create table if not exists flag (flag_name character not null primary key,flag_value character default '',last_updated_date timestamp default current_timestamp)");
		
		// Error Logs
		queries.append("create table if not exists error_log(error_log_id integer primary key autoincrement, error_log_command_text character default '', error_log_error_text character default '', last_updated_date timestamp default current_timestamp)");
		
		// Providers
		queries.append("create table if not exists provider (provider_name character not null primary key,provider_driver character default '',last_updated_date timestamp default current_timestamp)");
		
		// Connections
		queries.append("create table if not exists connection(connection_id integer primary key autoincrement, connection_provider character default 'Oracle', connection_host character default 'NEW CONNECTION',connection_port character default '1521',connection_username character default '', connection_password character default '', connection_host_os character default '',connection_host_memory character default '', connection_host_cpu_count character default '', connection_host_java_version character default '', connection_host_java_path character default '',last_updated_date timestamp default current_timestamp)")
		
		// Connections Cache
		queries.append("create table if not exists connection_cache(connection_cache_id integer primary key autoincrement, connection_cache_provider character default 'Oracle', connection_cache_host character default '',connection_cache_port character default '1521',connection_cache_username character default '', connection_cache_password character default '', connection_cache_connection_id character default '0',last_updated_date timestamp default current_timestamp)")
		
		// Searches
		queries.append("create table if not exists search(search_id integer primary key autoincrement, search_text character default '', search_result_count integer default '0', last_updated_date timestamp default current_timestamp)");
		
		// Queries
		queries.append("create table if not exists query(search_id integer primary key autoincrement, query_text character default '', query_result_count integer default '0', last_updated_date timestamp default current_timestamp)");
		
		// Product History
		queries.append("create table if not exists product_history(product_history_id integer primary key autoincrement, product_history_modification character default '',product_history_version character default '', last_updated_date default current_timestamp)");
		
		for query in queries{
			if(!databaseHandler.runQuery(sql: query)){
			}
		}
	}
	
	
	/// This method adds the implemented providers.
	private func addProviders(){
		var providers : [String] = [];
		
		// Implemneted handlers
		providers.append("Oracle");
		providers.append("SQL Server");
		providers.append("SQLite");
		
		for provider in providers{
			if(databaseHandler.query(sql: "select * from provider where provider_name = '" + provider + "'").count == 0){
				if(!databaseHandler.runQuery(sql: "insert into provider (provider_name) values ('" + provider + "')")){
					
				}
			}
			
		}
	}
}
