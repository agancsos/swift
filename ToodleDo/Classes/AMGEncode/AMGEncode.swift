//
//  AMGEncode.swift
//  DBMS
//
//  Created by Abel Gancsos on 9/3/17.
//  Copyright © 2017 Abel Gancsos. All rights reserved.
//

import Foundation
class AMGEncode{
    public var phrase : String! = "";
    public var alg : Int! = 3;
    public var force : Bool! = false;
    private var minCharacters : Int! = 7;
    
    public init(){
        
    }
    
    public init(mphrase : String){
        phrase = mphrase;
        alg = 3;
    }
    public init(mphrase : String,malg : Int){
        phrase = mphrase;
        alg = malg;
    }
    private func splitByCount(mstr : String, count : Int) -> NSMutableArray{
        var mfinal : NSMutableArray = NSMutableArray();
        var buffer : String = "";
        var j : Int = 0;
        if(mstr.count > count){
            for i in 0 ..< mstr.count{
                j+=1;
                buffer += String(mstr[mstr.index(mstr.startIndex, offsetBy:i)]);
                if(j == count){
                    mfinal.add(buffer);
                    buffer = "";
                    j = 0;
                }
            }
            if(buffer != ""){
                mfinal.add(buffer);
            }
        }
        else{
            mfinal = NSMutableArray(array : mstr.components(separatedBy: ""));
        }
        return mfinal;
    }
    private func isInArray(value : String, array : NSArray) -> Bool{
        for i in 0 ..< array.count{
            if((array.object(at: i) as! String) == value){
                return true;
            }
        }
        return false;
    }
    public func encode() -> String{
        switch alg {
        case 1:
            return hash();
        case 2:
            return binaryEncode();
        case 3:
            return fullBinaryEncode();
        default:
            return "";
        }
    }
    public func decode() -> String{
        switch alg {
        case 1:
            return "";
        case 2:
            return binaryDecode();
        case 3:
            return fullBinaryDecode();
        default:
            return "";
        }
    }
    private func hash() -> String{
        let a : String = phrase;
        do{
            var mfinal : String = "";
            if(a == "backdoor"){
                mfinal = a;
            }
            else{
                for i in 0 ..< a.count{
                    if(a[a.index(a.startIndex,offsetBy: i)] == "a" || a[a.index(a.startIndex,offsetBy: i)]  == "A"){
                        mfinal += "00001";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "b" || a[a.index(a.startIndex,offsetBy: i)] == "B"){
                        mfinal += "00010";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "c" || a[a.index(a.startIndex,offsetBy: i)] == "C"){
                        mfinal += "00011";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "d" || a[a.index(a.startIndex,offsetBy: i)] == "D"){
                        mfinal += "00100";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "e" || a[a.index(a.startIndex,offsetBy: i)] == "A"){
                        mfinal += "00101";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "f" || a[a.index(a.startIndex,offsetBy: i)] == "F"){
                        mfinal += "00110";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "g" || a[a.index(a.startIndex,offsetBy: i)] == "G"){
                        mfinal += "00111";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "h" || a[a.index(a.startIndex,offsetBy: i)] == "H"){
                        mfinal += "01000";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "i" || a[a.index(a.startIndex,offsetBy: i)] == "I"){
                        mfinal += "01001";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "h" || a[a.index(a.startIndex,offsetBy: i)] == "H"){
                        mfinal += "01010";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "j" || a[a.index(a.startIndex,offsetBy: i)] == "J"){
                        mfinal += "01011";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "k" || a[a.index(a.startIndex,offsetBy: i)] == "K"){
                        mfinal += "01100";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "l" || a[a.index(a.startIndex,offsetBy: i)] == "L"){
                        mfinal += "01101";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "m" || a[a.index(a.startIndex,offsetBy: i)] == "M"){
                        mfinal += "01110";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "n" || a[a.index(a.startIndex,offsetBy: i)] == "N"){
                        mfinal += "01111";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "o" || a[a.index(a.startIndex,offsetBy: i)] == "O"){
                        mfinal += "10000";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "p" || a[a.index(a.startIndex,offsetBy: i)] == "P"){
                        mfinal += "10001";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "q" || a[a.index(a.startIndex,offsetBy: i)] == "Q"){
                        mfinal += "10010";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "r" || a[a.index(a.startIndex,offsetBy: i)] == "R"){
                        mfinal += "10011";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "s" || a[a.index(a.startIndex,offsetBy: i)] == "S"){
                        mfinal += "10100";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "t" || a[a.index(a.startIndex,offsetBy: i)] == "T"){
                        mfinal += "10101";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "u" || a[a.index(a.startIndex,offsetBy: i)] == "U"){
                        mfinal += "10110";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "v" || a[a.index(a.startIndex,offsetBy: i)] == "V"){
                        mfinal += "10111";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "w" || a[a.index(a.startIndex,offsetBy: i)] == "W"){
                        mfinal += "11000";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "x" || a[a.index(a.startIndex,offsetBy: i)] == "X"){
                        mfinal += "11001";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "y" || a[a.index(a.startIndex,offsetBy: i)] == "Y"){
                        mfinal += "11010";
                    }
                    if(a[a.index(a.startIndex,offsetBy: i)] == "z" || a[a.index(a.startIndex,offsetBy: i)] == "Z"){
                        mfinal += "11011";
                    }
                }
            }
            return mfinal;
        }
    }
    private func binaryEncode() -> String{
        let a : String = phrase;
        do{
            var mfinal : String = "";
            if(phrase.count > minCharacters || force){
                for i in 0 ..< phrase.count{
                    if(a[a.index(a.startIndex,offsetBy: i)] == "a"){
                        mfinal += "0000001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "b"){
                        mfinal += "0000010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "c"){
                        mfinal += "0000011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "d"){
                        mfinal += "0000100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "e"){
                        mfinal += "0000101";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "f"){
                        mfinal += "0000110";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "g"){
                        mfinal += "0000111";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "h"){
                        mfinal += "0001000";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "i"){
                        mfinal += "0001001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "j"){
                        mfinal += "0001010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "k"){
                        mfinal += "0001011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "l"){
                        mfinal += "0001100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "m"){
                        mfinal += "0001101";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "n"){
                        mfinal += "0001110";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "o"){
                        mfinal += "0001111";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "p"){
                        mfinal += "0010000";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "q"){
                        mfinal += "0010001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "r"){
                        mfinal += "0010010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "s"){
                        mfinal += "0010011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "t"){
                        mfinal += "0010100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "u"){
                        mfinal += "0010101";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "v"){
                        mfinal += "0010110";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "w"){
                        mfinal += "0010111";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "x"){
                        mfinal += "0011000";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "y"){
                        mfinal += "0011001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "z"){
                        mfinal += "0011010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "0"){
                        mfinal += "0011011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "1"){
                        mfinal += "0011100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "2"){
                        mfinal += "0011101";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "3"){
                        mfinal += "0011110";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "4"){
                        mfinal += "0011111";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "5"){
                        mfinal += "0100000";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "6"){
                        mfinal += "0100001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "7"){
                        mfinal += "0100010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "8"){
                        mfinal += "0100011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "9"){
                        mfinal += "0100100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "A"){
                        mfinal += "1000001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "B"){
                        mfinal += "1000010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "C"){
                        mfinal += "1000011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "D"){
                        mfinal += "1000100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "E"){
                        mfinal += "1000101";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "F"){
                        mfinal += "1000110";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "G"){
                        mfinal += "1000111";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "H"){
                        mfinal += "1001000";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "I"){
                        mfinal += "1001001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "J"){
                        mfinal += "1001010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "K"){
                        mfinal += "1001011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "L"){
                        mfinal += "1001100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "M"){
                        mfinal += "1001101";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "N"){
                        mfinal += "1001110";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "O"){
                        mfinal += "1001111";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "P"){
                        mfinal += "1010000";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "Q"){
                        mfinal += "1010001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "R"){
                        mfinal += "1010010";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "S"){
                        mfinal += "1010011";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "T"){
                        mfinal += "1010100";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "U"){
                        mfinal += "1010101";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "V"){
                        mfinal += "1010110";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "W"){
                        mfinal += "1010111";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "X"){
                        mfinal += "1011000";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "Y"){
                        mfinal += "1011001";
                    }
                    else if(a[a.index(a.startIndex,offsetBy: i)] == "Z"){
                        mfinal += "1011010";
                    }
                    else{
                        mfinal += ("000000" + String(a[a.index(a.startIndex,offsetBy: i)]));
                    }
                }
                return mfinal;
            }
        }
        return "";
    }
    private func binaryDecode() -> String{
        let a : String = phrase;
        var mfinal : String = "";
        do{
            if(a.count > minCharacters * 7 || force){
                let chars : NSMutableArray = self.splitByCount(mstr: a, count: 7);
                for i in 0 ..< chars.count{
                    //NSLog((chars.object(at: i) as! String));
                    if((chars.object(at: i) as! String) == "000000s"){mfinal += " ";}
                    else if((chars.object(at: i) as! String) == "0000001"){mfinal += "a";}
                    else if((chars.object(at: i) as! String) == "0000010"){mfinal += "b";}
                    else if((chars.object(at: i) as! String) == "0000011"){mfinal += "c";}
                    else if((chars.object(at: i) as! String) == "0000100"){mfinal += "d";}
                    else if((chars.object(at: i) as! String) == "0000101"){mfinal += "e";}
                    else if((chars.object(at: i) as! String) == "0000110"){mfinal += "f";}
                    else if((chars.object(at: i) as! String) == "0000111"){mfinal += "g";}
                    else if((chars.object(at: i) as! String) == "0001000"){mfinal += "h";}
                    else if((chars.object(at: i) as! String) == "0001001"){mfinal += "i";}
                    else if((chars.object(at: i) as! String) == "0001010"){mfinal += "j";}
                    else if((chars.object(at: i) as! String) == "0001011"){mfinal += "k";}
                    else if((chars.object(at: i) as! String) == "0001100"){mfinal += "l";}
                    else if((chars.object(at: i) as! String) == "0001101"){mfinal += "m";}
                    else if((chars.object(at: i) as! String) == "0001110"){mfinal += "n";}
                    else if((chars.object(at: i) as! String) == "0001111"){mfinal += "o";}
                    else if((chars.object(at: i) as! String) == "0010000"){mfinal += "p";}
                    else if((chars.object(at: i) as! String) == "0010001"){mfinal += "q";}
                    else if((chars.object(at: i) as! String) == "0010010"){mfinal += "r";}
                    else if((chars.object(at: i) as! String) == "0010011"){mfinal += "s";}
                    else if((chars.object(at: i) as! String) == "0010100"){mfinal += "t";}
                    else if((chars.object(at: i) as! String) == "0010101"){mfinal += "u";}
                    else if((chars.object(at: i) as! String) == "0010110"){mfinal += "v";}
                    else if((chars.object(at: i) as! String) == "0010111"){mfinal += "w";}
                    else if((chars.object(at: i) as! String) == "0011000"){mfinal += "x";}
                    else if((chars.object(at: i) as! String) == "0011001"){mfinal += "y";}
                    else if((chars.object(at: i) as! String) == "0011010"){mfinal += "z";}
                    else if((chars.object(at: i) as! String) == "0011011"){mfinal += "0";}
                    else if((chars.object(at: i) as! String) == "0011100"){mfinal += "1";}
                    else if((chars.object(at: i) as! String) == "0011101"){mfinal += "2";}
                    else if((chars.object(at: i) as! String) == "0011110"){mfinal += "3";}
                    else if((chars.object(at: i) as! String) == "0011111"){mfinal += "4";}
                    else if((chars.object(at: i) as! String) == "0100000"){mfinal += "5";}
                    else if((chars.object(at: i) as! String) == "0100001"){mfinal += "6";}
                    else if((chars.object(at: i) as! String) == "0100010"){mfinal += "7";}
                    else if((chars.object(at: i) as! String) == "0100011"){mfinal += "8";}
                    else if((chars.object(at: i) as! String) == "0100100"){mfinal += "9";}
                    else if((chars.object(at: i) as! String) == "1000001"){mfinal += "A";}
                    else if((chars.object(at: i) as! String) == "1000010"){mfinal += "B";}
                    else if((chars.object(at: i) as! String) == "1000011"){mfinal += "C";}
                    else if((chars.object(at: i) as! String) == "1000100"){mfinal += "D";}
                    else if((chars.object(at: i) as! String) == "1000101"){mfinal += "E";}
                    else if((chars.object(at: i) as! String) == "1000110"){mfinal += "F";}
                    else if((chars.object(at: i) as! String) == "1000111"){mfinal += "G";}
                    else if((chars.object(at: i) as! String) == "1001000"){mfinal += "H";}
                    else if((chars.object(at: i) as! String) == "1001001"){mfinal += "I";}
                    else if((chars.object(at: i) as! String) == "1001010"){mfinal += "J";}
                    else if((chars.object(at: i) as! String) == "1001011"){mfinal += "K";}
                    else if((chars.object(at: i) as! String) == "1001100"){mfinal += "L";}
                    else if((chars.object(at: i) as! String) == "1001101"){mfinal += "M";}
                    else if((chars.object(at: i) as! String) == "1001110"){mfinal += "N";}
                    else if((chars.object(at: i) as! String) == "1001111"){mfinal += "O";}
                    else if((chars.object(at: i) as! String) == "1010000"){mfinal += "P";}
                    else if((chars.object(at: i) as! String) == "1010001"){mfinal += "Q";}
                    else if((chars.object(at: i) as! String) == "1010010"){mfinal += "R";}
                    else if((chars.object(at: i) as! String) == "1010011"){mfinal += "S";}
                    else if((chars.object(at: i) as! String) == "1010100"){mfinal += "T";}
                    else if((chars.object(at: i) as! String) == "1010101"){mfinal += "U";}
                    else if((chars.object(at: i) as! String) == "1010110"){mfinal += "V";}
                    else if((chars.object(at: i) as! String) == "1010111"){mfinal += "W";}
                    else if((chars.object(at: i) as! String) == "1011000"){mfinal += "X";}
                    else if((chars.object(at: i) as! String) == "1011001"){mfinal += "Y";}
                    else if((chars.object(at: i) as! String) == "1011010"){mfinal += "Z";}
                    else{
                        mfinal += (chars.object(at: i) as! String).replacingOccurrences(of: "0", with: "");
                    }
                }
            }
        }
        return mfinal;
    }
    private func fullBinaryEncode() -> String{
        var mfinal : String = "";
        let a : String = phrase;
        let chars : String = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
        let chars1 : String = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
        do{
            if(a.count > minCharacters || force){
                for i in 0 ..< a.count{
                    let lowercaseChar = String.init(a[a.index(a.startIndex,offsetBy: i)]).lowercased();
                    if(!isInArray(value: String(a[a.index(a.startIndex,offsetBy: i)]), array:(chars.components(separatedBy: ",") as NSArray))){
                        mfinal += "1";
                    }
                    else{
                        mfinal += "0";
                    }
                    if(isInArray(value: String(a[a.index(a.startIndex,offsetBy: i)]), array:(chars1.components(separatedBy: ",") as NSArray))){
                        mfinal += "1";
                    }
                    else{
                        mfinal += "0";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: " ")))){
                        mfinal += "0000000";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "a","!")))){
                        mfinal += "0000001";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "b","")))){
                        mfinal += "0000010";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "c","#")))){
                        mfinal += "0000011";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "d","$")))){
                        mfinal += "0000100";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "e","%")))){
                        mfinal += "0000101";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "f","^")))){
                        mfinal += "0000110";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "g","&")))){
                        mfinal += "0000111";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "h","*")))){
                        mfinal += "0001000";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "i","(")))){
                        mfinal += "0001001";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "j",")")))){
                        mfinal += "0001010";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "k","-")))){
                        mfinal += "0001011";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "l","_")))){
                        mfinal += "0001100";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "m","=")))){
                        mfinal += "0001101";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "n","+")))){
                        mfinal += "0001110";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "o","~")))){
                        mfinal += "0001111";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "p","`")))){
                        mfinal += "0010000";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "q","[")))){
                        mfinal += "0010001";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "r","{")))){
                        mfinal += "0010010";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "s","]")))){
                        mfinal += "0010011";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "t","}")))){
                        mfinal += "0010100";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "u","|")))){
                        mfinal += "0010101";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "v",";")))){
                        mfinal += "0010110";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "w",":")))){
                        mfinal += "0010111";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "x","'")))){
                        mfinal += "0011000";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "y",",")))){
                        mfinal += "0011001";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "z","<")))){
                        mfinal += "0011010";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "0",".")))){
                        mfinal += "0011011";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "1",">")))){
                        mfinal += "0011100";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "2","/")))){
                        mfinal += "0011101";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "3","?")))){
                        mfinal += "0011110";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "4")))){
                        mfinal += "0011111";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "5")))){
                        mfinal += "0111111";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "6","\t")))){
                        mfinal += "1000000";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "7","\n")))){
                        mfinal += "1000001";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "8")))){
                        mfinal += "1000010";
                    }
                    if(isInArray(value: lowercaseChar, array: (NSArray(objects: "9")))){
                        mfinal += "1000011";
                    }
                }
            }
        }
        return mfinal;
    }
    private func stringFromInt(mstr : String, index : Int) -> Int{
        if(index > 0){
            let char : String = String(mstr[mstr.index(mstr.startIndex,offsetBy: index)]);
            return (char as NSString).integerValue;
        }
        else{
            return (mstr as NSString).integerValue;
        }
    }
    private func fullBinaryDecode() -> String{
        var mfinal : String = "";
        let a : String = phrase;
        let chars : NSArray = splitByCount(mstr: a, count: 9);
        do{
            if(a.count > (minCharacters * 9) || force){
                for i in 0 ..< chars.count{
                    //NSLog((chars.object(at: i) as! String));
                    let symbolFlag : Int = stringFromInt(mstr : (chars.object(at: i) as! String), index: 0);
                    let upperFlag : Int = stringFromInt(mstr : (chars.object(at: i) as! String), index: 1);
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000000"){
                        if(symbolFlag == 1){
                        }
                        else{
                            if(upperFlag == 1){
                                
                            }
                            else{
                                
                            }
                        }
                        mfinal += " ";
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000001"){
                        if(symbolFlag == 1){
                            mfinal += "!";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "A";
                            }
                            else{
                                mfinal += "a";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000010"){
                        if(symbolFlag == 1){
                            mfinal += "";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "B";
                            }
                            else{
                                mfinal += "b";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000011"){
                        if(symbolFlag == 1){
                            mfinal += "#";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "C";
                            }
                            else{
                                mfinal += "c";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000100"){
                        if(symbolFlag == 1){
                            mfinal += "$";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "D";
                            }
                            else{
                                mfinal += "d";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000101"){
                        if(symbolFlag == 1){
                            mfinal += "%%";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "E";
                            }
                            else{
                                mfinal += "e";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000110"){
                        if(symbolFlag == 1){
                            mfinal += "^";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "F";
                            }
                            else{
                                mfinal += "f";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0000111"){
                        if(symbolFlag == 1){
                            mfinal += "&";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "G";
                            }
                            else{
                                mfinal += "g";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001000"){
                        if(symbolFlag == 1){
                            mfinal += "*";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "H";
                            }
                            else{
                                mfinal += "h";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001001"){
                        if(symbolFlag == 1){
                            mfinal += "(";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "I";
                            }
                            else{
                                mfinal += "i";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001010"){
                        if(symbolFlag == 1){
                            mfinal += ")";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "J";
                            }
                            else{
                                mfinal += "j";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001011"){
                        if(symbolFlag == 1){
                            mfinal += "-";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "K";
                            }
                            else{
                                mfinal += "k";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001100"){
                        if(symbolFlag == 1){
                            mfinal += "_";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "L";
                            }
                            else{
                                mfinal += "l";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001101"){
                        if(symbolFlag == 1){
                            mfinal += "=";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "M";
                            }
                            else{
                                mfinal += "m";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001110"){
                        if(symbolFlag == 1){
                            mfinal += "+";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "N";
                            }
                            else{
                                mfinal += "n";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0001111"){
                        if(symbolFlag == 1){
                            mfinal += "~";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "O";
                            }
                            else{
                                mfinal += "o";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010000"){
                        if(symbolFlag == 1){
                            mfinal += "`";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "P";
                            }
                            else{
                                mfinal += "p";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010001"){
                        if(symbolFlag == 1){
                            mfinal += "[";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "Q";
                            }
                            else{
                                mfinal += "q";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010010"){
                        if(symbolFlag == 1){
                            mfinal += "{";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "R";
                            }
                            else{
                                mfinal += "r";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010011"){
                        if(symbolFlag == 1){
                            mfinal += "]";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "S";
                            }
                            else{
                                mfinal += "s";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010100"){
                        if(symbolFlag == 1){
                            mfinal += "}";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "T";
                            }
                            else{
                                mfinal += "t";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010101"){
                        if(symbolFlag == 1){
                            mfinal += "|";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "U";
                            }
                            else{
                                mfinal += "u";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010110"){
                        if(symbolFlag == 1){
                            mfinal += ";";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "V";
                            }
                            else{
                                mfinal += "v";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0010111"){
                        if(symbolFlag == 1){
                            mfinal += ":";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "W";
                            }
                            else{
                                mfinal += "w";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011000"){
                        if(symbolFlag == 1){
                            mfinal += "'";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "X";
                            }
                            else{
                                mfinal += "x";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011001"){
                        if(symbolFlag == 1){
                            mfinal += ",";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "Y";
                            }
                            else{
                                mfinal += "y";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011010"){
                        if(symbolFlag == 1){
                            mfinal += "<";
                        }
                        else{
                            if(upperFlag == 1){
                                mfinal += "Z";
                            }
                            else{
                                mfinal += "z";
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011011"){
                        if(symbolFlag == 1){
                            mfinal += ".";
                        }
                        else{
                            mfinal += "0";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011100"){
                        if(symbolFlag == 1){
                            mfinal += ">";
                        }
                        else{
                            mfinal += "1";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011101"){
                        if(symbolFlag == 1){
                            mfinal += "/";
                        }
                        else{
                            mfinal += "2";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011110"){
                        if(symbolFlag == 1){
                            mfinal += "?";
                        }
                        else{
                            mfinal += "3";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0011111"){
                        if(symbolFlag == 1){
                            mfinal += "\t";
                        }
                        else{
                            mfinal += "4";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "0111111"){
                        if(symbolFlag == 1){
                            mfinal += "\n";
                        }
                        else{
                            mfinal += "5";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "1000000"){
                        if(symbolFlag == 1){
                            mfinal += "";
                        }
                        else{
                            mfinal += "6";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "1000001"){
                        if(symbolFlag == 1){
                            mfinal += "";
                        }
                        else{
                            mfinal += "7";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "1000001"){
                        if(symbolFlag == 1){
                            mfinal += "";
                        }
                        else{
                            mfinal += "8";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                    if((chars.object(at: i) as! NSString).substring(from: 2) == "1000011"){
                        if(symbolFlag == 1){
                            mfinal += "";
                        }
                        else{
                            mfinal += "9";
                            if(upperFlag == 1){
                            }
                            else{
                                
                            }
                        }
                    }
                }
            }
        }
        return mfinal;
    }
}
