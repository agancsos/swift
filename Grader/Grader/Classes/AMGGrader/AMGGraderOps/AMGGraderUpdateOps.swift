//
//  AMGGraderUpdateOps.swift
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
    
    
    /// This method updates the given object in the database
    ///
    /// - Parameter a: Grader related object to update
    /// - Returns: True if successful, false if not
    public func updateObject(a : Any!) -> Bool {
        var sql : [String] = [];
        if((a as? AMGStudent) != nil){
            var tempSQL : String = "";
            let tempObject : AMGStudent = (a as! AMGStudent);
            tempSQL = String(format: "update user set user_firstname = '%@'",tempObject.firstName);
            tempSQL += String(format: ",user_lastname = '%@'",tempObject.lastName);
            tempSQL += String(format: ",user_address = '%@'",tempObject.address);
            tempSQL += String(format: ",user_city = '%@'",tempObject.city);
            tempSQL += String(format: ",user_state = '%@'",tempObject.state);
            tempSQL += String(format: ",user_zip = '%@'",tempObject.zip);
            tempSQL += String(format: ",user_country = '%@'",tempObject.country);
            tempSQL += String(format: ",last_updated_by = '%@'",NSFullUserName());
            tempSQL += String(format: " where user_id = '%@'",tempObject.id);
            sql.append(tempSQL);
            sql.append(String(format: "update student set student_number = '%@',student_startdate = '%@',student_current_gpa = '%@', program_id = '%@' where user_id = '%@'",
                              tempObject.number,tempObject.startDate,tempObject.currentGPA,tempObject.program.id,tempObject.id));
        }
        else if((a as? AMGInstitution) != nil){
            let tempObject : AMGInstitution = (a as! AMGInstitution);
            var tempSQL : String = "";
            tempSQL = String(format: "update institution set institution_name = '%@'",tempObject.name);
            tempSQL += String(format: ",institution_address = '%@'",tempObject.address);
            tempSQL += String(format: ",institution_city = '%@'",tempObject.city);
            tempSQL += String(format: ",institution_state = '%@'",tempObject.state);
            tempSQL += String(format: ",institution_zip = '%@'",tempObject.zip);
            tempSQL += String(format: ",institution_country = '%@'",tempObject.country);
            tempSQL += String(format: ",last_updated_by = '%@'",NSFullUserName());
            tempSQL += String(format: " where institution_id = '%@'",tempObject.id);
            sql.append(tempSQL);
        }
        else if((a as? AMGGradeWeight) != nil){
            let tempObject : AMGGradeWeight = (a as! AMGGradeWeight);
            var tempSQL : String = "";
            tempSQL = String(format: "update grade_weight set course_id = '%@'",tempObject.course.id);
            tempSQL += String(format: ",grade_type = '%@'",tempObject.type.id);
            tempSQL += String(format: ",grade_weight = '%d'",tempObject.weight);
            tempSQL += String(format: " where grade_weight_id = '%@'",tempObject.id);
            sql.append(tempSQL);
        }
        else if((a as? AMGGradeType) != nil){
            let tempObject : AMGGradeType = (a as! AMGGradeType);
            var tempSQL : String = "";
            tempSQL = String(format: "update grade_type set grade_type_name = '%@'",tempObject.name);
            tempSQL += String(format: ",last_updated_by = '%@'",NSFullUserName());
            tempSQL += String(format: " where grade_type_id = '%@'",tempObject.id);
            sql.append(tempSQL);
        }
        else if((a as? AMGCourse) != nil){
            let tempObject : AMGCourse = (a as! AMGCourse);
            var tempSQL : String = "";
            tempSQL = String(format: "update course set course_number = '%@'",tempObject.number);
            tempSQL += String(format: ",course_name = '%@'",tempObject.name);
            tempSQL += String(format: ",course_description = '%@'",tempObject.description);
            tempSQL += String(format: ",course_semester = '%@'",tempObject.semester);
            tempSQL += String(format: ",course_year = '%@'",tempObject.year);
            tempSQL += String(format: ",course_startdate = '%@'",tempObject.startDate);
            tempSQL += String(format: ",course_enddate = '%@'",tempObject.endDate);
            tempSQL += String(format: ",instructor_id = '%@'",tempObject.instructor.id);
            tempSQL += String(format: ",course_notes = '%@'",tempObject.notes);
            tempSQL += String(format: ",last_updated_by = '%@'",NSFullUserName());
            tempSQL += String(format: " where course_id = '%@'",tempObject.id);
            sql.append(tempSQL);
        }
        else if((a as? AMGCollege) != nil){
            let tempObject : AMGCollege = (a as! AMGCollege);
            var tempSQL : String = "";
            tempSQL = String(format: "update college set college_name = '%@'",tempObject.name);
            tempSQL += String(format: ",college_address = '%@'",tempObject.address);
            tempSQL += String(format: ",college_city = '%@'",tempObject.city);
            tempSQL += String(format: ",college_state = '%@'",tempObject.state);
            tempSQL += String(format: ",college_zip = '%@'",tempObject.zip);
            tempSQL += String(format: ",college_country = '%@'",tempObject.country);
            tempSQL += String(format: ",college_dean = '%@'",tempObject.dean.id);
            tempSQL += String(format: ",last_updated_by = '%@'",NSFullUserName());
            tempSQL += String(format: " where college_id = '%@'",tempObject.id);
            sql.append(tempSQL);
        }
        else if((a as? AMGProgram) != nil){
            let tempObject : AMGProgram = (a as! AMGProgram);
            var tempSQL : String = "";
            tempSQL = String(format: "update program set program_chair = '%@'",tempObject.chair.id);
            tempSQL += String(format: ",college_id = '%@'",tempObject.college.id);
            tempSQL += String(format: ",program_name = '%@'",tempObject.name);
            tempSQL += String(format: ",last_updated_by = '%@'",NSFullUserName());
            tempSQL += String(format: " where program_id = '%@'",tempObject.id);
            sql.append(tempSQL);
        }
        else if((a as? AMGGrade) != nil){
            let tempObject : AMGGrade = (a as! AMGGrade);
            var tempSQL : String = "";
            tempSQL = String(format: "update grade set course_id = '%@'",tempObject.course.id);
            tempSQL += String(format: ",grade_type = '%@'",tempObject.type.id);
            tempSQL += String(format: ",grade_weight = '%@'",tempObject.weight.id);
            tempSQL += String(format: ",student_id = '%@'",tempObject.student.id);
            tempSQL += String(format: ",grade_name = '%@'",tempObject.name);
            tempSQL += String(format: ",grade_notes = '%@'",tempObject.notes);
            tempSQL += String(format: ",grade_value = '%f'",tempObject.grade);
            tempSQL += String(format: ",last_updated_by = '%@'",NSFullUserName());
            tempSQL += String(format: " where grade_id = '%@'",tempObject.id);
            sql.append(tempSQL);
        }
        if(sql.count > 0){
            for s in sql {
                if(AMGRegistry().getValue(key: "Verbose") == "1"){
                    audit(action: "Update object", msg: String(format: "Update query: %@",s));
                }
                if(!databaseHandler.runQuery(sql: s)){
                    audit(action: "Update object", msg: String(format: "Failed to update object: %@",databaseHandler.lastError));
                    return false;
                }
            }
        }
        return true;
    }
    
    public func legacyUpdateEx(a : String){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Update object", msg: String(format: "Legacy query: %@",a));
        }
        if(!databaseHandler.runQuery(sql: a)){
            audit(action: "Update object", msg: String(format: "Failed to update object: %@",databaseHandler.lastError));
            if(AMGRegistry().getValue(key: "Silent") != "1"){
                AMGCommon().alert(message: String(format: "Failed to update object: %@",databaseHandler.lastError), title: "Error 6000", fontSize: 13);
            }
        }
    }
}

