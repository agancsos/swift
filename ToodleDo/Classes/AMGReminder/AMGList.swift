//
//  AMGList.swift
//  Reminders++
//
//  Created by Abel Gancsos on 12/3/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps display the list view
class AMGList{
	public var name : String = "";
	public var id   : String = "0";
	public var pid  : String = "-1";
	
	/// This is the default constructor
	public init(){
		
	}
	
	/// This is the common constructor
	public init(n : String, id2 : String, pid2 : String){
		name = n;
		id = id2;
		pid = pid2;
	}
}
