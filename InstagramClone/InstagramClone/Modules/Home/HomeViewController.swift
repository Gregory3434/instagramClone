//
//  ViewController.swift
//  InstagramClone
//
//  Created by Gregory Molette on 20/01/2023.
//

import UIKit

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapShot()
    }
    
    private func setupViews() {
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: createCollectionViewLayout())
        collectionView.delegate = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        collectionView.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            
            let sectionKind = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch sectionKind {
            case .story:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)


                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.12), heightDimension: .fractionalHeight(0.14))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)

                return section
            case .post:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)


                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                             subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
                section.interGroupSpacing = 50

                return section
            }
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }

    private func setupDataSource() {
        let authorCellRegistration = UICollectionView.CellRegistration<AuthorCollectionViewCell, Author> { (cell, _, author) in
            cell.configure(with: author)
        }

        let postCellRegistration = UICollectionView.CellRegistration<PostCollectionViewCell, String> { (cell, _, post) in
        }

        dataSource = UICollectionViewDiffableDataSource <Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .author(let author):
                return collectionView.dequeueConfiguredReusableCell(using: authorCellRegistration,
                                                                    for: indexPath,
                                                                    item: author)
            case .post(let post):
                return collectionView.dequeueConfiguredReusableCell(using: postCellRegistration,
                                                                    for: indexPath,
                                                                    item: post)
            }
        })
    }

    private func applySnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.story, .post])
        let items = Author.authors
            .sorted(by: { !$0.isSeen && $1.isSeen })
            .map { Item.author($0) }
        snapshot.appendItems(items, toSection: .story)

        let postItems = [Item.post("1"), Item.post("2"), Item.post("3")]
        snapshot.appendItems(postItems, toSection: .post)

        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        switch item {
        case .author(let author):
            navigateToStory(author: author)
        case .post:
            break
        }
    }

    private func navigateToStory(author: Author) {
        let storyViewController = StoryViewController(author: author)
        navigationController?.pushViewController(storyViewController, animated: true)
    }
}

extension HomeViewController {
    private enum Section {
        case story
        case post
    }

    private enum Item: Hashable {
        case author(Author)
        case post(String)
    }
}
