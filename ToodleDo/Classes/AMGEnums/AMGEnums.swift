//
//  AMGEnums.swift
//
//  Created by Abel Gancsos on 10/2/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation

/// Branches used to build out Connection Tree
enum BRANCH : NSInteger{
	case DATABASES = 101;
	case TABLES = 102;
	case COLUMNS = 103;
}

/// This class helps manage and handle custom enum values
class AMGEnums{
	
	public init(){
		
	}
	
	public func getBranchName(b: BRANCH) -> String{
		if(b == BRANCH.DATABASES){
			return "db";
		}
		else if(b == BRANCH.TABLES){
			return "table";
		}
		else if(b == BRANCH.COLUMNS){
			return "column";
		}
		return "";
	}
}
