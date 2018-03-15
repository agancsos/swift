//
//  AMGInstitutionTreeOps.swift
//  Grader
//
//  Created by Abel Gancsos on 3/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGInstitutionTree {
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return true;
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if(item == nil){
            return 1;
        }
        else if((item as? AMGInstitution) != nil){
            currentInstitution = (item as! AMGInstitution);
            return (item as! AMGInstitution).children.count;
        }
        else if((item as? AMGCollege) != nil){
            currentCollege = (item as! AMGCollege);
            return (item as! AMGCollege).children.count;
        }
        else if((item as? AMGCourse) != nil){
            currentCourse = (item as! AMGCourse);
            return (item as! AMGCourse).children.count;
        }
        else if((item as? BRANCH) != nil){
            switch((item as! BRANCH)){
                case .ROOT:
                    return [BRANCH.GRADETYPES,BRANCH.INSTITUTIONS].count;
                case .GRADETYPES:
                    return session.getGradeTypes().count;
                case .INSTITUTIONS:
                    return institutions.count;
                case .PROGRAMS:
                    return session.getProgramsEx(a: currentCollege).count;
                case .COURSES:
                    return session.getCoursesEx(a: currentCollege).count;
                case .GRADEWEIGHTS:
                    return currentCourse.weights.count;
                case .STUDENTS:
                    return session.getStudentsEx(a: currentCollege).count;
                case .INSTRUCTORS:
                    return session.getInstructorsEx(a: currentCollege).count;
                case .GRADES:
                    return session.getGradesEx(a: currentCourse).count;
                case .COLLEGES:
                    return session.getCollegesEx(a: currentInstitution).count;
            }
        }
        return 1;
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if(item == nil){
            return "";
        }
        else if((item as? AMGGradeType) != nil){
            return (item as! AMGGradeType).name;
        }
        else if((item as? AMGInstitution) != nil){
            return (item as! AMGInstitution).name;
        }
        else if((item as? AMGCollege) != nil){
            return (item as! AMGCollege).name;
        }
        else if((item as? AMGProgram) != nil){
            return (item as! AMGProgram).name;
        }
        else if((item as? AMGStudent) != nil){
            return String(format: "%@ %@",(item as! AMGStudent).firstName,(item as! AMGStudent).lastName);
        }
        else if((item as? AMGCourse) != nil){
            return (item as! AMGCourse).name;
        }
        else if((item as? AMGGradeWeight) != nil){
            return (item as! AMGGradeWeight).type.name;
        }
        else if((item as? AMGGrade) != nil){
            return (item as! AMGGrade).name;
        }
        else if((item as? AMGInstructor) != nil){
            return String(format: "%@ %@",(item as! AMGInstructor).firstName,(item as! AMGInstructor).lastName);
        }
        else if((item as? BRANCH) != nil){
            switch((item as! BRANCH)){
                case .ROOT:
                    return "";
                default:
                    return String(format: "%@S",AMGEnums().getBranchName(b: (item as! BRANCH)).uppercased().replacingOccurrences(of: "_", with: " "));
            }
        }
        return "";
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if(item == nil){
            return BRANCH.ROOT;
        }
        else if((item as? AMGInstitution) != nil){
            return (item as! AMGInstitution).children[index];
        }
        else if((item as? AMGCollege) != nil){
            return (item as! AMGCollege).children[index];
        }
        else if((item as? AMGCourse) != nil){
            return (item as! AMGCourse).children[index];
        }
        else if ((item as? AMGGradeWeight) != nil){
        }
        else if((item as? AMGGrade) != nil){
            
        }
        else if((item as? BRANCH) != nil){
            switch((item as! BRANCH)){
                case .ROOT:
                    return [BRANCH.GRADETYPES,BRANCH.INSTITUTIONS][index];
                case .GRADETYPES:
                    return session.getGradeTypes()[index];
                case .INSTITUTIONS:
                    return institutions[index];
                case .COLLEGES:
                    return session.getCollegesEx(a: currentInstitution)[index];
                case .PROGRAMS:
                    return session.getProgramsEx(a: currentCollege)[index];
                case .COURSES:
                    return session.getCoursesEx(a: currentCollege)[index];
                case .STUDENTS:
                    return session.getStudentsEx(a: currentCollege)[index];
                case .INSTRUCTORS:
                    return session.getInstructorsEx(a: currentCollege)[index];
                case .GRADEWEIGHTS:
                    return currentCourse.weights[index];
                case .GRADES:
                    return session.getGradesEx(a: currentCourse)[index];
            }
        }
        return "";
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if((item as? String) != nil){
            if((item as! String) == ""){
                return false;
            }
        }
        return true;
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool {
        return false;
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if((self.item(atRow: self.selectedRow) as? AMGInstitution) != nil){
            currentInstitution = (self.item(atRow: self.selectedRow) as! AMGInstitution);
        }
        else if((self.item(atRow: self.selectedRow) as? AMGCollege) != nil){
            currentCollege = (self.item(atRow: self.selectedRow) as! AMGCollege);
        }
        else if((self.item(atRow: self.selectedRow) as? AMGCourse) != nil){
            currentCourse = (self.item(atRow: self.selectedRow) as! AMGCourse);
            (NSApp.mainMenu as! AMGMainMenu).gpaWindow.titleLabel.stringValue = currentCourse.name;
            (NSApp.mainMenu as! AMGMainMenu).gpaWindow.gpaLabel.stringValue = String(format: "%.3f",AMGGraderAverage(a: session.getStudentGrades(a: currentCourse)).calculateWeightedAverage());
        }
        (self.enclosingScrollView?.superview as! AMGGraderView).switchView(a: self.item(atRow: self.selectedRow));
    }
    
    func outlineViewItemWillExpand(_ notification: Notification) {
        self.outlineViewSelectionDidChange(notification);
    }
    
    func outlineView(_ outlineView: NSOutlineView, willDisplayOutlineCell cell: Any, for tableColumn: NSTableColumn?, item: Any) {
        var themeBase : String = String(format: "%@/Contents/Resources/default",Bundle.main.bundlePath);
        if(AMGRegistry().getValue(key: "GUI.Theme") != ""){
            themeBase = String(format: "%@/Library/Application Support/Grader/%@",NSHomeDirectory(),
                               AMGRegistry().getValue(key: "GUI.Theme"));
        }
        if((((item as? BRANCH) != nil))){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_%@.png",themeBase,(AMGEnums().getBranchName(b: (item as! BRANCH)))))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_%@.png",
                    themeBase,AMGEnums().getBranchName(b: (item as! BRANCH))))!;
            }
        }
        else if((item as? AMGInstitution) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_institution.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_institution.png",
                themeBase))!;
            }
        }
        else if((item as? AMGStudent) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_student.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_student.png",
                                           themeBase))!;
            }
        }
        else if((item as? AMGInstructor) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_instructor.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_instructor.png",
                                           themeBase))!;
            }
        }
        else if((item as? AMGGrade) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_grade.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_grade.png",
                                           themeBase))!;
            }
        }
        else if((item as? AMGGradeWeight) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_grade_weight.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_grade_weight.png",
                                           themeBase))!;
            }
        }
        else if((item as? AMGGradeType) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_grade_type.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_grade_type.png",
                                           themeBase))!;
            }
        }
        else if((item as? AMGProgram) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_program.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_program.png",
                                           themeBase))!;
            }
        }
        else if((item as? AMGCourse) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_course.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_course.png",
                                           themeBase))!;
            }
        }
        else if((item as? AMGCollege) != nil){
            if(FileManager().fileExists(atPath: String(format: "%@/Icons/branch_college.png",themeBase))){
                (cell as! NSButtonCell).image = NSImage(
                    contentsOfFile: String(format: "%@/Icons/branch_college.png",
                                           themeBase))!;
            }
        }
    }
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        /*if((self.item(atRow: self.selectedRow) as? AMGHandlerBase) != nil){
           ≥ if(event.type == NSKeyDown){
                if(event.keyCode == 51){
                    if(!session.removeConnection(id: currentConnection!.id)){
                        if(AMGRegistry().getValue(key: "Silent") != "1"){
                            AMGCommon().alert(message: "Failed to remove connection cache", title: "Error 1000", fontSize: 13);
                        }
                    }
                    else{
                        self.refresh();
                        return super.performKeyEquivalent(with: event);
                    }
                }
            }
        }*/
        return super.performKeyEquivalent(with: event);
    }
}
