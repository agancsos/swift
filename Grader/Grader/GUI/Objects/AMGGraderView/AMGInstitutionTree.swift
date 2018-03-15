//
//  AMGInstitutionTree.swift
//  Grader
//
//  Created by Abel Gancsos on 3/1/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class displays the Institution objects in the form of a tree
class AMGInstitutionTree : NSOutlineView,NSOutlineViewDelegate,NSOutlineViewDataSource {
    
    var session            : AMGGrader = AMGGrader();
    var institutions       : [AMGInstitution] = [];
    var currentInstitution : AMGInstitution = AMGInstitution();
    var currentCollege     : AMGCollege = AMGCollege();
    var currentCourse      : AMGCourse = AMGCourse();

    public init(){
        super.init(frame: NSMakeRect(0, 0, 0, 0));
        initializeComponents();
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        initializeComponents();
    }
    
    public init(frame2 : NSRect, session2 : AMGGrader) {
        super.init(frame: frame2);
        session = session2;
        initializeComponents();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeComponents(){
        self.addTableColumn(NSTableColumn(identifier: "Connections"));
        self.outlineTableColumn = self.tableColumn(withIdentifier: "Connections");
        self.tableColumns[0].headerCell.title = "Institution";
        self.indentationPerLevel = 10.0;
        self.indentationMarkerFollowsCell = true;
        if(AMGRegistry().getValue(key: "GUI.ConnectionTree.Identation") != ""){
            self.indentationPerLevel = CGFloat(Int(AMGRegistry().getValue(key: "GUI.ConnectionTree.Identation"))!);
        }
        self.headerView = nil;
        self.delegate = self;
        self.dataSource = self;
        refresh();
    }

    
    public func refresh(){
        institutions = session.getInstitutions();
        if(currentInstitution.id != ""){
            currentInstitution = (enclosingScrollView?.superview as! AMGGraderView).session.getInstitution(a: currentInstitution.id);
        }
        if(currentCollege.id != ""){
            currentCollege = (enclosingScrollView?.superview as! AMGGraderView).session.getCollegeEx(a: currentCollege.id);
        }
        if(currentCourse.id != ""){
            currentCourse = (enclosingScrollView?.superview as! AMGGraderView).session.getCourseEx(a: currentCourse.id);
        }
        reloadData();
    }
}
