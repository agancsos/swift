//
//  AMGGraderAddOps.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This extensions is meant to organize operations for the Grader class.
/// It functions as the base API
extension AMGGrader {
    
    
    /// This method adds a new student user type
    ///
    /// - Parameter a: Student user object
    /// - Returns: True if successful, false if not
    public func addStudent(a : AMGStudent) -> Bool {
        if(!addUser(a: a)){
            audit(action: "Add student", msg: String(format: "Failed to add student user"));
            return false;
        }
        else{
            let sql1 : String = String(format: "select user_id from users where user_firstname = '%@' and user_lastname = '%@'",a.firstName,a.lastName);
            a.id = databaseHandler.query(sql: sql1).object(at: 0) as! String;
            let sql2 : String = String(format: "insert into student (user_id) values ('%@')",a.id);
            if(databaseHandler.query(sql: String(format: "select user_id from student where user_id = '%@'",a.id)).count == 0){
                if(!databaseHandler.runQuery(sql: sql2)){
                    return false;
                }
            }
        }
        return true;
    }
    
    
    /// This method adds a new student user type
    ///
    /// - Parameter a: Instructor user object
    /// - Returns: True if successful, false if not
    public func addInstructor(a : AMGInstructor) -> Bool{
        if(!addUser(a: a)){
            return false;
        }
        else{
            let sql1 : String = String(format: "select user_id from users where user_firstname = '%@' and user_lastname = '%@'",a.firstName,a.lastName);
            a.id = databaseHandler.query(sql: sql1).object(at: 0) as! String;
            /*let sql2 : String = String(format: "insert into instructor (user_id) values ('%@')",a.id);
            if(databaseHandler.query(sql: String(format: "select user_id from instructor where user_id = '%@'",a.id)).count == 0){
                if(!databaseHandler.runQuery(sql: sql2)){
                    return false;
                }
            }*/
        }
        return true;
    }
    
    
    /// This method adds a new base user if not already exists
    ///
    /// - Parameter a: Base user object
    /// - Returns: True if successful, false if not
    public func addUser(a : AMGUser) -> Bool{
        let sql : String = String(format: "select user_id from users where user_firstname = '%@' and user_lastname = '%@'",a.firstName,a.lastName);
        if(databaseHandler.query(sql: sql).count == 0){
            let sql2 : String = String(format : "insert into users (user_firstname,user_lastname,user_type) values ('%@','%@','%@')",a.firstName,a.lastName,a.type);
            if(!databaseHandler.runQuery(sql: sql2)){
                audit(action: "Add user", msg: String(format: "Failed to add user (%@ %@): %@",a.firstName,a.lastName,databaseHandler.lastError));
                return false;
            }
        }
        return true;
    }
    
    /// This method adds a new grade type
    ///
    /// - Parameter a: Grade type object
    /// - Returns: True if successful, false if not
    public func addGradeType(a : AMGGradeType) -> Bool {
        let sql : String = String(format: "select grade_type_id from grade_type where grade_type_name = '%@'",a.name);
        if(databaseHandler.query(sql: sql).count == 0){
            let sql2 : String = String(format: "insert into grade_type (grade_type_name) values ('%@')",a.name);
            if(!databaseHandler.runQuery(sql: sql2)){
                audit(action: "Add grade type", msg: String(format: "Failed to add grade type (%@): %@",a.name,databaseHandler.lastError));
                return false;
            }
        }
        return true;
    }
    
    /// This method adds a new grade weight
    ///
    /// - Parameter a: Grade weight object
    /// - Returns: True if successful, false if not
    public func addGradeWeight(a : AMGGradeWeight) -> Bool {
        let sql : String = String(format: "select grade_weight_id from grade_weight where grade_type_id = '%@' and course_id = '%@'",a.type.id,a.course.id);
        if(databaseHandler.query(sql: sql).count == 0){
            let sql2 : String = String(format: "insert into grade_weight (course_id,grade_type,grade_weight) values ('%@','%@','%d')",a.course.id,a.type.id,a.weight);
            if(!databaseHandler.runQuery(sql: sql2)){
                audit(action: "Add grade weight", msg: String(format: "Failed to add gradeweight (%@) for course (%@): %@",a.type.name,a.course.name,databaseHandler.lastError));
                return false;
            }
        }
        return true;
    }
    
    
    /// This method adds a new college
    ///
    /// - Parameter a: College object to add
    /// - Returns: True if successful, false if not
    public func addCollege(a : AMGCollege) -> Bool {
        let sql1 : String = String(format: "select * from college where where college_name = '%@'",a.name);
        if(databaseHandler.query(sql: sql1).count == 0){
            let sql2 : String = String(format: "insert into college(college_name,institution_id) values ('%@','%@')",a.name,a.institute.id);
            if(!databaseHandler.runQuery(sql: sql2)){
                return false;
            }
        }
        return true;
    }
    
    /// This method adds a new course
    ///
    /// - Parameter a: Course object to add
    /// - Returns: True if successful, false if not
    public func addCourse(a : AMGCourse) -> Bool {
        let sql1 : String = String(format: "select * from course where where course_name = '%@'",a.name);
        if(databaseHandler.query(sql: sql1).count == 0){
            let sql2 : String = String(format: "insert into course(course_name,college_id) values ('%@','%@')",a.name,a.college.id);
            if(!databaseHandler.runQuery(sql: sql2)){
                return false;
            }
        }
        return true;
    }
    
    /// This method adds a new grade
    ///
    /// - Parameter a: Grade object to add
    /// - Returns: True if successful, false if not
    public func addGrade(a : AMGGrade) -> Bool {
        let sql1 : String = String(format: "select * from grade where where grade_type_id = '%@' and course_id = '%@'",a.type.id,a.course.id);
        if(databaseHandler.query(sql: sql1).count == 0){
            let sql2 : String = String(format: "insert into grade(grade_name,grade_type_id,grade_weight_id,course_id) values ('%@','%@','%@','%@')",a.name,a.type.id,a.weight.id,a.course.id);
            if(!databaseHandler.runQuery(sql: sql2)){
                return false;
            }
        }
        return true;
    }

    /// This method adds a new institute
    ///
    /// - Parameter a: Institute object to add
    /// - Returns: True if successful, false if not
    public func addInstitution(a : AMGInstitution) -> Bool {
        let sql1 : String = String(format: "select * from institution where where institution_name = '%@'",a.name);
        if(databaseHandler.query(sql: sql1).count == 0){
            let sql2 : String = String(format: "insert into grade(institution_name) values ('%@')",a.name);
            if(!databaseHandler.runQuery(sql: sql2)){
                return false;
            }
        }
        return true;
    }
    
    /// This method adds a new program
    ///
    /// - Parameter a: Program object to add
    /// - Returns: True if successful, false if not
    public func addProgram(a : AMGProgram) -> Bool {
        let sql1 : String = String(format: "select * from program where where program_name = '%@' and college_id = '%@'",a.name,a.college.id);
        if(databaseHandler.query(sql: sql1).count == 0){
            let sql2 : String = String(format: "insert into program(program_name,college_id) values ('%@','%@')",a.name,a.college.id);
            if(!databaseHandler.runQuery(sql: sql2)){
                return false;
            }
        }
        return true;
    }

    
    /// This method adds any Grader related object to the database
    ///
    /// - Parameter a: Grader object to add
    /// - Returns: True if successful, false if not
    public func addGraderObject(a : Any?) -> Bool {
        if((a as? AMGCollege) != nil){
            let fullObject = (a as! AMGCollege);
            if(!addCollege(a: fullObject)){
                return false;
            }
        }
        else if((a as? AMGCourse) != nil){
            let fullObject = (a as! AMGCourse);
            if(!addCourse(a: fullObject)){
                return false;
            }
        }
        else if((a as? AMGGrade) != nil){
            let fullObject = (a as! AMGGrade);
            if(!addGrade(a: fullObject)){
                return false;
            }
        }
        else if((a as? AMGGradeType) != nil){
            let fullObject = (a as! AMGGradeType);
            if(!addGradeType(a: fullObject)){
                return false;
            }
        }
        else if((a as? AMGGradeWeight) != nil){
            let fullObject = (a as! AMGGradeWeight);
            if(!addGradeWeight(a: fullObject)){
                return false;
            }
        }
        else if((a as? AMGInstitution) != nil){
            let fullObject = (a as! AMGInstitution);
            if(!addInstitution(a: fullObject)){
                return false;
            }
        }
        else if((a as? AMGInstructor) != nil){
            let fullObject = (a as! AMGInstructor);
            if(!addInstructor(a: fullObject)){
                return false;
            }
        }
        else if((a as? AMGProgram) != nil){
            let fullObject = (a as! AMGProgram);
            if(!addProgram(a: fullObject)){
                return false;
            }
        }
        return true;
    }
}
