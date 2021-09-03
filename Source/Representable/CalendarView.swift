//
//  CalendarView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/02.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    @Binding var dayOfMonthCount: [Int]
    
    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        let dayOfWeekStringArray = ["日","月","火","水","木","金","土"]
        
        @Binding var dayOfMonthCount: [Int]
        
        init(_ dayOfMonthCount: Binding<[Int]>) {
            self._dayOfMonthCount = dayOfMonthCount
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch section {
            case 0:
                return dayOfWeekStringArray.count
            case 1:
                return dayOfMonthCount.count
            default:
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerLine = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Section", for: indexPath)
            headerLine.backgroundColor = .white
            
            return headerLine
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            
            switch indexPath.section {
            case 0:
                switch indexPath.item {
                case 0:
                    cell.customView?.rootView = Text("\(dayOfWeekStringArray[indexPath.item])").foregroundColor(.red)
                case 6:
                    cell.customView?.rootView = Text("\(dayOfWeekStringArray[indexPath.item])").foregroundColor(.blue)
                default:
                    cell.customView?.rootView = Text("\(dayOfWeekStringArray[indexPath.item])").foregroundColor(.gray)
                }
            case 1:
                if dayOfMonthCount[indexPath.item] == 0 {
                    cell.customView?.rootView = Text("").foregroundColor(.gray)
                } else {
                    cell.customView?.rootView = Text("\(dayOfMonthCount[indexPath.item])").foregroundColor(.gray)
                }
            default:
                print("section error")
                cell.backgroundColor = UIColor.white
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch indexPath.section {
            case 0:
                print("選択しました: \(dayOfWeekStringArray[indexPath.item])")
            case 1:
                if dayOfMonthCount[indexPath.item] != 0 {
                    print("選択しました: \(dayOfMonthCount[indexPath.item])")
                }
            default: print("section error")
            }
        }
        
        final class Cell: UICollectionViewCell {
            fileprivate var textView = Text("")
            fileprivate var customView: UIHostingController<Text>?
            
            fileprivate override init(frame: CGRect) {
                super.init(frame: frame)
                
                customView = UIHostingController(rootView: textView)
                customView!.view.frame = CGRect(origin: .zero, size: contentView.bounds.size)
                customView!.view.backgroundColor = .white
                contentView.addSubview(customView!.view)
            }
            
            internal required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($dayOfMonthCount)
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let itemSizeWidth: CGFloat = (UIScreen.main.bounds.width - 40) / 7
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeWidth)
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(Coordinator.Cell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Section")
        collectionView.register(Coordinator.Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context _: Context) {
        uiView.reloadData()
    }
}
