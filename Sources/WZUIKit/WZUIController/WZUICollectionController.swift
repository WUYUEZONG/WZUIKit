//
//  WZUICollectionController.swift
//  WZNoteSwift
//
//  Created by mntechMac on 2022/6/6.
//

import UIKit

open class WZUICollectionController: WZUIViewController {
    
    
    public lazy var collection: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: .ignoreSafeAreaScreenWidth, height: 50)
        flow.scrollDirection = .vertical
        let col = UICollectionView(frame: .zero, collectionViewLayout: flow)
        col.delegate = self
        col.dataSource = self
        col.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        col.contentInset = UIEdgeInsets(top: .wzNavgationBarHeight, left: collectionLeftEdge, bottom: .wzControlBarHeight, right: collectionRightEdge)
        return col
    }()
    
    private var topConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = collection.topAnchor.constraint(equalTo: view.topAnchor)
        bottomConstraint = collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        if #available(iOS 11.0, *) {
            leftConstraint = collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            rightConstraint = collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        } else {
            leftConstraint = collection.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            rightConstraint = collection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        }
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    
}

public extension WZUICollectionController {
    var collectionLeftEdge: CGFloat { 16 }
    var collectionRightEdge: CGFloat { 16 }
}

extension WZUICollectionController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        return cell
    }
    
    
    
    
}
