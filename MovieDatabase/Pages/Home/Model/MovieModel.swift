//
//  MovieModel.swift
//  MovieDatabase
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import Foundation

struct MovieModel: Codable {
    var id : Int?
    var poster_path: String?
    var title: String?
    var original_language: String?
    var original_title :String?
    var backdrop_path:String?
    var genre_ids : [Int]?
    var vote_average : Float?
    var overview: String?
    var release_date: String?
}

struct Response : Codable{
    var results:[MovieModel]
    var total_pages:Int
}

