//
//  MovieViewModel.swift
//  MovieDatabase
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    // membuat sebuah observer variable untuk menampung data dari post model
    // observer digunakan untuk memantau perubahan pada set data.
    var comingSoonMovies = BehaviorRelay<[MovieModel]>(value: [])
    var popularMovies = BehaviorRelay<[MovieModel]>(value: [])
    var banners = BehaviorRelay<[MovieModel]>(value: [])
    
    let api_key = "412004bc31e3d37391d67402e852538b"

    func getComingSoonMovies() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(api_key)&page=1") else {
            print("url invalid")
            return}
        // fetch data menggunakan URLSession
        URLSession.shared.dataTask(with: url){(data, response, error) in
            do{
                var response = try! JSONDecoder().decode(Response.self, from: data!)
                while response.results.count > 10 {
                    response.results.remove(at: response.results.count-1)
                }
                self.comingSoonMovies.accept(response.results)
            }catch let err{
                print(err)
            }
        }.resume()
    }
    
    func getPopularMovies() {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(api_key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1") else {return}
        
        // fetch data menggunakan URLSession
        URLSession.shared.dataTask(with: url){(data, response, error) in
            do{
                var response = try! JSONDecoder().decode(Response.self, from: data!)
                while response.results.count > 10 {
                    response.results.remove(at: response.results.count-1)
                }
                self.popularMovies.accept(response.results)
            }catch let err{
                print(err)
            }
        }.resume()
    }
    
    func getMoviesBanner(){
        
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(api_key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1") else {return}
        
        // fetch data menggunakan URLSession
        URLSession.shared.dataTask(with: url){(data, response, error) in
            do{
                var response = try! JSONDecoder().decode(Response.self, from: data!)
                while response.results.count > 3 {
                    response.results.remove(at: response.results.count-1)
                }
                self.banners.accept(response.results)
                
            }catch let err{
                print(err)
            }
        }.resume()
        
    }
    
}
