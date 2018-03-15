//
//  AMGInitializeDefaultMenu.swift
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGMainMenu{
    func initializeDefaultMenu(){
        defaultMenu = NSMenuItem(title: "Grader", action: nil, keyEquivalent: "");
        defaultMenu.submenu = NSMenu();
        self.addItem(defaultMenu);
        
        initializeAboutMenu();
        initializePrefMenu();
        initializeNewWindowMenu();
        initializeQuitMenu();
    }

    private func initializeQuitMenu(){
        quitMenu.title = String(format: "Quit %@", (Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!);
        quitMenu.target = self;
        quitMenu.keyEquivalent = "q";
        quitMenu.keyEquivalentModifierMask = [.command];
        quitMenu.action = #selector(quitApp);
        defaultMenu.submenu?.addItem(quitMenu);
    }
    
    private func initializeAboutMenu(){
        aboutMenu.title = String(format: "About %@", (Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!);
        aboutMenu.target = self;
        aboutMenu.keyEquivalent = "";
        aboutMenu.keyEquivalentModifierMask = [.command];
        aboutMenu.action = #selector(aboutApp);
        defaultMenu.submenu?.addItem(aboutMenu);
    }
    
    private func initializePrefMenu(){
        prefMenu.title = "Preferences";
        prefMenu.keyEquivalent = ",";
        prefMenu.keyEquivalentModifierMask = [.command];
        defaultMenu.submenu?.addItem(prefMenu);
        
        // Setup the preference window
        var items : [AMGPreferenceItem] = [];
        items.append(AMGPreferenceItem.init(name2: "Wallpaper", type2: 1));
        items.append(AMGPreferenceItem.init(name2: "Silent", type2: 3));
        items.append(AMGPreferenceItem.init(name2: "Verbose", type2: 3));
        items.append(AMGPreferenceItem.init(name2: "Solid Background", type2: 3));
        items.append(AMGPreferenceItem.init(name2: "Indentation", type2: 2));

        prefWindowWin = AMGPreferenceWindow.init(frame: NSRect.init(x: 30, y: 200, width: 800, height: 600), items2: items);
        if(AMGRegistry().getValue(key: "Wallpaper") != ""){
            prefWindowWin?.contentView?.wantsLayer = true;
            if(FileManager.default.fileExists(atPath: AMGRegistry().getValue(key: "Wallpaper"))){
                prefWindowWin?.contentView?.layer?.contents = NSImage(contentsOfFile: AMGRegistry().getValue(key: "Wallpaper"))!;
                for view in (prefWindowWin?.contentView?.subviews)!{
                    if(view.className == String(format: "%@.AMGLabel",(Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!)){
                        (view as! AMGLabel).textColor = NSColor.white;
                    }
                }
            }
        }
    }

    private func initializeNewWindowMenu(){
        newWindow.title = "New Instance";
        newWindow.keyEquivalent = "w";
        newWindow.target = self;
        newWindow.action = #selector(newWindowEx);
        newWindow.keyEquivalentModifierMask = [.command, .shift];
        defaultMenu.submenu?.addItem(newWindow);
    }
}
