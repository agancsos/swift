//
//  CryptoOperations.swift
//  Grader
//
//  Created by Abel Gancsos on 2/3/18.
//  Copyright © 2018 Abel Gancsos. All rights reserved.
//

import Foundation
import Cocoa

extension AMGBasicGUI {
    
    public func addTokenEx(){
        if(!session.addToken()){
            if(AMGRegistry().getValue(key: "Silent") != "1"){
                AMGCommon().alert(message: "Failed to add token", title: "Error 30", fontSize: 13);
            }
            else{
                appWrapper?.refresh();
            }
        }
    }
    
    public func deleteTokenEx(){
        if(!session.deleteToken(id: (appWrapper?.properties.currenctCrypto)!)){
            if(AMGRegistry().getValue(key: "Silent") != "1"){
                AMGCommon().alert(message: "Failed to delete token", title: "Error 31", fontSize: 13);
            }
            else{
                appWrapper?.refresh();
            }
        }
    }
}
