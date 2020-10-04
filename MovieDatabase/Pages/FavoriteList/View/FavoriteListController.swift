//
//  FavoriteListController.swift
//  MovieDatabase
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteListController: UIViewController {

    @IBOutlet weak var favoriteList: UITableView!
        let viewModel = FavoriteListViewModel()
        private let disposeBag = DisposeBag()
        override func viewDidLoad() {
            super.viewDidLoad()

            setNibForTableView()
            viewModel.fetchingAllMoviesFromCoreData()
            
            viewModel.favoriteMovies.bind(to: favoriteList.rx.items(cellIdentifier: "favoriteCell", cellType: FavoriteListCell.self)){row, movie, cell in
                // set data ke label title dari view cell
                cell.titleLb.text = movie.original_title
                cell.heartButton.isSelected = true
                cell.delegate = self
                cell.row = row
                cell.posterImgView.downloaded(from:"http://image.tmdb.org/t/p/w500\(movie.backdrop_path!)")
                cell.genrelb.text = "\(movie.genre_ids!)"
                cell.releaseDateLb.text = movie.release_date
            }.disposed(by: disposeBag)
            
            favoriteList.rx
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
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewModel.fetchingAllMoviesFromCoreData()
            favoriteList.reloadData()
        }
        
        func setNibForTableView(){
            favoriteList.delegate = self
            favoriteList.register(UINib(nibName: "FavoriteListCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
            favoriteList.tableFooterView = UIView()
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

extension FavoriteListController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
}

extension Reactive where Base: UITableView {
    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
                self.modelSelected(modelType),
                self.itemSelected
        ))
    }
}


extension FavoriteListController : CellProtocol{
    func removeFavorite(row:Int) {
        viewModel.removeFromFavorite(row: row)
    }
}
