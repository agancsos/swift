//
//  AMGInitializeViewMenu.swift
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGMainMenu{
    func initializeViewMenu(){
        viewMenu = NSMenuItem();
        viewMenu.title = "View";
        viewMenu.submenu = NSMenu(title: "View");
        self.addItem(viewMenu);
        
        initializeRefreshMenu();
        initializeErrorMenu();
        initializeGPAWindow();
    }
    
    private func initializeErrorMenu(){
        logMenu = NSMenuItem();
        logMenu.title = "Error Logs";
        logMenu.keyEquivalent = "l";
        logMenu.keyEquivalentModifierMask = [.command, .shift];
        viewMenu.submenu?.addItem(logMenu);
        logWindow = AMGTableWindow(frame2: NSRect.init(x: 30, y: 200, width: 800, height: 600), session2: session!, table: "error_log", window: "Messages");
    }
    
    private func initializeRefreshMenu(){
        refreshMenu = NSMenuItem();
        refreshMenu.title = "Refresh";
        refreshMenu.keyEquivalent = "r";
        refreshMenu.keyEquivalentModifierMask = [.command];
        viewMenu.submenu?.addItem(refreshMenu);
    }
    
    private func initializeGPAWindow(){
        gpaWindow = AMGGPAWindow(frame: NSMakeRect(50, 50, 600, 800));
        gpaWindow.session = session!;
        gpaWindowMenu.title = "View GPA";
        gpaWindowMenu.keyEquivalent = "d";
        gpaWindowMenu.target = self;
        gpaWindowMenu.keyEquivalentModifierMask = [.command,.shift];
        gpaWindowMenu.action = #selector(showGPAWindow);
        viewMenu.submenu?.addItem(gpaWindowMenu);
    }
}
