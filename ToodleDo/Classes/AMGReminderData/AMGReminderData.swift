//
//  AMGReminderData.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/2/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGReminderData{
	public var databaseFile    : String = "";
	public var databaseHandler : AMGSQLite = AMGSQLite();
	
	public init(){
		databaseFile = String.init(format: "%@/Library/Application Support/ToodleDo/toodledo.todo", NSHomeDirectory());
		databaseHandler = AMGSQLite(path: databaseFile, table: "error_log");
		prepareDB();
	}
	
	public init(path : String){
		databaseFile = path;
		databaseHandler = AMGSQLite(path: databaseFile, table: "error_log");
		prepareDB();
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
	
	/// This method ensures that the database schema is accurate
	private func prepareDB(){
		createTables();
		setTriggers();
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
	
	// Database methods
	
	/// This method sets the triggers for the database
	private func setTriggers(){
		var queries : [String] = [];
		
		queries.append("create trigger if not exists FLAG_UPDATED AFTER UPDATE on flag begin update flag set last_updated_date = current_timestamp; end;");
		queries.append("create trigger if not exists LIST_UPDATED AFTER UPDATE on list begin update list set last_updated_date = current_timestamp; end;");
		queries.append("create trigger if not exists REMINDER_UPDATED AFTER UPDATE on reminder begin update reminder set last_updated_date = current_timestamp; end;");
		queries.append("create trigger if not exists AUDIT_DELETED after delete on error_log begin insert into error_log (error_log_command_text, error_log_error_text, last_updated_date) values (old.error_log_command_text,old.error_log_error_text,old.last_updated_date); end;");
		queries.append("create trigger if not exists IMPORT_DELETED after delete on import begin insert into import (import_value values (old.import_value); end;");

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
	
	
	/// This method retrieves the child lists from the database
	///
	/// - Parameter id: ID for the parent list
	/// - Returns: List collection
	public func getChildLists(id : String) -> [AMGList]{
		let mRaw : [String] = databaseHandler.query(sql: String(format: "select list_name, list_id, list_pid from list where list_pid = '%@'",id)) as! [String];
		var mFinal : [AMGList] = [];
		for row in mRaw{
			let rowComps : [String] = row.components(separatedBy: "<COL>");
			mFinal.append(AMGList(n: rowComps[0], id2: rowComps[1], pid2: rowComps[2]));
		}
		return mFinal;
	}
	
	
	/// This method adds a new list under the selected parent list
	///
	/// - Parameter parent: Parent list object
	/// - Returns: True if successful, False if not
	public func addList(parent : AMGList) -> Bool{
		if(databaseHandler.runQuery(sql: String(format:"insert into list (list_pid,list_name) values ('%@','NEW')",parent.id))){
			return true;
		}
		return false;
	}
	
	
	/// This method retrieves the properties of a reminder object
	///
	/// - Returns: String array of the properties
	public func getReminderLabels() -> [String]{
		return databaseHandler.columns(sql: "select * from reminder");
	}
	
	
	/// This method adds a new reminder under the selected list
	///
	/// - Parameter parent: List object
	/// - Returns: True if successful, False if not
	public func addReminder(parent : AMGList) -> Bool{
		if(databaseHandler.runQuery(sql: String(format:"insert into reminder (list_id,reminder_created_date,reminder_description) values ('%@',current_timestamp,'NEW')",parent.id))){
			return true;
		}
		return false;
	}

	private func clearList(path : AMGList) -> Bool{
		let children : [AMGList] = getChildLists(id: path.id);
		if(children.count == 0){
			if(databaseHandler.runQuery(sql: String(format: "delete from reminder where list_id = '%@'",path.id))){
				if(databaseHandler.runQuery(sql: String(format: "delete from list where list_pid = '%@'",path.id))){
					if(databaseHandler.runQuery(sql: String(format: "delete from list where list_id = '%@'",path.id))){
						return true;
					}
					else{
						audit(action: "Delete", msg: String(format: "Failed to delete list[%@]: %@",path.id,databaseHandler.lastError));
					}
				}
				else{
					audit(action: "Delete", msg: String(format: "Failed to delete child lists for list[%@]: %@",path.id,databaseHandler.lastError));
				}
			}
			else{
				audit(action: "Delete", msg: String(format: "Failed to delete reminders for list[%@]: %@",path.id,databaseHandler.lastError));
			}
		}
		else{
			for child in children{
				if(!clearList(path: child)){
					
				}
			}
		}
		return false;
	}
	
	/// This method removes the selected list and all child objects
	///
	/// - Parameter parent: List object
	/// - Returns: True if successful, False if not
	public func deleteList(parent : AMGList) -> Bool{
		let children : [AMGList] = getChildLists(id: parent.id);
		for child in children{
			if(clearList(path: child)){
				return true;
			}
		}
		if(databaseHandler.runQuery(sql: String(format: "delete from reminder where list_id = '%@'",parent.id))){
			if(databaseHandler.runQuery(sql: String(format: "delete from list where list_id = '%@'",parent.id))){
				return true;
			}
		}
		return false;
	}

	
	/// This method removes the selected reminder
	///
	/// - Parameter reminder: Reminder object
	/// - Returns: True if successful, False if not
	public func deleteReminder(reminder : AMGReminder) -> Bool{
		if(databaseHandler.runQuery(sql: String(format: "delete from reminder where reminder_id = '%@'",reminder.id))){
			return true;
		}
		audit(action: "Delete Reminder", msg: String(format:"Failed to delete reminder[%@]: %@", reminder.id, databaseHandler.lastError));
		return false;
	}

	/// This method retrieves the reminders for a given list
	///
	/// - Parameter parent: Parent list
	/// - Returns: Reminder collection
	public func getReminders(parent : AMGList) -> [AMGReminder]{
		var mFinal : [AMGReminder] = [];
		let mRaw : [String] = databaseHandler.query(sql: String(format: "select * from reminder where list_id = '%@'",parent.id)) as! [String];
		for row in mRaw{
			let rowComps : [String] = row.components(separatedBy: "<COL>");
			mFinal.append(AMGReminder(id2: rowComps[0], pid2: rowComps[1], desc: rowComps[2], pri: rowComps[3],
									  sum: rowComps[4], cd: rowComps[5], stat: rowComps[6], com: rowComps[7], ld: rowComps[8]));
		}
		return mFinal;
	}

	/// This method retrieves all children
	///
	/// - Parameter parent: Parent list
	/// - Returns: Object collection
	public func getAllChildren(parent : AMGList) -> NSMutableArray{
		let mFinal : NSMutableArray = NSMutableArray();
		let temp = getReminders(parent: parent);
		for cursor in temp{
			mFinal.add(cursor);
		}
		
		let temp2 = getChildLists(id: parent.id);
		for cursor in temp2{
			mFinal.add(cursor);
		}

		return mFinal;
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
		
		// Import
		queries.append("create table if not exists import(import_id integer primary key autoincrement, import_value character default '', last_updated_date timestamp default current_timestamp)");
		
		// List
		queries.append("create table if not exists list(list_id integer primary key autoincrement,list_pid integer not null,list_name character default '',last_updated_date timestamp default current_timestamp,foreign key (list_pid) references list (list_id))");
		
		// Reminder
		queries.append("create table if not exists reminder(reminder_id integer primary key autoincrement,list_id integer not null, reminder_description character default '',reminder_priority integer default '5', reminder_summary character default '',reminder_created_date timestamp default current_timestamp, reminder_status integer default '0', reminder_completed_date timestamp,last_updated_date timestamp default current_timestamp,foreign key (list_id) references list (list_id))");
		
		// Product History
		queries.append("create table if not exists product_history(product_history_id integer primary key autoincrement, product_history_modification character default '',product_history_version character default '', last_updated_date default current_timestamp)");
		
		for query in queries{
			if(!databaseHandler.runQuery(sql: query)){
			}
		}
	}
	
	// Update data
	
	
	/// This method updates the reminder summary
	///
	/// - Parameters:
	///   - reminder: Reminder object
	///   - value: Value to set
	/// - Returns: True if successful, False if not
	public func updateSummary(reminder : AMGReminder, value : String) -> Bool{
		if(databaseHandler.runQuery(sql: String(format:"update reminder set reminder_summary='%@' where reminder_id='%@'",value,reminder.id))){
			return true;
		}
		return false;
	}
	
	/// This method updates the reminder description
	///
	/// - Parameters:
	///   - reminder: Reminder object
	///   - value: Value to set
	/// - Returns: True if successful, False if not
	public func updateDescription(reminder : AMGReminder, value : String) -> Bool{
		if(databaseHandler.runQuery(sql: String(format:"update reminder set reminder_description='%@' where reminder_id='%@'",value,reminder.id))){
			return true;
		}
		return false;
	}
	
	/// This method updates the reminder priority
	///
	/// - Parameters:
	///   - reminder: Reminder object
	///   - value: Value to set
	/// - Returns: True if successful, False if not
	public func updatePriority(reminder : AMGReminder, value : String) -> Bool{
		if(databaseHandler.runQuery(sql: String(format:"update reminder set reminder_priority='%@' where reminder_id='%@'",value,reminder.id))){
			return true;
		}
		return false;
	}
	
	/// This method updates the reminder status
	///
	/// - Parameters:
	///   - reminder: Reminder object
	///   - value: Value to set
	/// - Returns: True if successful, False if not
	public func updateStatus(reminder : AMGReminder, value : String) -> Bool{
		if(databaseHandler.runQuery(sql: String(format:"update reminder set reminder_status='%@' where reminder_id='%@'",value,reminder.id))){
			return true;
		}
		return false;
	}
	
	/// This method updates the list summary
	///
	/// - Parameters:
	///   - reminder: List object
	///   - value: Value to set
	/// - Returns: True if successful, False if not
	public func updateList(list : AMGList, value : String) -> Bool{
		if(databaseHandler.runQuery(sql: String(format:"update list set list_name='%@' where list_id='%@'",value,list.id))){
			return true;
		}
		return false;
	}
	
	
	/// This method retrieves a specific reminder
	///
	/// - Parameter id: ID of the reminder object
	/// - Returns: Reminder object
	public func getReminder(id : String) -> AMGReminder{
		if(databaseHandler.query(sql: String(format:"select * from reminder where reminder_id='%@'",id)).count > 0){
			let mRaw : [String] = databaseHandler.query(sql: String(format: "select * from reminder where reminder_id = '%@'",id)) as! [String];
			for row in mRaw{
				let rowComps : [String] = row.components(separatedBy: "<COL>");
				return AMGReminder(id2: rowComps[0], pid2: rowComps[1], desc: rowComps[2], pri: rowComps[3],
								   sum: rowComps[4], cd: rowComps[5], stat: rowComps[6], com: rowComps[7], ld: rowComps[8]);
			}
		}
		return AMGReminder();
	}
	
	
	/// This method imports the following reminders to the list
	///
	/// - Parameters:
	///   - reminders: List of reminders
	///   - parent: Parent list object
	/// - Returns: True if successful, False if not
	public func importReminders(reminders : [AMGReminder], parent : AMGList) -> Bool{
		for reminder in reminders{
			var query : String = "insert into reminder (list_id,reminder_description,reminder_summary,reminder_priority,reminder_created_date,reminder_status)";
			query = query.appending(" values ");
			query = query.appending(String(format:"('%@','%@','%@','%@','%@','%@')",parent.id,reminder.description.replacingOccurrences(of: "'", with: "''"),
										   reminder.summary.replacingOccurrences(of: "'", with: "''"),reminder.priority,reminder.createdDate,reminder.status));
			if(!databaseHandler.runQuery(sql: query)){
				audit(action: "Database", msg: String(format:"Failed query: %@",query));
				audit(action: "Database", msg: String(format:"Failed to import reminder: %@",databaseHandler.lastError));
				return false;
			}
		}
		return true;
	}
}
