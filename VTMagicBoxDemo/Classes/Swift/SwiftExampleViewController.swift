//
//  SwiftExampleViewController.swift
//  VTMagicBoxDemo
//
//  Created by Suzhibin on 2023/6/1.
//

import UIKit

@objcMembers class SwiftExampleViewController: UIViewController {
    let magicVC = VTMagicController()
    var menuList = [MenuInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        edgesForExtendedLayout = UIRectEdge.bottom
        
        createMagic()
        let numbers=[Int](0...20)
        for (index,_) in numbers.enumerated(){
            let title = String(format: "省份%d", index)
            let menu = MenuInfo()
            menu.title=title
            menuList.append(menu)
        }
        magicVC.magicView .reloadData()

    }
    func createMagic() {
        magicVC.magicView.delegate=self
        magicVC.magicView.dataSource=self
        magicVC.magicView.navigationHeight=50
        magicVC.magicView.displayCentered=true
        magicVC.magicView.layoutStyle = .default
        magicVC.magicView.sliderWidth = 20
        magicVC.magicView.sliderOffset = -4
        magicVC.magicView.itemScale=1.2
        addChild(magicVC)
        view.addSubview(magicVC.view)
    }
}
extension SwiftExampleViewController:VTMagicViewDataSource, VTMagicViewDelegate{
    func menuTitles(for magicView: VTMagicView) -> [String] {
        var titls = [String]()
        for menu in menuList {
            titls.append(menu.title)
        }
        return titls
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
         let itemIdentifier : String = "itemIdentifier"
       
        var menuItem: UIButton! = magicView.dequeueReusableItem(withIdentifier: itemIdentifier)
        if menuItem==nil {
            menuItem = UIButton(type:.custom)
            menuItem?.setTitleColor(UIColor.gray, for: .normal)
            menuItem?.setTitleColor(UIColor.black, for: .selected)
            menuItem?.titleLabel?.font=UIFont.systemFont(ofSize: 14)
        }
        return menuItem
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let gridId = "grid.identifier";
        var gridViewController:VTGridViewController! = [magicView .dequeueReusablePage(withIdentifier: gridId)] as? VTGridViewController
        if gridViewController == nil {
            gridViewController = VTGridViewController();
        }
        let Index = Int(pageIndex)
        let menuInfo =  menuList [Index]
        gridViewController.menuInfo=menuInfo
        return gridViewController;
    }
    //VTMagicViewDelegate
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt) {
      //  print("index:\(pageIndex) viewDidAppearer:\(viewController.view)")
    }
    
    func magicView(_ magicView: VTMagicView, viewDidDisappear viewController: UIViewController, atPage pageIndex: UInt) {
       // print("index:\(pageIndex) viewDidDisappear:\(viewController.view)")
    }

    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt) {
       //  print("didSelectItemAtIndex:\(itemIndex)")
    }
}


