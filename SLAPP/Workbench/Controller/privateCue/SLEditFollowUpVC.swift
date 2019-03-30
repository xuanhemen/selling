//
//  SLEditFollowUpVC.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/15.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLEditFollowUpVC: BaseVC,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSourcePrefetching,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate {

    /**数据源*/
    var followModel = SLFollowUpModel()
    /**图片模型数组*/
    var dataArr = [SLFlollowUpFileModel]()
    /**图片数组*/
    var imgArr = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "修改项目跟进"
        
        let rightItem = UIBarButtonItem.init(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = rightItem
        
        /**添加尾随对象*/
        self.dataArr = followModel.filesArr
        for model in self.dataArr {
            if model.preview_url_small != "" || model.preview_url_small != nil {
                let url = URL.init(string: model.preview_url_small!)
                let data = try? Data.init(contentsOf: url!)
                let image = UIImage.init(data: data!)
                self.imgArr.append(image!)
            }
           
        }
        let addImage = UIImage.init(named: "imageAdd")
        self.imgArr.append(addImage!)
        

        self.collectionView.isHidden = false
        // Do any additional setup after loading the view.
    }
    //MARK: - 编辑
    @objc func edit() {
    
    }
    /*添加collectionview*/
    lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 10;// 水平方向的间距
        flowLayout.minimumLineSpacing = 10; // 垂直方向的间距
        let collectionView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        //if (iOS_VERSION!>=10) {
        collectionView.prefetchDataSource = self
        //}
        //添加collectionview的headview
        collectionView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        let contentView = UITextView()
        contentView.delegate = self
        contentView.frame = CGRect(x: 0, y: -190, width: SCREEN_WIDTH-60, height: 170)
        contentView.text = self.followModel.activity_note
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: contentView.frame.size.height-0.3, width: SCREEN_WIDTH-60, height: 0.3)
        bottomLayer.backgroundColor = RGBA(R: 233, G: 233, B: 233, A: 1).cgColor
        contentView.layer.addSublayer(bottomLayer)
        collectionView.addSubview(contentView)
        /*注册cell和headview，用不同标识符否则滑动collectionview的时候由于复用会导致数据错乱*/
        collectionView.register(SLFUImageCell.self, forCellWithReuseIdentifier: "imgCell")
        collectionView.register(SLReuserFollowView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "foot")
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 30, SAFE_HEIGHT, 30))
        }
        return collectionView
    }()
    
    //MARK: - 代理函数
    /*返回secion个数*/
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
       
    }
    /*返回每个secion个数*/
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.imgArr.count
    }
    /*设置item大小*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (SCREEN_WIDTH-60-20)/3, height: (SCREEN_WIDTH-60-20)/3)
    }
    //MARK: - 图片显示
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! SLFUImageCell
        cell.backgroundColor = .yellow
        if indexPath.row == self.imgArr.count-1 {
           cell.addBtn.isHidden = false
            cell.addBtn.addTarget(self, action: #selector(addImages), for: UIControlEvents.touchUpInside)
        }else{
           cell.imageView.image = self.imgArr[indexPath.row]
           cell.delete.tag = indexPath.row
           cell.delete.addTarget(self, action: #selector(deleteImg), for: UIControlEvents.touchUpInside)
        }
        
        return cell
        
    }
    /*设置每个section的headview大小*/
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: 0)
    }
    /*设置每个section的footview大小*/
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 90)
    }
    /*创建每个section的headview*/
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headView = UICollectionReusableView.init()
            return headView
        }
        let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "foot", for: indexPath) as! SLReuserFollowView
        return footView
    }
    /**跳转到专项列表*/
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]){
        
    }
    //MARK: - 删除图片
    @objc func deleteImg(btn: UIButton) {
          self.imgArr.remove(at: btn.tag)
          self.collectionView.reloadData()
    }
    //MARK: - 添加图片
    @objc func addImages() {
        let imgPickerVC = QBImagePickerController()
        imgPickerVC.delegate = self
        imgPickerVC.allowsMultipleSelection = true
        imgPickerVC.showsNumberOfSelectedAssets = true
        imgPickerVC.numberOfColumnsInPortrait = 4
        imgPickerVC.numberOfColumnsInLandscape = 7
        imgPickerVC.maximumNumberOfSelection = 9
        self.present(imgPickerVC, animated: true, completion: nil)
         //imagePickerController.prompt = @"请选择图像!";//在界面上方显示文字“请选择图像!”
    }
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
          self.dismiss(animated: true, completion: nil)
    }
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didSelect asset: PHAsset!) {
        print("选中")
    }
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didDeselect asset: PHAsset!) {
         print("取消选中")
    }
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, shouldSelect asset: PHAsset!) -> Bool {
        return true
    }
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        let asetsArr = assets as! [PHAsset]
        for assets in asetsArr {
            let options = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            PHImageManager.default().requestImage(for: assets, targetSize: UIScreen.main.bounds.size, contentMode: PHImageContentMode.aspectFit, options: options) { (image, info) in
                self.imgArr.insert(image!, at: self.imgArr.count-1)
                self.collectionView.reloadData()
            }
           
        }
       
        self.dismiss(animated: true, completion: nil)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
