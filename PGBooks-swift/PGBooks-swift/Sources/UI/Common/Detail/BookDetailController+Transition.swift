//
//  BookDetailController+Transition.swift
//  PGBooks-swift
//
//  Created by ipagong on 18/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

import UIKit
import PGTransitionKit

extension BookDetailController : AnimatorDestinationable {
    func appearWhenPresent(status: Status, animator: Animator, context: Context) {
        switch status {
        case .prepare:
            guard let fromSnap = context.opposite.view.snapshotView(afterScreenUpdates: true) else { return }
            
            context.container.addSubview(fromSnap)
            
            guard let cell = self.originalCell(self.book.isbn13, context: context) else { return }
            
            self.coverView.alpha = 0.0
            
            if let container = self.view.snapshotView(afterScreenUpdates: true) {
                container.frame = cell.convert(cell.bounds, to: context.container)
                container.tag   = Constant.Tag.container.rawValue
                container.alpha = 0.0
                context.container.addSubview(container)
            }
            
            if let cover = cell.coverView.snapshotView(afterScreenUpdates: true) {
                cover.frame = cell.coverView.convert(cell.coverView.bounds, to: context.container)
                cover.tag   = Constant.Tag.cover.rawValue
                context.container.addSubview(cover)
            }
            
        case .doing:
            let container = context.container.viewWithTag(Constant.Tag.container.rawValue)
            container?.frame = context.target.view.frame
            container?.alpha = 1.0
            
            let cover = context.container.viewWithTag(Constant.Tag.cover.rawValue)
            cover?.frame = self.coverView.convert(self.coverView.bounds, to: context.container)
            
        case .done, .cancel:
            context.container.addSubview(context.target.view)
            self.coverView.alpha = 1.0
            context.container.viewWithTag(Constant.Tag.container.rawValue)?.removeFromSuperview()
            context.container.viewWithTag(Constant.Tag.cover.rawValue)?.removeFromSuperview()
        }
    }
    
    func disppearWhenDismiss(status: Status, animator: Animator, context: Context) {
        switch status {
        case .prepare:
            context.container.addSubview(context.opposite.view)
            
            let cell = self.originalCell(self.book.isbn13, context: context)
            
            if let _ = cell { self.coverView.alpha = 0.0 }
            
            let bg = UIView()
            bg.frame = context.container.frame
            bg.backgroundColor = UIColor.white
            bg.tag = Constant.Tag.bg.rawValue
            context.container.addSubview(bg)
            
            if let container = self.view.snapshotView(afterScreenUpdates: true) {
                container.frame = context.container.frame
                container.tag = Constant.Tag.container.rawValue
                context.container.addSubview(container)
            }
            
            cell?.coverView.alpha = 0.0
            if let sCell = cell?.snapshotView(afterScreenUpdates: true) {
                sCell.frame = cell?.convert(cell?.bounds ?? .zero, to: context.container) ?? .zero
                sCell.alpha = 0.0
                sCell.tag = Constant.Tag.cell.rawValue
                context.container.addSubview(sCell)
            }
            
            cell?.coverView.alpha = 1.0
            if let cover = cell?.coverView.snapshotView(afterScreenUpdates: true) {
                cover.frame = self.coverView.convert(self.coverView.bounds, to: context.container)
                cover.tag = Constant.Tag.cover.rawValue
                context.container.addSubview(cover)
            }
            
        case .doing:
            let cell = self.originalCell(self.book.isbn13, context: context)
            
            let bg        = context.container.viewWithTag(Constant.Tag.bg.rawValue )
            let container = context.container.viewWithTag(Constant.Tag.container.rawValue )
            let sCell     = context.container.viewWithTag(Constant.Tag.cell.rawValue )
            let cover     = context.container.viewWithTag(Constant.Tag.cover.rawValue )
            
            if let cell = cell {
                bg?.frame        = cell.convert(cell.bounds, to: context.container)
                container?.frame = cell.convert(cell.bounds, to: context.container)
                sCell?.frame     = cell.convert(cell.bounds, to: context.container)
                cover?.frame     = cell.coverView.convert(cell.coverView.bounds, to: context.container)
            } else {
                let rect = CGRect.init(x: 0,
                                       y: context.container.frame.height,
                                       width: context.container.frame.width,
                                       height: context.container.frame.height/2)
                
                bg?.frame        = rect
                container?.frame = rect
                sCell?.frame     = rect
                cover?.frame     = rect
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 1.0) { bg?.alpha = 0.0 }
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) { container?.alpha = 0.0 }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1.0) { sCell?.alpha = 1.0 }
            
        case .done, .cancel:
            self.stackContainer.subviews.forEach { $0.alpha = 1.0 }
            self.coverView.alpha = 1.0
            context.container.viewWithTag(Constant.Tag.bg.rawValue)?.removeFromSuperview()
            context.container.viewWithTag(Constant.Tag.container.rawValue)?.removeFromSuperview()
            context.container.viewWithTag(Constant.Tag.cell.rawValue)?.removeFromSuperview()
            context.container.viewWithTag(Constant.Tag.cover.rawValue)?.removeFromSuperview()
            
        }
    }
    
    fileprivate func originalCell(_ key:String, context:Context) -> BookSimpleCell? {
        guard let vc = context.opposite.lastChildren as? BookDetailTransitionable else { return nil }
        return vc.tableview.visibleCells.compactMap{ $0 as? BookSimpleCell }.filter{ $0.data?.isbn13 == key }.first
    }
    
    struct Constant {
        enum Tag : Int {
            case container = 1000
            case cover     = 1001
            case bg        = 1002
            case cell      = 1003
        }
    }
    
}
