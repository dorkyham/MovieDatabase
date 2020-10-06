//
//  FavoriteViewModel.swift
//  MovieDB-Project
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteListViewModel {
    var favoriteMovies = BehaviorRelay<[MovieModel]>(value: [])
    
    func fetchingAllMoviesFromCoreData(){
        favoriteMovies.accept(LocalDatabase().retrieve(entityName: "FavoriteMovie"))
    }
    
    func removeFromFavorite(row:Int){
        LocalDatabase().deleteRecordsWithID(id: favoriteMovies.value[row].id!)
        guard var movies = try? favoriteMovies.value else { return }
        movies.remove(at: row)
        favoriteMovies.accept(movies)
        print(favoriteMovies.value)
    }
    
}
