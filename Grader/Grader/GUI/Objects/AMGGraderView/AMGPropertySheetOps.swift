//
//  AMGPropertySheetOps.swift
//  Grader
//
//  Created by Abel Gancsos on 3/10/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGGraderPropertySheet {
    
    public func updateObjectEx(){
        var legacyUpdateQuery : String = "update";
        var legacyTableName   : String = "";
        var legacyUpdateID    : String = "0";
        
        if(AMGRegistry().getValue(key: "Grader.Data.UpdateService.Legacy") != "0"){
            
            if((currentObject as? AMGStudent) == nil){
                // Set table name
                if((currentObject as? AMGCollege) != nil){
                    let fullObject = (currentObject as! AMGCollege);
                    legacyTableName = "college";
                    legacyUpdateID = fullObject.id;
                }
                else if((currentObject as? AMGCourse) != nil){
                    let fullObject = (currentObject as! AMGCourse);
                    legacyTableName = "course";
                    legacyUpdateID = fullObject.id;
                    
                }
                else if((currentObject as? AMGStudent) != nil){
                    
                }
                else if((currentObject as? AMGGrade) != nil){
                    let fullObject = (currentObject as! AMGGrade);
                    legacyTableName = "grade";
                    legacyUpdateID = fullObject.id;
                }
                else if((currentObject as? AMGGradeType) != nil){
                    let fullObject = (currentObject as! AMGGradeType);
                    legacyTableName = "grade_type";
                    legacyUpdateID = fullObject.id;
                }
                else if((currentObject as? AMGGradeWeight) != nil){
                    let fullObject = (currentObject as! AMGGradeWeight);
                    legacyTableName = "grade_weight";
                    legacyUpdateID = fullObject.id;
                }
                else if((currentObject as? AMGInstitution) != nil){
                    let fullObject = (currentObject as! AMGInstitution);
                    legacyTableName = "institution";
                    legacyUpdateID = fullObject.id;
                }
                else if((currentObject as? AMGInstructor) != nil){
                    let fullObject = (currentObject as! AMGInstructor);
                    legacyTableName = "users";
                    legacyUpdateID = fullObject.id;
                }
                else if((currentObject as? AMGProgram) != nil){
                    let fullObject = (currentObject as! AMGProgram);
                    legacyTableName = "program";
                    legacyUpdateID = fullObject.id;
                }
                legacyUpdateQuery += String(format: " %@ set ",legacyTableName);
                
                // Loop through labels
                var cursor  : NSInteger = 0;
                for label in labels {
                    var label2 : String = label;
                    if(cursor > 0) {
                        legacyUpdateQuery += ",";
                    }
                    if(label2.contains("users_")){
                        label2 = label2.replacingOccurrences(of: "users_", with: "user_");
                    }
                    legacyUpdateQuery += String(format: "%@ = '",label2);
                    let currentField = subviews[cursor + labels.count];
                    let currentField2 = fields[cursor];
                    if((currentField as? NSTextField) != nil){
                        legacyUpdateQuery += String(format: "%@",(currentField as! NSTextField).stringValue);
                    }
                    else if((currentField as? AMGTextView) != nil){
                        legacyUpdateQuery += String(format: "%@",(currentField as! AMGTextView).string!);
                    }
                    else if((currentField as? NSPopUpButton) != nil){
                        let cursor2 : NSInteger = (currentField as! NSPopUpButton).indexOfSelectedItem;
                        if(currentField2.options.count > 0){
                            if((currentField2.options[0] as? AMGCollege) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGCollege])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? AMGInstitution) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGInstitution])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? AMGCourse) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGCourse])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? AMGGrade) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGGrade])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? AMGGradeType) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGGradeType])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? AMGGradeWeight) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGGradeWeight])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? AMGUser) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGUser])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? AMGStudent) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [AMGStudent])[cursor2].id;
                                }
                            }
                            else if((currentField2.options[0] as? String) != nil){
                                if(cursor2 > -1){
                                    legacyUpdateQuery += (currentField2.options as! [String])[cursor2];
                                }
                            }
                        }
                    }
                    legacyUpdateQuery += "'";
                    cursor += 1;
                }
                
                legacyUpdateQuery += String(format: " where %@_id = '%@'",legacyTableName,legacyUpdateID);
                legacyUpdateQuery = legacyUpdateQuery.replacingOccurrences(of: "last_updated_by = '1'", with: String(format: "last_updated_by = '%@'",NSFullUserName()));
                legacyUpdateQuery = legacyUpdateQuery.replacingOccurrences(of: "users_", with: "user_");
                if(AMGRegistry().getValue(key: "DEBUG") == "1"){
                    NSLog(legacyUpdateQuery);
                }
                (NSApp.mainWindow?.contentView as! AMGBasicGUI).session.legacyUpdateEx(a: legacyUpdateQuery);
                if(AMGRegistry().getValue(key: "GUI.TreeView.AutoRefresh") != "0"){
                    //(NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.refresh();
                    //NSApp.mainWindow?.makeFirstResponder((NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.institutionTree);
                }
            }
        }
    }
}

