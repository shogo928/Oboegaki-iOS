//
//  WeekView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/10/13.
//

import SwiftUI

struct WeekView: UIViewRepresentable {
    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        var weekArray: [String] = ["日","月","火","水","木","金","土"]
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return weekArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            cell.bottomBorder.frame = CGRect(x: 0,
                                             y: cell.contentView.frame.height - 1,
                                             width: cell.contentView.frame.width,
                                             height: 1)
            cell.bottomBorder.backgroundColor = UIColor(named: "Gray200")!.cgColor
            cell.contentView.layer.addSublayer(cell.bottomBorder)
            
            switch weekArray[indexPath.item] {
            case "日":
                cell.customView?.rootView = Text("\(weekArray[indexPath.item])").foregroundColor(.red)
            case "土":
                cell.customView?.rootView = Text("\(weekArray[indexPath.item])").foregroundColor(.blue)
            default :
                cell.customView?.rootView = Text("\(weekArray[indexPath.item])").foregroundColor(.gray)
            }
            
            return cell
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<WeekView>) -> UICollectionView {
        let itemSizeWidth = (UIScreen.main.bounds.width - 53) / 7
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWidth, height: 30)
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context : UIViewRepresentableContext<WeekView>) {}
    
    final class Cell: UICollectionViewCell {
        fileprivate var textView = Text("")
        fileprivate var customView: UIHostingController<Text>?
        
        fileprivate var bottomBorder = CALayer()
        
        fileprivate override init(frame: CGRect) {
            super.init(frame: frame)
            
            customView = UIHostingController(rootView: textView)
            customView!.view.frame = CGRect(origin: .zero, size: contentView.bounds.size)
            customView!.view.backgroundColor = .clear
            contentView.addSubview(customView!.view)
        }
        
        internal required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


