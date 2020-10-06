//
//  SearchViewModel.swift
//  MovieDB-Project
//
//  Created by Annisa Nabila Nasution on 03/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class SearchViewModel {
    var allMovies = BehaviorRelay<[MovieModel]>(value: [])
    var filteredMovies = BehaviorRelay<[MovieModel]>(value: [])
    
    func searchMovies(query:String){
        //search in core data
        
        let filtered = allMovies.value.filter({(item: MovieModel) -> Bool in
            let stringMatch = item.title?.lowercased().range(of: query.lowercased())
            return stringMatch != nil ? true : false
        })
        filteredMovies.accept(filtered)
    }
    
    func fetchingAllMoviesFromCoreData(){
        allMovies.accept(LocalDatabase().retrieve(entityName: "Movie"))
    }
    
}
