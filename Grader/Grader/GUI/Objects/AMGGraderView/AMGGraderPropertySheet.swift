//
//  AMGGraderPropertySheet.swift
//  Grader
//
//  Created by Abel Gancsos on 3/5/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

class AMGGraderPropertySheet : NSView,NSTextViewDelegate,NSTextFieldDelegate {
    
    var institution   : AMGInstitution = AMGInstitution();
    var currentObject : Any = "";
    var labels        : [String] = [];
    var labelHeight   : CGFloat = 30.0;
    var fields        : [AMGFormField] = [];
    
    public init(){
        super.init(frame: NSMakeRect(0, 0, 0, 0));
    }
    
    public init(frame2 : CGRect){
        super.init(frame: frame2);
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeComponents(){
        initializeLabels();
        initializeFields();
        if(AMGRegistry().getValue(key: "GUI.Labels.Height") != ""){
            labelHeight = CGFloat((AMGRegistry().getValue(key: "GUI.Labels.Height") as NSString).floatValue);
        }
    }
    
    private func initializeLabels(){
        for label in labels{
            let tempLabel : AMGLabel = AMGLabel(frame: NSMakeRect(0, (self.frame.size.height - labelHeight * CGFloat(CGFloat(labels.index(of: label)!)) - labelHeight),self.frame.size.width / 2, labelHeight));
            var message : String = label;
            message = message.replacingOccurrences(of: "_", with: " ");
            message = message.uppercased();
            tempLabel.stringValue = message;
            tempLabel.isBordered = true;
            tempLabel.autoresizingMask = [.viewNotSizable,.viewMinYMargin];
            self.subviews.append(tempLabel);
        }
    }
    
    private func selectPopup(a : NSPopUpButton, b: AMGFormField){
        if((currentObject as? AMGCourse) != nil){
            let tempObject : AMGCourse = (currentObject as! AMGCourse);
            if((b.value[0] as? AMGInstructor) != nil){
                a.selectItem(withTitle: String(format: "%@ %@",tempObject.instructor.firstName,tempObject.instructor.lastName));
            }
            else if((b.value[0] as? AMGCollege) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.college.name));
            }
        }
        else if((currentObject as? AMGStudent) != nil){
            let tempObject : AMGStudent = (currentObject as! AMGStudent);
            if((b.value[0] as? String) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.type));
            }
            else if((b.value[0] as? AMGProgram) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.program.name));
            }
        }
        else if((currentObject as? AMGInstructor) != nil){
            let tempObject : AMGInstructor = (currentObject as! AMGInstructor);
            if((b.value[0] as? String) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.type));
            }
        }
        else if((currentObject as? AMGProgram) != nil){
            let tempObject : AMGProgram = (currentObject as! AMGProgram);
            if((b.value[0] as? AMGCollege) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.college.name))
            }
            else if((b.value[0] as? AMGInstructor) != nil){
                a.selectItem(withTitle: String(format: "%@ %@",tempObject.chair.firstName,tempObject.chair.lastName));
            }
        }
        else if((currentObject as? AMGCollege) != nil){
            let tempObject : AMGCollege = (currentObject as! AMGCollege);
            if((b.value[0] as? AMGInstitution) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.institute.name));
            }
            else if((b.value[0] as? AMGInstructor) != nil){
                a.selectItem(withTitle: String(format: "%@ %@",tempObject.dean.firstName,tempObject.dean.lastName));
            }
        }
        else if((currentObject as? AMGGradeWeight) != nil){
            let tempObject : AMGGradeWeight = (currentObject as! AMGGradeWeight);
            if((b.value[0] as? AMGCourse) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.course.name));
            }
            else if((b.value[0] as? AMGGradeType) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.type.name));
            }
        }
        else if((currentObject as? AMGGrade) != nil){
            let tempObject : AMGGrade = (currentObject as! AMGGrade);
            if((b.value[0] as? AMGGradeWeight) != nil){
                a.selectItem(withTitle: String(format: "%d",tempObject.weight.weight));
            }
            else if((b.value[0] as? AMGGradeType) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.type.name));
            }
            else if((b.value[0] as? AMGCourse) != nil){
                a.selectItem(withTitle: String(format: "%@",tempObject.course.name));
            }
            else if((b.value[0] as? AMGStudent) != nil){
                a.selectItem(withTitle: String(format: "%@ %@",tempObject.student.firstName,tempObject.student.lastName));
            }
        }

    }
    
    private func initializeFields(){
        for label in labels{
            let tempField : Any?;
            var fieldType : AMGFormField = AMGFormField();
            if((currentObject as? AMGInstitution) != nil){
                fieldType = (currentObject as! AMGInstitution).getProperty(a: label);
            }
            else if((currentObject as? AMGStudent) != nil){
                fieldType = (currentObject as! AMGStudent).getProperty(a: label);
                if(label.contains("program")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getProgramsEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCollege);
                }
            }
            else if((currentObject as? AMGInstructor) != nil){
                fieldType = (currentObject as! AMGInstructor).getProperty(a: label);
            }
            else if((currentObject as? AMGGrade) != nil){
                fieldType = (currentObject as! AMGGrade).getProperty(a: label);
                if(label.contains("weight")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCourse.weights;
                }
                else if(label.contains("grade_type")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).session.getGradeTypes();
                }
                else if(label.contains("course")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getCoursesEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCollege);
                }
                else if(label.contains("student")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getStudentsEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCollege);
                }
            }
            else if((currentObject as? AMGGradeWeight) != nil){
                fieldType = (currentObject as! AMGGradeWeight).getProperty(a: label);
                if(label.contains("grade_type")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).session.getGradeTypes();
                }
                else if(label.contains("course")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getCoursesEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCollege);
                }
            }
            else if((currentObject as? AMGGradeType) != nil){
                fieldType = (currentObject as! AMGGradeType).getProperty(a: label);
            }
            else if((currentObject as? AMGProgram) != nil){
                fieldType = (currentObject as! AMGProgram).getProperty(a: label);
                if(label.contains("college")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getCollegesEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentInstitution);
                }
                else if(label.contains("chair")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getInstructorsEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCollege);
                }
            }
            else if((currentObject as? AMGCourse) != nil){
                fieldType = (currentObject as! AMGCourse).getProperty(a: label);
                if(label.contains("instructor")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getInstructorsEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCollege);
                }
                else if(label.contains("college")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getCollegesEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentInstitution);
                }
            }
            else if((currentObject as? AMGCollege) != nil){
                fieldType = (currentObject as! AMGCollege).getProperty(a: label);
                if(label.contains("institution")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).session.getInstitutions();
                }
                else if(label.contains("dean")){
                    fieldType.options = (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.session.getInstructorsEx(a: (self.enclosingScrollView?.superview as! AMGGraderView).institutionTree.currentCollege);
                }
            }
            fields.append(fieldType);
            switch(fieldType.type){
                case .TEXT_FIELD:
                    tempField = NSTextField(frame: NSMakeRect(self.frame.size.width / 2, (self.frame.size.height - labelHeight * CGFloat(CGFloat(labels.index(of: label)!)) - labelHeight),self.frame.size.width / 2, labelHeight));
                    (tempField as! NSTextField).autoresizingMask = [.viewNotSizable,.viewMinYMargin];
                    (tempField as! NSTextField).placeholderString = label.replacingOccurrences(of: "_", with: " ").uppercased();
                    if((fieldType.value[0] as? String) != nil){
                        (tempField as! NSTextField).stringValue = fieldType.value[0] as! String;
                    }
                    if((fieldType.value[0] as? NSInteger) != nil){
                        (tempField as! NSTextField).stringValue = String(format: "%d",fieldType.value[0] as! NSInteger);
                    }
                    else if((fieldType.value[0] as? CGFloat) != nil){
                        (tempField as! NSTextField).stringValue = String(format: "%f",fieldType.value[0] as! CGFloat);
                    }
                    (tempField as! NSTextField).isBordered = true;
                    (tempField as! NSTextField).isEditable = fieldType.editable;
                    (tempField as! NSTextField).isEnabled = fieldType.editable;
                    (tempField as! NSTextField).target = self;
                    (tempField as! NSTextField).action = #selector(updateObjectEx);
                    self.subviews.append((tempField as! NSTextField));
                    break;
                case .TEXTAREA:
                    tempField = AMGTextView(frame2: NSMakeRect(self.frame.size.width / 2, (self.frame.size.height - labelHeight * CGFloat(CGFloat(labels.index(of: label)!)) - labelHeight),self.frame.size.width / 2, labelHeight), placeholder: label.replacingOccurrences(of: "_", with: " ").uppercased());
                    (tempField as! AMGTextView).autoresizingMask = [.viewNotSizable,.viewMinYMargin];
                    (tempField as! AMGTextView).string = (fieldType.value[0] as! String);
                    (tempField as! AMGTextView).isEditable = fieldType.editable;
                    (tempField as! AMGTextView).delegate = self;
                    self.subviews.append((tempField as! AMGTextView));
                    break;
                case .PASSWORD:
                    break;
                case .POPUP:
                    tempField = NSPopUpButton(frame: NSMakeRect(self.frame.size.width / 2, (self.frame.size.height - labelHeight * CGFloat(CGFloat(labels.index(of: label)!)) - labelHeight),self.frame.size.width / 2, labelHeight), pullsDown: false);
                    (tempField as! NSPopUpButton).isEnabled = fieldType.editable;
                    (tempField as! NSPopUpButton).autoresizingMask = [.viewNotSizable,.viewMinYMargin];
                    for option in fieldType.options {
                        if((option as? AMGCollege) != nil){
                            (tempField as! NSPopUpButton).addItem(withTitle: (option as! AMGCollege).name);
                            (tempField as! NSPopUpButton).tag = BRANCH.COLLEGES.rawValue;
                        }
                        else if((option as? AMGUser) != nil){
                            (tempField as! NSPopUpButton).addItem(withTitle: String(format: "%@ %@",(option as! AMGUser).firstName,(option as! AMGUser).lastName));
                            (tempField as! NSPopUpButton).tag = BRANCH.STUDENTS.rawValue;
                        }
                        else if((option as? AMGProgram) != nil){
                            (tempField as! NSPopUpButton).addItem(withTitle: (option as! AMGProgram).name);
                            (tempField as! NSPopUpButton).tag = BRANCH.PROGRAMS.rawValue;
                        }
                        else if((option as? AMGInstitution) != nil){
                            (tempField as! NSPopUpButton).addItem(withTitle: (option as! AMGInstitution).name);
                            (tempField as! NSPopUpButton).tag = BRANCH.INSTITUTIONS.rawValue;
                        }
                        else if((option as? AMGGradeType) != nil){
                            (tempField as! NSPopUpButton).addItem(withTitle: (option as! AMGGradeType).name);
                            (tempField as! NSPopUpButton).tag = BRANCH.GRADETYPES.rawValue;
                        }
                        else if((option as? AMGGradeWeight) != nil){
                            (tempField as! NSPopUpButton).addItem(withTitle: String(format: "%d",(option as! AMGGradeWeight).weight));
                            (tempField as! NSPopUpButton).tag = BRANCH.GRADEWEIGHTS.rawValue;
                        }
                        else if((option as? AMGCourse) != nil){
                            (tempField as! NSPopUpButton).addItem(withTitle: (option as! AMGCourse).name);
                            (tempField as! NSPopUpButton).tag = BRANCH.COURSES.rawValue;
                        }
                        else{
                            (tempField as! NSPopUpButton).addItem(withTitle: (option as! String));
                        }
                    }
                    (tempField as! NSPopUpButton).target = self;
                    (tempField as! NSPopUpButton).action = #selector(updateObjectEx);
                    self.subviews.append((tempField as! NSPopUpButton));
                    selectPopup(a: tempField as! NSPopUpButton, b: fieldType);
                    break;
                case .SWITCH:
                    break;
                default:
                    break;
            }
        }
    }
    
    private func clearLabelsFields(){
        for view in subviews{
            view.removeFromSuperview();
        }
        fields.removeAll();
    }
    
    public func refrewView(){
        clearLabelsFields();
        initializeLabels();
        initializeFields();
    }
}
