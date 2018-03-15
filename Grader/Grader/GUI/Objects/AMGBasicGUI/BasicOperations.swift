//
//  AMGFileOperations.swift
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa
extension AMGBasicGUI{
    public func showLog(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Showing logs", msg: "Loading log view");
        }
        
        let tempMenu : AMGMainMenu = NSApp.mainMenu as! AMGMainMenu;
        tempMenu.logWindow?.show();
    }
    
    public func showPreferences(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Showing preferences", msg: "Loading preference view");
        }
        
        let tempMenu : AMGMainMenu = NSApp.mainMenu as! AMGMainMenu;
        tempMenu.prefWindowWin?.show();
    }
    
    public func showOpenFile(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Showing open file dialog", msg: "Loading open file dialog");
        }
        
        let openFile = NSOpenPanel();
        
        openFile.title                   = "Open database";
        openFile.showsResizeIndicator    = true;
        openFile.showsHiddenFiles        = false;
        openFile.canChooseDirectories    = false;
        openFile.canCreateDirectories    = false;
        openFile.allowsMultipleSelection = false; // May look into later
        
        // Must give this option if other extension
        if(AMGRegistry().getValue(key: "Legacy.AllowAllExtensions") != "1"){
            openFile.allowedFileTypes        = ["db", "sqlite"];
        }
        
        if (openFile.runModal() == NSModalResponseOK) {
            let result = openFile.url;
            
            if (result != nil) {
                let path = result!.path;
                let tempSQLite = AMGSQLite(path: path);
                if((AMGRegistry().getValue(key: "Troubleshooting.Decode") != "1" || AMGRegistry().getValue(key: "Troubleshooting.Unlock") != "1") && tempSQLite.query(sql: "select * from sqlite_sequence where name = 'ISGrader' and seq = '1'").count > 0) {
                    if(AMGRegistry().getValue(key: "Silent") != "1"){
                        AMGCommon().alert(message: "You cannot open a Grader configuration database", title: "Error 33", fontSize: 13);
                    }
                }
                else{
                }
            }
        }
    }
    
    public func showNewFileMenu(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
            session.audit(action: "Showing new file dialog", msg: "Loading new file dialog");
        }
        let newDialog : NSSavePanel = NSSavePanel();
        newDialog.title = "Create";
        newDialog.showsResizeIndicator    = true;
        newDialog.showsHiddenFiles        = false;
        newDialog.canCreateDirectories    = false;
        if (newDialog.runModal() == NSModalResponseOK) {
            let result = newDialog.url;
            if(result != nil){
                if(AMGSQLite(path: (result?.absoluteString.replacingOccurrences(of: "file://", with: ""))!, table: "").columns(sql: "select * from sqlite_master").count == 0){
                    session.audit(action: "Creating new file", msg: String(format: "Failed to create new SQLite file"));
                    if(AMGRegistry().getValue(key: "Silent") != "1"){
                        AMGCommon().alert(message: "Failed to create new SQLite file", title: "Error 1140", fontSize: 13);
                    }
                }
                else{
                    if(AMGRegistry().getValue(key: "Silent") != "1"){
                        AMGCommon().alert(message: "New SQLite file created", title: "Success", fontSize: 13);
                    }
                }
            }
        }
    }
    
    public func deleteSelectedObject(){
        let selectedObject = appWrapper?.institutionTree.item(atRow: (appWrapper?.institutionTree.selectedRow)!);
        if(AMGRegistry().getValue(key: "Silent") != "1"){
            session.audit(action: "Prompt confirmation for deletion", msg: "Prompt instantiated");
            let prompt : NSAlert = NSAlert();
            prompt.addButton(withTitle: "Yes");
            prompt.addButton(withTitle: "Cancel");
            prompt.alertStyle = .warning;
            prompt.delegate = self as NSAlertDelegate;
            prompt.messageText = "Are you sure that you want to delete the selected object?";
            prompt.informativeText = "Note that this will remove all child and associated objects";
            
            let buttonClicked = prompt.runModal();
            if(buttonClicked == 1000){
                session.audit(action: "Prompt confirmation for deletion", msg: "User clicked Agree");
                if(!session.deleteObjectEx(a: selectedObject)){
                    if(AMGRegistry().getValue(key: "Silent") != "0"){
                        AMGCommon().alert(message: String(format: "Failed to delete object: %@",session.databaseHandler.lastError), title: "Error 3000", fontSize: 13);
                    }
                }
            }
            appWrapper!.refresh();
        }
        else{
            session.audit(action: "Prompt confirmation for deletion", msg: "Prompt ignored for silent flag");
            if(!session.deleteObjectEx(a: selectedObject)){
                if(AMGRegistry().getValue(key: "Silent") != "0"){
                    AMGCommon().alert(message: String(format: "Failed to delete object: %@",session.databaseHandler.lastError), title: "Error 3000", fontSize: 13);
                }
            }
        }
        appWrapper!.refresh();
    }
    
    public func addSelectedObjectType(){
        let selectedObject = appWrapper?.institutionTree.item(atRow: (appWrapper?.institutionTree.selectedRow)!);
        if((selectedObject as? BRANCH) != nil){
            var newObject : Any? = "";
            switch((selectedObject as! BRANCH)){
                case .COLLEGES:
                    newObject = AMGCollege();
                    (newObject as! AMGCollege).institute = (appWrapper?.institutionTree.currentInstitution)!;
                    (newObject as! AMGCollege).name = "NEW COLLEGE";
                    break;
                case .COURSES:
                    newObject = AMGCourse();
                    (newObject as! AMGCourse).college = (appWrapper?.institutionTree.currentCollege)!;
                    (newObject as! AMGCourse).name = "NEW COURSE";
                    break;
                case .GRADES:
                    newObject = AMGGrade();
                    (newObject as! AMGGrade).course = (appWrapper?.institutionTree.currentCourse)!;
                    (newObject as! AMGGrade).student = AMGStudent(base: session.sessionUser);
                    (newObject as! AMGGrade).name = "NEW GRADE";
                    break;
                case .GRADETYPES:
                    newObject = AMGGradeType();
                    (newObject as! AMGGradeType).name = "NEW GRADE TYPE";
                    break;
                case .GRADEWEIGHTS:
                    newObject = AMGGradeWeight();
                    (newObject as! AMGGradeWeight).course = (appWrapper?.institutionTree.currentCourse)!;
                    (newObject as! AMGGradeWeight).type = session.getGradeTypes()[0];
                    break;
                case .INSTITUTIONS:
                    newObject = AMGInstitution();
                    (newObject as! AMGInstitution).name = "NEW INSTITUTION";
                    break;
                case .INSTRUCTORS:
                    newObject = AMGInstructor();
                    (newObject as! AMGInstructor).firstName = "NEW";
                    (newObject as! AMGInstructor).lastName = "INSTRUCTOR";
                    (newObject as! AMGInstructor).type = "Instructor";
                    break;
                case .PROGRAMS:
                    newObject = AMGProgram();
                    (newObject as! AMGProgram).name = "NEW PROGRAM";
                    (newObject as! AMGProgram).college = (appWrapper?.institutionTree.currentCollege)!;
                    break;
                default:
                    break;
            }
            if(!session.addGraderObject(a: newObject)){
                session.audit(action: "Add object", msg: String(format: "Failed to add object: %@",session.databaseHandler.lastError));
                if(AMGRegistry().getValue(key: "Silent") != "1"){
                    AMGCommon().alert(message: String(format: "Failed to add object: %@",session.databaseHandler.lastError), title: "Error 4000", fontSize: 13);
                }
            }
            else{
                appWrapper!.refresh();
            }
        }
    }
}
