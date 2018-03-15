//
//  AMGGraderView.swift
//  Grader
//
//  Created by Abel Gancsos on 2/26/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGGraderView : NSSplitView,NSSplitViewDelegate {
    var session         : AMGGrader = AMGGrader();
    var institutionTree : AMGInstitutionTree = AMGInstitutionTree();
    var tableView       : AMGTableView = AMGTableView();
    var propertySheet   : AMGGraderPropertySheet = AMGGraderPropertySheet();

    /// This is the common constructor
    ///
    /// - Parameters:
    ///   - frame2: Margin information for the view
    ///   - session2: CryptoWiser session needed for the view
    public init (frame2 : CGRect, session2 : AMGGrader){
        super.init(frame: frame2);
        session = session2;
        initializeComponents();
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This method sets up the objects in the view
    private func initializeComponents(){
        if(AMGRegistry().getValue(key: "GUI.GraderView.Background.Solid") != "1"){
            self.alphaValue = 0.65;
        }
        subviews.append(NSScrollView());
        subviews.append(NSScrollView());
        self.setPosition(100, ofDividerAt: 0);
        for view in self.subviews{
            view.translatesAutoresizingMaskIntoConstraints = true;
            view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable];
        }
        self.isVertical = true;
        
        initializeInstitutionTree();
        initializeTable();
        initializePropertySheet();

        self.setPosition(100, ofDividerAt: 0);
    }
    
    private func initializeInstitutionTree(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Loading Institution Tree");
        }
        institutionTree = AMGInstitutionTree(frame2: self.frame, session2: session);
        institutionTree.autoresizingMask = [.viewHeightSizable,.viewWidthSizable];
        (subviews[0] as? NSScrollView)?.documentView = institutionTree;
        institutionTree.refresh();
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Done loading Institution Tree");
        }
    }
    
    private func initializeTable(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Loading table view");
        }
        tableView = AMGTableView(frame2: self.frame, table : "");
        tableView.autoresizingMask = [.viewHeightSizable,.viewWidthSizable];
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Done loading table view");
        }
    }
    
    private func initializePropertySheet(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Loading property sheet");
        }
        propertySheet = AMGGraderPropertySheet(frame2: self.frame);
        propertySheet.autoresizingMask = [.viewHeightSizable,.viewWidthSizable];
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Loading GUI", msg: "Done loading property sheet");
        }
    }
    
    public func switchView(a : Any?){
        let rawView : NSView = NSApp.windows[0].contentView!;
        if(rawView.subviews.count > 3){
            (rawView.subviews[1] as! AMGLabel).stringValue = String(format: "Rows: 0");
        }
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "GUI", msg: "Switching institution perspective");
        }
        if((a as? BRANCH) != nil){
            (subviews[1] as? NSScrollView)?.documentView = tableView;
            (NSApp.mainMenu as! AMGMainMenu).deleteRecordMenu.isEnabled = false;
            (NSApp.mainMenu as! AMGMainMenu).addRecordMenu.isEnabled = true;
            switch((a as! BRANCH)){
                case .COLLEGES:
                    tableView.tableName = "college";
                    tableView.columns = session.getColumns(table: tableView.tableName);
                    tableView.objects = (session.databaseHandler.query(sql: String(format: "select * from college where institution_id = '%@'",institutionTree.currentInstitution.id)) as! [String]);
                    break;
                case .COURSES:
                    tableView.tableName = "course";
                    tableView.columns = session.getColumns(table: tableView.tableName);
                    tableView.objects = (session.databaseHandler.query(sql: String(format: "select * from course where college_id = '%@'",institutionTree.currentCollege.id)) as! [String]);
                    break;
                case .GRADES:
                    tableView.tableName = "grade";
                    tableView.columns = session.getColumns(table: tableView.tableName);
                    tableView.objects = (session.databaseHandler.query(sql: String(format: "select * from grade where course_id = '%@'",institutionTree.currentCourse.id)) as! [String]);
                    break;
                case .GRADETYPES:
                    tableView.tableName = "grade_type";
                    tableView.columns = session.getColumns(table: tableView.tableName);
                    tableView.objects = session.getRows(table: tableView.tableName);
                    break;
                case .GRADEWEIGHTS:
                    tableView.tableName = "grade_weight";
                    tableView.columns = session.getColumns(table: tableView.tableName);
                    tableView.objects = (session.databaseHandler.query(sql: String(format: "select * from grade_weight where course_id = '%@'",institutionTree.currentCourse.id)) as! [String]);
                    break;
                case .STUDENTS:
                    tableView.tableName = "student";
                    tableView.columns = session.databaseHandler.columns(sql: "select * from users join student on users.user_id = student.user_id");
                    tableView.objects = session.databaseHandler.query(sql: "select * from users join student on users.user_id = student.user_id") as! [String];
                    break;
                case .INSTITUTIONS:
                    tableView.tableName = "institution";
                    tableView.columns = session.getColumns(table: tableView.tableName);
                    tableView.objects = session.getRows(table: tableView.tableName);
                    break;
                case .INSTRUCTORS:
                    tableView.tableName = "instructor";
                    tableView.columns = session.databaseHandler.columns(sql: "select * from users");
                    tableView.objects = session.databaseHandler.query(sql: "select * from users where user_type = 'Instructor'") as! [String];
                    break;
                case .PROGRAMS:
                    tableView.tableName = "program";
                    tableView.columns = session.getColumns(table: tableView.tableName);
                    tableView.objects = session.getRows(table: tableView.tableName);
                    break;
                default:
                    break;
            }
            tableView.refreshView();
        }
        else {
            propertySheet.institution = institutionTree.currentInstitution;
            (NSApp.mainMenu as! AMGMainMenu).deleteRecordMenu.isEnabled = true;
            (NSApp.mainMenu as! AMGMainMenu).addRecordMenu.isEnabled = false;
            propertySheet.currentObject = (session.getGraderObject(a: a) as Any);
            if((a as? AMGInstitution) != nil){
                propertySheet.labels = session.getColumns(table: "institution");
            }
            else if((a as? AMGCollege) != nil){
                propertySheet.labels = session.getColumns(table: "college");
            }
            else if((a as? AMGCourse) != nil){
                propertySheet.labels = session.getColumns(table: "course");
            }
            else if((a as? AMGStudent) != nil){
                propertySheet.labels = session.getColumns(table: "student");
                propertySheet.labels += session.getColumns(table: "users");
            }
            else if((a as? AMGUser) != nil){
                propertySheet.labels = session.getColumns(table: "users");
            }
            else if((a as? AMGProgram) != nil){
                propertySheet.labels = session.getColumns(table: "program");
            }
            else if((a as? AMGGrade) != nil){
                propertySheet.labels = session.getColumns(table: "grade");
            }
            else if((a as? AMGGradeType) != nil){
                propertySheet.labels = session.getColumns(table: "grade_type");
            }
            else if((a as? AMGGradeWeight) != nil){
                propertySheet.labels = session.getColumns(table: "grade_weight");
            }
            (subviews[1] as? NSScrollView)?.documentView = propertySheet;
            propertySheet.refrewView();
        }
    }

    public func refresh(){
        //institutionTree.institutions = session.getInstitutions();
        institutionTree.refresh();
        propertySheet.refrewView();
        tableView.refreshView();
        institutionTree.selectRowIndexes((NSIndexSet(index: 0) as IndexSet), byExtendingSelection: true);
    }
    
    public func refreshBackground(){
        if(AMGRegistry().getValue(key: "GUI.GraderView.Background.Solid") != "1"){
            self.alphaValue = 0.65;
        }
        else{
            self.alphaValue = 1.0;
        }
    }
}
