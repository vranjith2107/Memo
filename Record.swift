//
//  Record.swift
//  Memo1.0
//
//  Created by Ranjith on 7/16/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import Foundation


final class Record{
    
    private var dataRecord = [Meme]()
    
    
    func addItem(item:Meme) {
        dataRecord.append(item)
    }
    
    func getData()->[Meme]{
        return dataRecord
    }
    
    func deleteMeme(indexpath:Int){
        dataRecord.removeAtIndex(indexpath)
    }
    
    class var imageSave:Record{
        struct singletonWrapper {
            static let singleton = Record()
        }
        return singletonWrapper.singleton
    }
}