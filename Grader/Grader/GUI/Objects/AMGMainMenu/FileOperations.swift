//
//  AMGInitializeFileMenu.swift
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGMainMenu{
    func initializeFileMenu(){
        fileMenu = NSMenuItem();
        fileMenu.title = "File";
        fileMenu.submenu = NSMenu(title: "File");
        self.addItem(fileMenu);
    }
}
