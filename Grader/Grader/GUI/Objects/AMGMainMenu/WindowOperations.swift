//
//  AMGInitializeWindowMenu.swift
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGMainMenu{
    
    func initializeWindowMenu(){
        windowMenu = NSMenuItem();
        windowMenu.title = "Window";
        windowMenu.submenu = NSMenu(title: "Window");
        self.addItem(windowMenu);
        
        initializeCloseWindowMenu();
        initializeFeedbackMenu();
        initializeZoomInMenu();
        initializeZoomOutMenu();
    }
    
    private func initializeCloseWindowMenu(){
        closeWindowMenu = NSMenuItem();
        closeWindowMenu.title = "Close";
        closeWindowMenu.target = self;
        closeWindowMenu.keyEquivalent = "w";
        closeWindowMenu.keyEquivalentModifierMask = [.command];
        closeWindowMenu.action = #selector(closeWindowEx);
        windowMenu.submenu?.addItem(closeWindowMenu);
    }
    
    private func initializeFeedbackMenu(){
        feedbackMenu = NSMenuItem();
        feedbackMenu.title = "Feedback";
        feedbackMenu.target = self;
        feedbackMenu.keyEquivalent = "";
        feedbackMenu.keyEquivalentModifierMask = [.command];
        feedbackMenu.action = #selector(showFeedback);
        windowMenu.submenu?.addItem(feedbackMenu);
        
        feedbackWindow = AMGFeedbackView.init(frame: NSRect.init(x: 30, y: 200, width: 600, height: 400));
        feedbackWindow?.contentView?.wantsLayer = true;
    }

    private func initializeZoomOutMenu(){
        zoomOutMenu = NSMenuItem();
        zoomOutMenu.title = "Zoom Out";
        zoomOutMenu.target = self;
        zoomOutMenu.keyEquivalent = "-";
        zoomOutMenu.keyEquivalentModifierMask = [.command,.shift];
        zoomOutMenu.action = #selector(zoomOutEx);
        windowMenu.submenu?.addItem(zoomOutMenu);
    }

    private func initializeZoomInMenu(){
        zoomInMenu = NSMenuItem();
        zoomInMenu.title = "Zoom In";
        zoomInMenu.target = self;
        zoomInMenu.keyEquivalent = "+";
        zoomInMenu.keyEquivalentModifierMask = [.command,.shift];
        zoomInMenu.action = #selector(zoomInEx);
        windowMenu.submenu?.addItem(zoomInMenu);
    }
    
    public func zoomInEx(){
        (NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.institutionTree.enclosingScrollView?.magnification += 0.05;
        (NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.propertySheet.enclosingScrollView?.magnification += 0.05;
        (NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.tableView.enclosingScrollView?.magnification += 0.05;
    }
    
    public func zoomOutEx(){
        (NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.institutionTree.enclosingScrollView?.magnification -= 0.05;
        (NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.propertySheet.enclosingScrollView?.magnification -= 0.05;
        (NSApp.mainWindow?.contentView as! AMGBasicGUI).appWrapper?.tableView.enclosingScrollView?.magnification -= 0.05;
    }
}
