//
//  SegueRight.swift
//  ABCD
//
//  Created by savtozb on 7/11/18.
//  Copyright © 2018 Sarar Raad. All rights reserved.
//

import Foundation
import UIKit
class SegueFromRight: UIStoryboardSegue {
    //this is just to handle right swiping
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}
