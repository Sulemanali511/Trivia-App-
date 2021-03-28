//
//  CategoryTableViewCell.swift
//  Trivia app
//
//  Created by Suleman Ali on 28/03/2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource  {

    

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var CatergoriesCV: UICollectionView!
    var CellType:QuestionTypes = .Cate
    var didSelectedItem:((_ index:Int)->())?
    var SelectedIndex = 0
    var Categories:[Category]!{
        didSet{
            if CellType == .Level{
                let flow = UICollectionViewFlowLayout()
                let height = 130
                let width = (UIScreen.main.bounds.width/3) - 5
                flow.itemSize =  CGSize(width: CGFloat(width), height: CGFloat(height) )
                flow.scrollDirection = .horizontal
                flow.minimumLineSpacing = 5
                flow.minimumInteritemSpacing = 0
                CatergoriesCV.collectionViewLayout = flow
                CatergoriesCV.isScrollEnabled = false
                lblTitle.text = "Level"
            }
            else if CellType == .Cate {
                let flow = UICollectionViewFlowLayout()
                let height = 200
                let width = 200
                flow.scrollDirection = .horizontal
                flow.itemSize =  CGSize(width: CGFloat(width), height: CGFloat(height) )
                CatergoriesCV.collectionViewLayout = flow
                CatergoriesCV.isScrollEnabled = true
                lblTitle.text = "Category"
            }
            else {
                let flow = UICollectionViewFlowLayout()
                let height = 200
                let width = 200
                flow.scrollDirection = .horizontal
                flow.itemSize =  CGSize(width: CGFloat(width), height: CGFloat(height) )
                CatergoriesCV.collectionViewLayout = flow
                CatergoriesCV.isScrollEnabled = false
                lblTitle.text = "Questions"
                
            }
            CatergoriesCV.reloadData()
            CatergoriesCV.selectItem(at: IndexPath(row: SelectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CatergoriesCV.delegate = self
        CatergoriesCV.dataSource = self
        CatergoriesCV.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        CatergoriesCV.register(UINib(nibName: "LevelCV", bundle: nil), forCellWithReuseIdentifier: "LevelCV")
        CatergoriesCV.register(UINib(nibName: "QuestionTypeCV", bundle: nil), forCellWithReuseIdentifier: "QuestionTypeCV")
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if CellType == .Cate{
        let cell =  self.CatergoriesCV.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.category = self.Categories[indexPath.row]
         return cell
        }
        else if CellType == .Level{
            let cell =  self.CatergoriesCV.dequeueReusableCell(withReuseIdentifier: "LevelCV", for: indexPath) as! LevelCV
            cell.category = self.Categories[indexPath.row]
            return cell
        }
        else {
            let cell =  self.CatergoriesCV.dequeueReusableCell(withReuseIdentifier: "QuestionTypeCV", for: indexPath) as! QuestionTypeCV
            cell.QuestioType = self.Categories[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectedItem?(indexPath.row)
    }
    
}
