//
//  AMGGrader.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps manage the Grader application and associated session
class AMGGrader {
    var databaseFile      : String = "";
    var databaseHandler   : AMGSQLite = AMGSQLite();
    var sessionUser       : AMGUser = AMGUser();
    
    /// This is the default constructor
    public init(){
        databaseFile = String(format: "%@/Library/Application Support/Grader/grader.gbk",NSHomeDirectory());
        if(AMGRegistry().getValue(key: "Override.Data.DBFilePath") != ""){
            databaseFile = AMGRegistry().getValue(key: "Override.Data.DBFilePath");
        }
        databaseHandler = AMGSQLite(path: databaseFile);
        databaseHandler.errorTable = "error_log";
        startUp();
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
    
    /// This method will be called each time the GUI starts up
    private func startUp(){
        var isDir : ObjCBool = ObjCBool(false);
        if(!FileManager.default.fileExists(atPath: String(format:"%@/Library/Application Support/Grader/Themes",
                                                          NSHomeDirectory()), isDirectory: &isDir)){
            if(!isDir.boolValue){
                do{
                    try FileManager.default.createDirectory(atPath: String(format:"%@/Library/Application Support/Grader/Themes",
                                                                           NSHomeDirectory()), withIntermediateDirectories: false, attributes: nil);
                }
                catch{
                    
                }
                
            }
        }
        prepareDB();
        setFlags();
        getSessionUser();
        purgeOldAudits();
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
    
    /// This method removes all old audits based on a retention period
    private func purgeOldAudits(){
        var retention : NSInteger = 10;  // Default: 10 days
        if(AMGRegistry().getValue(key: "Grader.Audits.RetentionPeriod") != ""){
            retention = NSInteger((AMGRegistry().getValue(key: "Grader.Audits.RetentionPeriod") as NSString).intValue);
        }
        audit(action: "Startup", msg: String(format: "Retention Period: %d days",retention));
    }
    
    /// This method retrieves the Grader User object for the current session
    private func getSessionUser(){
        let nameComps = NSFullUserName().components(separatedBy: " ");
        let sql : String = String(format: "select * from users where user_firstname = '%@' and user_lastname = '%@'",nameComps[0],nameComps[1]);
        sessionUser = AMGUser(row: ((databaseHandler.query(sql: sql)) as! [String])[0].components(separatedBy: "<COL>"));
        audit(action: "Startup", msg: String(format: "Session user: %@",sessionUser.id));
    }
    
    /// This method ensures that the database schema is accurate
    private func prepareDB(){
        createTables();
        fillData();
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
        queries.append("create trigger if not exists INSTITUTION_UPDATED AFTER UPDATE on institution begin update institution set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists users_UPDATED after update on users begin update users set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists college_UPDATED after update on college begin update college set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists program_UPDATED after update on program begin update program set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists student_UPDATED after update on student begin update student set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists course_UPDATED after update on course begin update course set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists program_course_UPDATED after update on program_course begin update program_course set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists grade_type_UPDATED after update on grade_type begin update grade_type set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists grade_UPDATED after update on grade begin update grade set last_updated_date = current_timestamp; end;");
        queries.append("create trigger if not exists AUDIT_DELETED after delete on error_log begin insert into error_log (error_log_command_text, error_log_error_text, last_updated_date) values (old.error_log_command_text,old.error_log_error_text,old.last_updated_date); end;");
        
        for query in queries{
            if(!databaseHandler.runQuery(sql: query)){
                
            }
        }
    }
    
    /// This method adds the registry keys to the database
    private func setFlags(){
        AMGRegistry().purge();
        
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
    
    /// This method creates the configuration schema
    private func createTables(){
        var queries : [String] = [];
        
        // Globals
        queries.append("create table if not exists flag (flag_name character not null primary key,flag_value character default '',last_updated_date timestamp default current_timestamp)");
        
        // Error Logs
        queries.append("create table if not exists error_log(error_log_id integer primary key autoincrement, error_log_command_text character default '', error_log_error_text character default '', last_updated_date timestamp default current_timestamp)");
        
        // Product History
        queries.append("create table if not exists product_history(product_history_id integer primary key autoincrement, product_history_modification character default '',product_history_version character default '', last_updated_date default current_timestamp)");
        
        // Institutions
        queries.append("create table if not exists institution(institution_id integer primary key autoincrement,institution_name character default '',institution_address character default '',institution_city character default '', institution_state character default '', institution_zip character default '',institution_country character default '', last_updated_date timestamp default current_timestamp, last_updated_by character default '')");
        
        // Users
        queries.append("create table if not exists users(user_id integer primary key autoincrement,user_type character default '',user_firstname character default '',user_lastname character default '',user_address character default '',user_city character default '',user_state character default '',user_zip character default '',user_country character default '',last_updated_date timestamp default current_timestamp,last_updated_by character default '')");
        
        // Colleges
        queries.append("create table if not exists college(college_id integer primary key autoincrement,institution_id integer,college_name character default '',college_address character default '', college_city character default '',college_state character default '',college_zip character default '',college_country character default '',college_dean integer,last_updated_date timestamp default current_timestamp,last_updated_by character default '',foreign key (institution_id) references institution (institution_id),foreign key (college_dean) references users(user_id))");
        
        // Programs
        queries.append("create table if not exists program(program_id integer primary key autoincrement,college_id integer,program_name character default '',program_category character default '',program_chair integer,last_updated_date timestamp default current_timestamp,last_updated_by character default '',foreign key (college_id) references college(college_id), foreign key (program_chair) references users(user_id))")
        
        // Students
        queries.append("create table if not exists student(user_id integer,program_id integer, student_number character default '',student_startdate timestamp,student_current_gpa decimal(10,5) default '0.000',last_updated_date timestamp default current_timestamp, last_updated_by character default '',primary key (user_id,program_id),foreign key (user_id) references users(user_id),foreign key (program_id) references program(program_id))");
        
        // Courses
        queries.append("create table if not exists course(course_id integer primary key autoincrement,course_number integer default '0',course_name character default '', course_description character default '',course_semester character default '',course_year integer default '0',course_startdate timestamp,course_enddate timestamp,course_instructor integer,course_notes character default '',last_updated_date timestamp default current_timestamp, last_updated_by character default '',college_id integer,foreign key (course_instructor) references users(user_id),foreign key (college_id) references college(college_id))");
        
        // Program Courses
        queries.append("create table if not exists program_course(program_id integer,course_id integer,primary key(program_id,course_id),foreign key (program_id) references program(program_id),foreign key(course_id) references course(course_id))");
        
        // Grade Types
        queries.append("create table if not exists grade_type(grade_type_id integer primary key autoincrement,grade_type_name character, last_updated_date timestamp default current_timestamp, last_updated_by character default '')");
        
        // Grade Weight
        queries.append("create table if not exists grade_weight(grade_weight_id integer primary key autoincrement,course_id integer,grade_type integer,grade_weight integer,foreign key (course_id) references course(course_id),foreign key (grade_type) references grade_type(grade_type_id))");
        
        // Grades
        queries.append("create table if not exists grade(grade_id integer primary key autoincrement,course_id integer,grade_type integer,grade_weight integer,student_id integer,grade_name character default '',grade_value decimal(10,5) default '0',grade_notes character default '',last_updated_date timestamp default current_timestamp,last_updated_by character default '',foreign key (course_id) references course(course_id),foreign key (grade_type) references grade_type(grade_type_id), foreign key (grade_weight) references grade_weight(grade_weight_id),foreign key (student_id) references users(user_id))");
        
        for query in queries{
            if(!databaseHandler.runQuery(sql: query)){
            }
        }
    }
    
    /// This method fills base data into the database
    private func fillData(){
        createStudent();
        if(AMGRegistry().getValue(key: "Grader.User.Mode.Instructor") == "1"){
            createInstructor();
        }
        createGradeTypes();
    }
    
    /// This method creates a student for the current user
    private func createStudent(){
        let fullName : String = NSFullUserName();
        let nameComps : [String] = fullName.components(separatedBy: " ");
        if(nameComps.count > 1){
            let tempUser : AMGUser = AMGUser();
            tempUser.firstName = nameComps[0];
            tempUser.lastName = nameComps[1];
            tempUser.type = "Student";
            let tempStudent = AMGStudent(base : tempUser);
            if(!addStudent(a: tempStudent)){
                audit(action: "Add initial student", msg: String(format: "Failed to create student: %@ %@",tempStudent.firstName,tempStudent.lastName));
            }
        }
    }
    
    /// This method creates an instructor for the current user
    private func createInstructor(){
        let fullName : String = NSFullUserName();
        let nameComps : [String] = fullName.components(separatedBy: " ");
        if(nameComps.count > 1){
            let tempUser : AMGUser = AMGUser();
            tempUser.firstName = nameComps[0];
            tempUser.lastName = nameComps[1];
            tempUser.type = "Instructor";
            let tempInstructor = AMGInstructor(base : tempUser);
            if(!addInstructor(a: tempInstructor)){
                audit(action: "Add initial instructor", msg: String(format: "Failed to create instructor: %@ %@",tempInstructor.firstName,tempInstructor.lastName));
            }
        }
    }
    
    /// This method creates the basic grade types
    private func createGradeTypes(){
        var types : [AMGGradeType] = [];
        types.append(AMGGradeType(name2 : "Homework"));
        types.append(AMGGradeType(name2 : "Project"));
        types.append(AMGGradeType(name2 : "Quiz"));
        types.append(AMGGradeType(name2 : "Exam"));
        types.append(AMGGradeType(name2 : "Lab"));

        for type in types{
            if(!addGradeType(a: type)){
                
            }
        }
    }
}
