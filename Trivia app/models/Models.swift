//
//  Models.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import Foundation
struct Category {
    var id:String!
    var name:String!
    var descriptionField:String!
    var imageName:String!
    var ColorName:String!
    init(id:String, name:String, description:String, imageName:String = "", ColorName:String = "") {
        self.id = id
        self.name = name
        self.descriptionField = description
        self.imageName = imageName
        self.ColorName = ColorName
    }
}
