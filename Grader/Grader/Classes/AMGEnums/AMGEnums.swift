//
//  AMGEnums.swift
//
//  Created by Abel Gancsos on 10/2/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation

/// Branches used to build out the Institution Tree View
enum BRANCH : NSInteger {
    case ROOT = 100;
    case GRADETYPES = 101;
    case INSTITUTIONS = 102;
    case COLLEGES = 103;
    case STUDENTS = 104;
    case INSTRUCTORS = 105;
    case PROGRAMS = 106;
    case COURSES = 107;
    case GRADES = 108;
    case GRADEWEIGHTS = 109;
}

/// This class helps manage and handle custom enum values
class AMGEnums {
    
    public init() {
        
    }
    
    public func getBranchName(b: BRANCH) -> String {
        
        if(b == BRANCH.ROOT){
            return "root";
        }
        else if(b == BRANCH.GRADETYPES) {
            return "grade_type";
        }
        else if(b == BRANCH.INSTITUTIONS) {
            return "institution";
        }
        else if(b == BRANCH.STUDENTS) {
            return "student";
        }
        else if(b == BRANCH.COLLEGES) {
            return "college";
        }
        else if(b == BRANCH.INSTRUCTORS) {
            return "instructor";
        }
        else if(b == BRANCH.PROGRAMS) {
            return "program";
        }
        else if(b == BRANCH.COURSES) {
            return "course";
        }
        else if(b == BRANCH.GRADES) {
            return "grade";
        }
        else if(b == BRANCH.GRADEWEIGHTS) {
            return "grade_weight";
        }
        return "";
    }
}
