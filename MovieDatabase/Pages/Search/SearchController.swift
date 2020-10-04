//
//  SearchController.swift
//  MovieDatabase
//
//  Created by Annisa Nabila Nasution on 04/10/20.
//  Copyright © 2020 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchController: UIViewController {

     @IBOutlet weak var searchResultCV: UICollectionView!
       let viewModel = SearchViewModel()
       var searchController = UISearchController()
       private let disposeBag = DisposeBag()
           
       override func viewDidLoad() {
           super.viewDidLoad()
           viewModel.fetchingAllMoviesFromCoreData()
           setupCollectionView()
           setupSearchBar()

           viewModel.filteredMovies.bind(to: searchResultCV.rx.items(cellIdentifier: "resultCell", cellType: SearchResultsCVCell.self)){row, movie, cell in
                          // set data ke label title dari view cell
               cell.imageView.downloaded(from: "http://image.tmdb.org/t/p/w500\(movie.poster_path!)")
               cell.titleLb.text = movie.title
           }.disposed(by: disposeBag)
           
           searchResultCV
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

       func setupCollectionView(){
           searchResultCV.delegate = self
           searchResultCV.register(UINib(nibName: "SearchResultsCVCell", bundle: nil), forCellWithReuseIdentifier: "resultCell")
       }
           
       func setupSearchBar(){
           searchController = UISearchController(searchResultsController: nil)
           searchController.searchBar.delegate = self
           self.navigationItem.searchController = searchController
           self.navigationItem.hidesSearchBarWhenScrolling = false
           self.navigationItem.setHidesBackButton(true, animated: true)
           searchController.searchBar.isHidden = false
           searchController.obscuresBackgroundDuringPresentation = false
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

       extension SearchController : UICollectionViewDelegateFlowLayout {
           func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                  let padding: CGFloat =  50
                  let collectionViewSize = collectionView.frame.size.width - padding

                  return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
           }
       }

       extension SearchController : UISearchBarDelegate, UISearchControllerDelegate {
           func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
               //call api
               if searchBar.searchTextField.text != "" {
                   viewModel.searchMovies(query: searchBar.searchTextField.text ?? "")
               }
           }
           
           func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
               
           }
       }
