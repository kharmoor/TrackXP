//
//  CategoryDetailViewModel.swift
//  CheckNow
//
//  Created by Khari Moore on 2/11/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation

extension CategoryDetailViewController{
class ViewModel{
    var Name: String
    var TypeId: Int64?
    init(name: String, typeId: Int64){
        Name = name
        TypeId = typeId
    }
}
}
