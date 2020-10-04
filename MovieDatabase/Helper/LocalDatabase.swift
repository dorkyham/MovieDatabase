//
//  LocalDatabase.swift
//  MovieDatabase
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import Foundation

import CoreData
import UIKit

class LocalDatabase {
    let api_key = "412004bc31e3d37391d67402e852538b"
    var page = 1
    var totalPage = 25
    
    func loadData(){
        repeat{
            fetchingDataWithURL()
            self.page+=1
        }while page != totalPage
    }
    
    func fetchingDataWithURL(){
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(api_key)&language=en-US&include_adult=false&include_video=false&page=\(page)") else {
            print("invalid")
            return
        }
        // fetch data menggunakan URLSession
        URLSession.shared.dataTask(with: url){(data, response, error) in
            do{
                let response = try! JSONDecoder().decode(Response.self, from: data!)
                
                self.totalPage = response.total_pages
                for res in response.results{
                    DispatchQueue.main.async {
                        self.save(movieData: res, entityName: "Movie")
                    }
                }
            }catch let err{
                print(err)
            }
        }.resume()
    }
    
    func save(movieData: MovieModel, entityName: String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: entityName,
                                   in: managedContext)!
      
      let movie = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
        movie.setValue(movieData.title, forKeyPath: "title")
        movie.setValue(movieData.release_date, forKeyPath: "release_date")
        movie.setValue(movieData.id, forKeyPath: "id")
        movie.setValue(movieData.poster_path, forKeyPath: "poster_path")
        movie.setValue(movieData.backdrop_path, forKeyPath: "backdrop_path")
        movie.setValue(movieData.original_language, forKeyPath: "original_language")
        movie.setValue(movieData.overview, forKeyPath: "overview")
        movie.setValue(movieData.vote_average, forKeyPath: "vote_average")
        movie.setValue(movieData.original_title, forKeyPath: "original_title")
        movie.setValue(movieData.genre_ids, forKeyPath: "genre_ids")
      // 4
      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    // fungsi refrieve semua data
    func retrieve(entityName:String) -> [MovieModel]{
        
        var movies = [MovieModel]()
        
        // referensi ke AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach{ movie in
                movies.append(
                    MovieModel(id: movie.value(forKey: "id") as? Int, poster_path: movie.value(forKey: "poster_path") as? String, title: movie.value(forKey: "title") as? String, original_language: movie.value(forKey: "original_language") as? String, original_title: (movie.value(forKey: "original_title") as? String), backdrop_path: movie.value(forKey: "backdrop_path") as? String, genre_ids: movie.value(forKey: "genre_ids") as? [Int], vote_average: movie.value(forKey: "vote_average") as? Float, overview: (movie.value(forKey: "overview") as! String), release_date: movie.value(forKey: "release_date") as? String)
                )
            }
        } catch let err{
            print(err)
        }
        
        return movies
        
    }
    
    func isEntityExists(id: Int) -> Bool {
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)

        // referensi ke AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        var results: [NSManagedObject] = []

        do {
            results = try managedContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results.count > 0
    }
    
    func deleteRecordsWithID(id:Int){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        request.predicate = NSPredicate(format: "id = %d", id)
        
        if let results = try? context.fetch(request) as? [NSManagedObject] {
            // Delete _all_ objects:
            for object in results {
                context.delete(object)
            }

            // Or delete first object:
            if results.count > 0 {
                context.delete(results[0])
            }

        } else {
            // ... fetch failed, report error
            print("error executing fetch request")
        }
    }
}

