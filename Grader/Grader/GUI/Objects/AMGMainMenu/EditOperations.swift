//
//  AMGInitializeEditMenu.swift
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGMainMenu{
    
    
    func initializeEditMenu(){
        myEditMenu.title = "Edit";
        myEditMenu.submenu = NSMenu(title: "Edit");
        for menuItem in (NSApp.mainMenu?.items[2].submenu?.items)!{
            menuItem.target = self;
            if(menuItem.title == "Copy"){
                menuItem.target = self;
                menuItem.action = #selector(copy2);
            }
            else if(menuItem.title == "Paste"){
                menuItem.target = self;
                menuItem.action = #selector(paste2);
            }
            else if(menuItem.title == "Select All"){
                menuItem.target = self;
                menuItem.action = #selector(selectAll2);
            }
            else if(menuItem.title == "Cut"){
                menuItem.target = self;
                menuItem.action = #selector(cut2);
            }
            
            NSApp.mainMenu?.items[2].submenu?.removeItem(menuItem);
            myEditMenu.submenu?.addItem(menuItem);
        }
        self.addItem(myEditMenu);
        initializeAddMenu();
        initializeDeleteMenu();
    }
    
    private func initializeAddMenu(){
        addRecordMenu = NSMenuItem(title: "Add", action: nil, keyEquivalent: "+");
        addRecordMenu.keyEquivalentModifierMask = [.command];
        myEditMenu.submenu?.addItem(addRecordMenu);
    }
    
    private func initializeDeleteMenu(){
        deleteRecordMenu = NSMenuItem(title: "Delete", action: nil, keyEquivalent: "-");
        deleteRecordMenu.keyEquivalentModifierMask = [.command];
        myEditMenu.submenu?.addItem(deleteRecordMenu);
    }
}
