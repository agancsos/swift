//
//  AMGGraderGetOps.swift
//  Grader
//
//  Created by Abel Gancsos on 3/2/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGGrader {
    /// This method retrieves all the institutions in order to build the Institution Tree view
    ///
    /// - Returns: Collection of Institution objects
    public func getInstitutions() -> [AMGInstitution] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get institutions started");
        }
        var mResult : [AMGInstitution] = [];
        let sql : String = "select * from institution";
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            let tempInstitution : AMGInstitution = AMGInstitution(row: (row as! String).components(separatedBy: "<COL>"));
            //tempInstitution.colleges = getCollegesEx(a: tempInstitution);
            mResult.append(tempInstitution);
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get institutions completed");
        }
        return mResult;
    }
    
    public func getInstitution(a : String) -> AMGInstitution{
        var mResult : AMGInstitution = AMGInstitution();
        let sql : String = String(format: "select * from institution where institution_id = '%@'",a);
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            let tempInstitution : AMGInstitution = AMGInstitution(row: (row as! String).components(separatedBy: "<COL>"));
            tempInstitution.colleges = getCollegesEx(a: tempInstitution);
            mResult = tempInstitution;
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get institutions completed");
        }
        return mResult;
    }
    
    
    /// his method retrieves all the grade types in order to build the Institution Tree view
    ///
    /// - Returns: Collection of GradeType objects
    public func getGradeTypes() -> [AMGGradeType] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get grade types started");
        }
        var mResult : [AMGGradeType] = [];
        let sql : String = "select * from grade_type";
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            mResult.append(AMGGradeType(row: (row as! String).components(separatedBy: "<COL>")));
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get grade types completed");
        }
        return mResult;
    }
    
    
    /// This method retrieves a list of students for the given college from the database
    ///
    /// - Parameter a: College object
    /// - Returns: List of Student objects
    public func getStudentsEx(a : AMGCollege) -> [AMGStudent] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get students started");
        }
        var mResult : [AMGStudent] = [];
        let sql : String = "select * from users where user_type = 'Student'";
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            let tempStudent : AMGStudent = AMGStudent(row: (row as! String).components(separatedBy: "<COL>"), program2 : AMGProgram());
            let rawResult2 = databaseHandler.query(sql: String(format: "select * from student where user_id = '%@'",tempStudent.id));
            for row2 in rawResult2 {
                tempStudent.program = getProgramEx(a: (row2 as! String).components(separatedBy: "<COL>")[1]);
                mResult.append(tempStudent);
            }
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get students completed");
        }
        return mResult;
    }
    
    /// This method retrieves a list of instructors for the given college from the database
    ///
    /// - Parameter a: College object
    /// - Returns: List of Instructor objects
    public func getInstructorsEx(a : AMGCollege) -> [AMGInstructor] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get instructors started");
        }
        var mResult : [AMGInstructor] = [];
        let sql : String = "select * from users where user_type = 'Instructor'";
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            mResult.append(AMGInstructor(base: AMGUser(row: (row as! String).components(separatedBy: "<COL>"))));
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get instructors completed");
        }
        return mResult;
    }
    
    /// This method retrieves a list of programs for the given college from the database
    ///
    /// - Parameter a: College object
    /// - Returns: List of Program objects
    public func getProgramsEx(a : AMGCollege) -> [AMGProgram] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get programs started");
        }
        var mResult : [AMGProgram] = [];
        let sql : String = String(format: "select * from program where college_id in (select college_id from college where institution_id = '%@')",a.id);
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            mResult.append(AMGProgram(row: (row as! String).components(separatedBy: "<COL>")));
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get programs completed");
        }
        return mResult;
    }
    
    /// This method retrieves a list of courses for the given college from the database
    ///
    /// - Parameter a: College object
    /// - Returns: List of Course objects
    public func getCoursesEx(a : AMGCollege) -> [AMGCourse] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get courses started");
        }
        var mResult : [AMGCourse] = [];
        let sql : String = String(format: "select * from course where college_id = '%@'",a.id);
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            let tempCourse : AMGCourse = AMGCourse(row: (row as! String).components(separatedBy: "<COL>"));
            var weights : [AMGGradeWeight] = [];
            tempCourse.college = a;
            tempCourse.instructor = getInstructorEx(a: (row as! String).components(separatedBy: "<COL>")[8]);
            
            for row2 in databaseHandler.query(sql: String(format: "select grade_weight_id from grade_weight where course_id = '%@'",tempCourse.id)){
                weights.append(getGradeWeightEx(a: row2 as! String));
            }
            tempCourse.weights = weights;
            //tempCourse.grades = getGradesEx(a: tempCourse);
            mResult.append(tempCourse);
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get courses completed");
        }
        return mResult;
    }
    
    /// This method retireves the instrucor object by id
    ///
    /// - Parameter a: Id of the instructor
    /// - Returns: Instructor object
    public func getInstructorEx(a : String) -> AMGInstructor{
        var mResult : AMGInstructor = AMGInstructor();
        if(databaseHandler.query(sql: String(format: "select * from users where user_id = '%@'",a)).count > 0){
            mResult = AMGInstructor(base: AMGUser(row: (databaseHandler.query(sql: String(format: "select * from users where user_id = '%@'",a)).object(at: 0) as! String).components(separatedBy: "<COL>")));
        }
        return mResult;
    }
    
    /// This method retrieves a list of colleges for the given institution from the database
    ///
    /// - Parameter a: Institution object
    /// - Returns: List of College objects
    public func getCollegesEx(a : AMGInstitution) -> [AMGCollege] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get colleges started");
        }
        var mResult : [AMGCollege] = [];
        let sql : String = String(format: "select * from college where institution_id = '%@'",a.id);
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            let tempCollege : AMGCollege = AMGCollege(row: (row as! String).components(separatedBy: "<COL>"));
            tempCollege.institute = a;
            //tempCollege.students = getStudentsEx(a: tempCollege);
            //tempCollege.instructors = getInstructorsEx(a: tempCollege);
            //tempCollege.courses = getCoursesEx(a: tempCollege);
            tempCollege.dean = getInstructorEx(a: (row as! String).components(separatedBy: "<COL>")[8]);
            //tempCollege.programs = getProgramsEx(a: tempCollege);
            mResult.append(tempCollege);
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get colleges completed");
        }
        return mResult;
    }
    
    /// This method retrieves a list of grades for the given course from the database
    ///
    /// - Parameter a: Course object
    /// - Returns: List of Grade objects
    public func getGradesEx(a : AMGCourse) -> [AMGGrade] {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get grades started");
        }
        var mResult : [AMGGrade] = [];
        let sql : String = String(format: "select * from grade where course_id = '%@'",a.id);
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            let tempGrade : AMGGrade = AMGGrade(row: (row as! String).components(separatedBy: "<COL>"));
            tempGrade.type = getGradeTypeEx(a:(row as! String).components(separatedBy: "<COL>")[2]);
            tempGrade.weight = getGradeWeightEx(a: (row as! String).components(separatedBy: "<COL>")[3]);
            tempGrade.student = getStudent(a: (row as! String).components(separatedBy: "<COL>")[4]);
            tempGrade.course = a;
            mResult.append(tempGrade);
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get grades completed");
        }
        return mResult;
    }
    
    /// This method retireves the college object by id
    ///
    /// - Parameter a: Id of the college
    /// - Returns: College object
    public func getCollegeEx(a : String) -> AMGCollege {
        var mResult : AMGCollege = AMGCollege();
        mResult = AMGCollege(row: (databaseHandler.query(sql: String(format: "select * from college where college_id = '%@'",a)).object(at: 0) as! String).components(separatedBy: "<COL>"));
        mResult.institute = getInstitution(a: (databaseHandler.query(sql: String(format: "select * from college where college_id = '%@'",a)).object(at: 0) as! String).components(separatedBy: "<COL>")[1]);
        mResult.dean = getInstructorEx(a: (databaseHandler.query(sql: String(format: "select * from college where college_id = '%@'",a)).object(at: 0) as! String).components(separatedBy: "<COL>")[8]);
        return mResult;
    }
    
    /// This method retireves the student object by id
    ///
    /// - Parameter a: Id of the student
    /// - Returns: Student object
    public func getStudent(a : String) -> AMGStudent {
        var mResult : AMGStudent = AMGStudent();
        mResult = AMGStudent(base: AMGUser(row: (databaseHandler.query(sql: String(format: "select * from users where user_id = '%@'",a)).object(at: 0) as! String).components(separatedBy: "<COL>")));
        mResult.program = getProgramEx(a: (databaseHandler.query(sql: String(format: "select program_id from student where user_id = '%@'",a)) as! [String])[0])
        return mResult;
    }
    
    /// This method retireves the program object by id
    ///
    /// - Parameter a: Id of the program
    /// - Returns: program object
    public func getProgramEx(a : String) -> AMGProgram{
        var mResult : AMGProgram = AMGProgram();
        if(databaseHandler.query(sql: String(format: "select * from program where program_id = '%@'",a)).count > 0){
            mResult = AMGProgram(row: (databaseHandler.query(sql: String(format: "select * from program where program_id = '%@'",a)).object(at: 0) as! String).components(separatedBy: "<COL>"));
        }
        return mResult;
    }
    
    /// This method retireves the Grade Type object by id
    ///
    /// - Parameter a: Id of the grade type
    /// - Returns: Grade Type object
    public func getGradeTypeEx(a : String) -> AMGGradeType {
        var mResult : AMGGradeType = AMGGradeType();
        let sql : String = String(format: "select * from grade_type where grade_type_id = '%@'",a);
        let rawResult = databaseHandler.query(sql: sql);
        mResult = AMGGradeType(row: (rawResult.object(at: 0) as! String).components(separatedBy: "<COL>"));
        return mResult;
    }
    
    /// This method retireves the Grade object by id
    ///
    /// - Parameter a: Id of the grade
    /// - Returns: Grade object
    public func getGradeEx(a : String) -> AMGGrade {
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get grades started");
        }
        var mResult : AMGGrade = AMGGrade();
        let sql : String = String(format: "select * from grade where grade_id = '%@'",a);
        let rawResult = databaseHandler.query(sql: sql);
        for row in rawResult {
            let tempGrade : AMGGrade = AMGGrade(row: (row as! String).components(separatedBy: "<COL>"));
            tempGrade.type = getGradeTypeEx(a:(row as! String).components(separatedBy: "<COL>")[2]);
            tempGrade.weight = getGradeWeightEx(a: (row as! String).components(separatedBy: "<COL>")[3]);
            tempGrade.student = getStudent(a: (row as! String).components(separatedBy: "<COL>")[4]);
            tempGrade.course = getCourseEx(a: (row as! String).components(separatedBy: "<COL>")[1]);
            mResult = tempGrade;
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            audit(action: "Building Institution Tree", msg: "Get grades completed");
        }
        return mResult;
    }
    
    /// This method retireves the Course object by id
    ///
    /// - Parameter a: Id of the Course
    /// - Returns: Course object
    public func getCourseEx(a : String) -> AMGCourse {
        var mResult : AMGCourse = AMGCourse();
        let sql : String = String(format: "select * from course where course_id = '%@'",a);
        let rawResult = databaseHandler.query(sql: sql);
        mResult = AMGCourse(row: (rawResult.object(at: 0) as! String).components(separatedBy: "<COL>"));
        mResult.college = getCollegeEx(a: (rawResult.object(at: 0) as! String).components(separatedBy: "<COL>")[12]);
        mResult.instructor = getInstructorEx(a: (rawResult.object(at: 0) as! String).components(separatedBy: "<COL>")[8]);
        return mResult;
    }

    
    /// This method retireves the Grade Weight object by id
    ///
    /// - Parameter a: Id of the grade weight
    /// - Returns: Grade Weight object
    public func getGradeWeightEx(a : String) -> AMGGradeWeight {
        var mResult : AMGGradeWeight = AMGGradeWeight();
        let sql : String = String(format: "select * from grade_weight where grade_weight_id = '%@'",a);
        let rawResult = databaseHandler.query(sql: sql);
        mResult = AMGGradeWeight(row: (rawResult.object(at: 0) as! String).components(separatedBy: "<COL>"));
        mResult.course = getCourseEx(a: (rawResult.object(at: 0) as! String).components(separatedBy: "<COL>")[1]);
        mResult.type = getGradeTypeEx(a: (rawResult.object(at: 0) as! String).components(separatedBy: "<COL>")[2]);
        return mResult;
    }
    
    
    /// This method retrieves the latest details for any object
    ///
    /// - Parameter a: Grader related object
    /// - Returns: Latest details for the Grader object
    public func getGraderObject(a : Any?) -> Any?{
        let mResult = AMGGrade();
        if((a as? AMGInstitution) != nil){
            return getInstitution(a: (a as! AMGInstitution).id);
        }
        else if((a as? AMGGrade) != nil){
            return getGradeEx(a: (a as! AMGGrade).id);
        }
        else if((a as? AMGGradeType) != nil){
            return getGradeTypeEx(a: (a as! AMGGradeType).id);
        }
        else if((a as? AMGGradeWeight) != nil){
            return getGradeWeightEx(a: (a as! AMGGradeWeight).id);
        }
        else if((a as? AMGCourse) != nil){
            return getCourseEx(a: (a as! AMGCourse).id);
        }
        else if((a as? AMGStudent) != nil){
            return getStudent(a: (a as! AMGStudent).id);
        }
        else if((a as? AMGInstructor) != nil){
            return getInstructorEx(a: (a as! AMGInstructor).id);
        }
        else if((a as? AMGCollege) != nil){
            return getCollegeEx(a: (a as! AMGCollege).id);
        }
        else if((a as? AMGProgram) != nil){
            return getProgramEx(a: (a as! AMGProgram).id);
        }
        return mResult;
    }
    
    public func getStudentGrades(a : Any?) -> [AMGGrade] {
        var mResult : [AMGGrade] = [];
        
        if((a as? AMGCourse) != nil){
            let sql : String = String(format: "select grade_id from grade where course_id = '%@' and student_id = '%@'",(a as! AMGCourse).id,sessionUser.id);
            let rawRecords = databaseHandler.query(sql: sql) as! [String];
            for rawRecord in rawRecords {
                mResult.append(getGradeEx(a: rawRecord));
            }
        }
        return mResult;
    }
}
