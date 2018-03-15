//
//  AMGGraderDeleteOps.swift
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
    
    
    /// This method deletes the given object and any related objects
    ///
    /// - Parameter a: AMGGrader related object
    /// - Returns: True if successful, false if not
    public func deleteObjectEx(a : Any!) -> Bool {
        if((a as? AMGUser) != nil){
            let tempObject : AMGUser = (a as! AMGUser);
            if(!databaseHandler.runQuery(sql: String(format: "delete from grade where student_id = '%@'",tempObject.id))) {
                audit(action: "Delete object", msg: String(format: "Failed to delete grades for (%@): %@",tempObject.id,databaseHandler.lastError));
                return false;
            }
        }
        else if((a as? AMGInstitution) != nil){
            let tempObject : AMGInstitution = (a as! AMGInstitution);
            for college in tempObject.colleges {
                if(!deleteObjectEx(a: college)) {
                    return false;
                }
            }
            if(!databaseHandler.runQuery(sql: String(format: "delete from institution where institution_id = '%@'",tempObject.id))){
                audit(action: "Delete object", msg: String(format: "Failed to delete institution ($@): %@",tempObject.id,databaseHandler.lastError));
                return false;
            }
        }
        else if((a as? AMGGradeWeight) != nil){
            let tempObject : AMGGradeWeight = (a as! AMGGradeWeight);
            if(!databaseHandler.runQuery(sql: String(format: "delete from grade_weight where grade_weight_id = '%@'",tempObject.id))) {
                audit(action: "Delete object", msg: String(format: "Failed to delete grade weight (%@): %@",tempObject.id,databaseHandler.lastError));
                return false;
            }
        }
        else if((a as? AMGGradeType) != nil){
            let tempObject : AMGGradeType = (a as! AMGGradeType);
            if(!databaseHandler.runQuery(sql: String(format: "delete from grade_type where grade_type_id = '%@'",tempObject.id))) {
                audit(action: "Delete object", msg: String(format: "Failed to delete grade_type (%@): %@",tempObject.id,databaseHandler.lastError));
                return false;
            }
        }
        else if((a as? AMGCourse) != nil){
            let tempObject : AMGCourse = (a as! AMGCourse);
            if(!databaseHandler.runQuery(sql: String(format: "delete from grade_weidght where course_id = '%@'",tempObject.id))){
                audit(action: "Delete object", msg: String(format: "Failed to delete grade_weights for (%@): %@",tempObject.id,databaseHandler.lastError));
                return false;
            }
            else{
                if(!databaseHandler.runQuery(sql: String(format: "delete from grade where course_id = '%@'",tempObject.id))){
                    audit(action: "Delete object", msg: String(format: "Failed to delete grades for course (%@): %@",tempObject.id,databaseHandler.lastError));
                    return false;
                }
                if(!databaseHandler.runQuery(sql: String(format: "delete from course where course_id = '%@'",tempObject.id))){
                    audit(action: "Delete object", msg: String(format: "Failed to delete course (%@): %@",tempObject.id,databaseHandler.lastError));
                    return false;
                }
            }
        }
        else if((a as? AMGCollege) != nil){
            let tempObject : AMGCollege = (a as! AMGCollege);
            for student in tempObject.students {
                if(!deleteObjectEx(a: student)){
                    return false;
                }
            }
            for instructor in tempObject.instructors {
                if(!deleteObjectEx(a: instructor)) {
                    return false;
                }
            }
            for course in tempObject.courses {
                if(!deleteObjectEx(a: course)){
                    return false;
                }
            }
            for program in tempObject.programs {
                if(!deleteObjectEx(a: program)) {
                    return false;
                }
            }
        }
        else if((a as? AMGProgram) != nil){
            let tempObject : AMGProgram = (a as! AMGProgram);
            if(!databaseHandler.runQuery(sql: String(format: "delete from program where program_id = '%@'",tempObject.id))){
                audit(action: "Delete object", msg: String(format: "Failed to delete program (%@): %@",tempObject.id,databaseHandler.lastError));
                return false;
            }
        }
        return true;
    }
}

