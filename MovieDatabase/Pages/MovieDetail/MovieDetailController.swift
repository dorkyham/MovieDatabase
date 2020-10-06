//
//  MovieDetailController.swift
//  MovieDB-Project
//
//  Created by Annisa Nabila Nasution on 03/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit

class MovieDetailController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
       
       @IBOutlet weak var titleLb: UILabel!
       
       @IBOutlet weak var genreLb: UILabel!
       
       @IBOutlet weak var languageLb: UILabel!
       
       @IBOutlet weak var descLb: UILabel!
       
    @IBOutlet weak var addToFavoriteBtn: UIButton!
    var movie : MovieModel?
       let movieDetailViewModel = MovieDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.downloaded(from: "http://image.tmdb.org/t/p/w500\(movie!.backdrop_path!)")
        titleLb.text = movie?.title
        genreLb.text = "\(movie?.genre_ids ?? [])"
        languageLb.text = "Original Language: \(movie?.original_language ?? "")"
        descLb.text = movie?.overview
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if movieDetailViewModel.checkIfFavoriteMovie(movieID:(movie?.id!)!){
            addToFavoriteBtn.setTitle("Remove From Favorite", for: .normal)
            addToFavoriteBtn.backgroundColor = UIColor.gray
        }else{
            addToFavoriteBtn.setTitle("Add To Favorite", for: .normal)
            addToFavoriteBtn.backgroundColor = UIColor.systemBlue
        }
    }
    
    
    func removeFromFavoriteAction() {
        movieDetailViewModel.removeFromFavorite(id: (movie?.id)!)
        let alert = UIAlertController(title: "Success", message: "Successfully remove item from favorite", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
            self.addToFavoriteBtn.setTitle("Add To Favorite", for: .normal)
            self.addToFavoriteBtn.backgroundColor = UIColor.systemBlue
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addingToFavoriteAction() {
        movieDetailViewModel.addingFavoriteToCoreData(movie: movie!)
        let alert = UIAlertController(title: "Success", message: "Successfully added to favorite", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler:{(alert: UIAlertAction!) in
            self.addToFavoriteBtn.setTitle("Remove From Favorite", for: .normal)
            self.addToFavoriteBtn.backgroundColor = UIColor.gray
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addToFavoriteIsClicked(_ sender: Any) {
        //adding to favorite
        if movieDetailViewModel.checkIfFavoriteMovie(movieID: (movie?.id)!){
            removeFromFavoriteAction()
        }else{
            addingToFavoriteAction()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
