//
//  MovieDetailViewModel.swift
//  MovieDB-Project
//
//  Created by Annisa Nabila Nasution on 03/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel {
    
    func addingFavoriteToCoreData(movie:MovieModel){
        LocalDatabase().save(movieData: movie, entityName: "FavoriteMovie")
    }
    
    func checkIfFavoriteMovie(movieID:Int) -> Bool{
        return LocalDatabase().isEntityExists(id:movieID)
    }
    
    func removeFromFavorite(id:Int){
        LocalDatabase().deleteRecordsWithID(id: id)
    }
}
