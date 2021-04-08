//
//  TabBar.swift
//  MovieApp
//
//  Created by Gasho on 01.04.2021..
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .systemBlue
        setupViewControllers()
    }
    
    private func setupViewControllers(){
        viewControllers = [
            createNavigationControllers(with: UIImage(systemName: "list.star")!, listType: MovieListEndpoint.top_rated),
            createNavigationControllers(with: UIImage(systemName: "star")!, listType: MovieListEndpoint.popular),
        ]
    }
    
    private func createNavigationControllers(with
                                             image:UIImage,
                                             listType: MovieListEndpoint) -> UIViewController{
        
        let  movieListViewController = MovieListCollectionViewController.instantiate()
        movieListViewController.movieListType = listType
        let navigationController = UINavigationController(rootViewController: movieListViewController)
        navigationController.tabBarItem.title = listType.title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        movieListViewController.navigationItem.title = listType.title
        return navigationController
    }
}
