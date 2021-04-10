//
//  File.swift
//  
//
//  Created by Brice Rosenzweig on 07/04/2021.
//

import Foundation
import UIKit

class SnapshotView : UIImageView {
    
}

class DarkView : UIView {
    
}

extension UIView {
    var snapshot : UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image {
            ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        }
        return image
    }
    
    func fadeIn( completion : (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) {
            _ in
            completion?()
        }
    }
    
    func fadeOut(completion : (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) {
            _ in
            self.isHidden = true
            completion?()
        }
    }
    
    func highlight(view : UIView, within : UIView){
        var iterview = view
        var globalPoint = iterview.frame.origin
        repeat {
            globalPoint = iterview.convert(globalPoint, to: iterview.superview)
            if let checkview = iterview.superview {
                iterview = checkview
            }
        } while iterview != within && iterview.superview != nil

        let mask = UIView(frame: within.frame)
        mask.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        
        let revealRect = CGRect(origin: globalPoint, size: view.frame.size)
        let revealView = UIView(frame: revealRect)
        revealView.backgroundColor = UIColor.white
        
        mask.addSubview(revealView)
        within.mask = mask
    }
    
    func addSnapshot(of view : UIView, within : UIView){
        guard let snapshot = view.snapshot else { return }
        
        let imageView = SnapshotView(image: snapshot)
        var iterview = view
        var globalPoint = iterview.frame.origin
        repeat {
            globalPoint = iterview.convert(globalPoint, to: iterview.superview)
            if let checkview = iterview.superview {
                iterview = checkview
            }
        } while iterview != within && iterview.superview != nil
        
        imageView.frame = CGRect(origin: globalPoint, size: view.frame.size)
        within.addSubview(imageView)
        imageView.fadeIn() {
            let when = DispatchTime.now() + .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: when) {
                within.removeDarkView()
                within.removeSnapshots()
            }
        }
    }
    
    func removeSnapshots() {
        self.subviews.filter( { $0 is SnapshotView } ).forEach {
            view in
            view.fadeOut {
                view.removeFromSuperview()
                
            }
        }
    }
    
    func addDarkView(completion : (() -> Void)? = nil){
        removeDarkView()
        
        let darkView = DarkView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(darkView)
        
        NSLayoutConstraint.activate([
            darkView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            darkView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            darkView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            darkView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
        darkView.fadeIn{
            completion?()
        }
    }
    
    func removeDarkView() {
        subviews.filter( { $0 is DarkView }).forEach {
            view in
            view.fadeOut {
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func addTooltip(to view : UIView){
        
    }
}

extension UITableView {
    @objc public func addTooltip2(at indexPath: IndexPath, within : UIView){
        let rectOfCell = self.rectForRow(at: indexPath)
        print( "\(rectOfCell )")
        if let cell = self.cellForRow(at: indexPath) {
            within.addDarkView()
            within.addSnapshot(of: cell.contentView, within: within)
        }
    }
    @objc public func addTooltip(at indexPath: IndexPath, within : UIView){
        let rectOfCell = self.rectForRow(at: indexPath)
        print( "\(rectOfCell )")
        if let cell = self.cellForRow(at: indexPath) {
            within.highlight(view: cell, within: within)
            //within.addSnapshot(of: cell.contentView, within: within)
        }
    }
}
