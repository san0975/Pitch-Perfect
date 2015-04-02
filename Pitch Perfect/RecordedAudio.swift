//
//  File.swift
//  Pitch Perfect
//
//  Created by Santosh Rawat on 3/28/15.
//  Copyright (c) 2015 Santosh Rawat. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
    self.filePathUrl = filePathUrl
    self.title = title
    }
}