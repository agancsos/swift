//
//  AMGBaseOperations.swift
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGMainMenu{
    public func quitApp(){
        if(AMGRegistry().getValue(key: "Verbose") == "1"){
        }
        
        exit(0);
    }
    
    public func copy2(){
        let board = NSPasteboard.general();
        board.clearContents();
        NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self);
    }
    
    public func paste2(){
        NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self);
    }
    
    public func selectAll2(){
        NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: self);
    }
    
    public func cut2(){
        NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self);
    }
    
    public func aboutApp(){
    }
    
    public func newWindowEx(){
        if(AMGCommon().runCMD(path: "/usr/bin/open", params: ["-na",String(format:"%@",Bundle.main.bundlePath)]) != "error"){
            
        }
    }
    
    public func showFeedback(){
        feedbackWindow?.show();
    }
    
    public func closeWindowEx(){
        if(NSApp.mainWindow?.title != (Bundle.main.bundleIdentifier?.replacingOccurrences(of: "com.abelgancsos.", with: ""))!){
            NSApp.mainWindow?.close();
        }
    }
    
    public func showGPAWindow(){
        gpaWindow.show();
    }
}
