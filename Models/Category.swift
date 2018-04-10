//
//  Category.swift
//  CheckNow
//
//  Created by Khari Moore on 2/7/18.
//  Copyright © 2018 Khari Moore. All rights reserved.
//

import Foundation
class Category{
    var CategoryId: Int64?
    var Name: String
    
    init(categoryId: Int64?, name: String){
        CategoryId = categoryId
        Name = name
    }
}
