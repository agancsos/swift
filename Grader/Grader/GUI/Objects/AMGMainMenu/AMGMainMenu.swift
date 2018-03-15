//
//  AMGMainMenu.swift
//
//  Created by Abel Gancsos on 8/27/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

/// This class helps manage and handle main menu events in the GUI.
class AMGMainMenu : NSMenu{
    
    /// Attributes
    var session : AMGGrader? = AMGGrader ();
    
    /// List of menu items
    /// DeveloperNOTE: Items must be organized based on parent menu
    
    // Default Menu Items
    var defaultMenu    : NSMenuItem = NSMenuItem();
    var quitMenu       : NSMenuItem = NSMenuItem();
    var aboutMenu      : NSMenuItem = NSMenuItem();
    var prefMenu       : NSMenuItem = NSMenuItem();
    var newWindow      : NSMenuItem = NSMenuItem();
    var connectionMenu : NSMenuItem = NSMenuItem();
    var prefWindowWin  : AMGPreferenceWindow? = nil;
    
    // File Menu Items
    var fileMenu       : NSMenuItem = NSMenuItem();

    // Edit Menu Items
    var myEditMenu       : NSMenuItem = NSMenuItem();
    var addRecordMenu    : NSMenuItem = NSMenuItem();
    var deleteRecordMenu : NSMenuItem = NSMenuItem();
    
    // View Menu Items
    var viewMenu       : NSMenuItem = NSMenuItem();
    var logMenu        : NSMenuItem = NSMenuItem();
    var refreshMenu    : NSMenuItem = NSMenuItem();
    var logWindow      : AMGTableWindow? = nil;
    var gpaWindow      : AMGGPAWindow = AMGGPAWindow();
    var gpaWindowMenu  : NSMenuItem = NSMenuItem();
    
        
    // Window Menu Items
    var windowMenu     : NSMenuItem = NSMenuItem();
    var closeWindowMenu: NSMenuItem = NSMenuItem();
    var feedbackMenu   : NSMenuItem = NSMenuItem();
    var feedbackWindow : AMGFeedbackView? = nil;
    var zoomInMenu     : NSMenuItem = NSMenuItem();
    var zoomOutMenu    : NSMenuItem = NSMenuItem();
    
    /// This is the constructor based on a session and frame
    ///
    /// - Parameters:
    ///   - session: Grader session for the GUI
    public init(session2 : AMGGrader ){
        //super.init(title: (Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!);
        super.init(title: "");
        session = session2;
        initializeComponents();
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// This method initializes all menu items
    func initializeComponents(){
        initializeDefaultMenu();
        initializeFileMenu();
        initializeEditMenu();
        initializeViewMenu();
        initializeWindowMenu();
    }
}
