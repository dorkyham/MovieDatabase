//
//  ViewController.swift
//  MovieDatabase
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainController: UIViewController {

    let movieViewModel = MovieViewModel()
    
    @IBOutlet weak var bannerSliderCV: UICollectionView!
    @IBOutlet weak var popularMoviesCV: UICollectionView!
    
    
    @IBOutlet weak var comingSoonMoviesCV: UICollectionView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            movieViewModel.getMoviesBanner()
            movieViewModel.getPopularMovies()
            movieViewModel.getComingSoonMovies()
            setCollectionView()
            // bind posts yang ada pada viewmodel ke tablePost
         
            movieViewModel.banners.bind(to: bannerSliderCV.rx.items(cellIdentifier: "bannerCell", cellType: SliderImageCVCell.self)){row, banner, cell in
                // set data ke label title dari view cell
                DispatchQueue.main.async {
                    cell.imageView.downloaded(from: "http://image.tmdb.org/t/p/w500\(banner.backdrop_path!)")
                }
            }.disposed(by: disposeBag)
            
            movieViewModel.popularMovies.bind(to: popularMoviesCV.rx.items(cellIdentifier: "popularCell", cellType: ComingSoonMovieCVCell.self)){row, movie, cell in
                       // set data ke label title dari view cell
                cell.imageView.downloaded(from: "http://image.tmdb.org/t/p/w500\(movie.poster_path!)")
            }.disposed(by: disposeBag)
            
            movieViewModel.comingSoonMovies.bind(to: comingSoonMoviesCV.rx.items(cellIdentifier: "comingSoonCell", cellType: ComingSoonMovieCVCell.self)){row, movie, cell in
                       // set data ke label title dari view cell
                cell.imageView.downloaded(from: "http://image.tmdb.org/t/p/w500\(movie.poster_path!)")
            }.disposed(by: disposeBag)
            
            comingSoonMoviesCV
            .rx
            .modelAndIndexSelected(MovieModel.self)
            .subscribe(onNext: { (model, index) in
                //Your code
                let storyBoard: UIStoryboard = UIStoryboard(name: "MovieDetail", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "movieDetail") as! MovieDetailController

                vc.movie = model

                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
            
            popularMoviesCV
            .rx
            .modelAndIndexSelected(MovieModel.self)
            .subscribe(onNext: { (model, index) in
                //Your code
                let storyBoard: UIStoryboard = UIStoryboard(name: "MovieDetail", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "movieDetail") as! MovieDetailController

                vc.movie = model

                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
            // Do any additional setup after loading the view.
        }
        
        func setCollectionView(){
            bannerSliderCV.register(UINib(nibName: "SliderImageCVCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
            comingSoonMoviesCV.register(UINib(nibName: "ComingSoonMovieCVCell", bundle: nil), forCellWithReuseIdentifier: "comingSoonCell")
            popularMoviesCV.register(UINib(nibName: "ComingSoonMovieCVCell", bundle: nil), forCellWithReuseIdentifier: "popularCell")
        }
        
        
    }

    extension UIImageView {
        func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
        func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    }

    extension Reactive where Base: UICollectionView {
        public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
            ControlEvent(events: Observable.zip(
                self.modelSelected(modelType),
                self.itemSelected
            ))
        }
    }
