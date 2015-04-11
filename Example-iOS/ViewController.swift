//
//  ViewController.swift
//  Example-iOS
//
//  Created by Indragie on 1/15/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit
import CocoaMarkdown

class ViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    var pendingImages : [NSURL] = []
    var contentOffset : CGPoint = CGPointZero

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDidLoad:", name: "CMImageCacheImageDidLoadNotification", object: nil);

        reloadData()

    }

    func reloadData() {
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "md")!
        let document = CMDocument(contentsOfFile: path)
        let renderer = CMAttributedStringRenderer(document: document, attributes: CMTextAttributes())
        renderer.registerHTMLElementTransformer(CMHTMLStrikethroughTransformer())
        renderer.registerHTMLElementTransformer(CMHTMLSuperscriptTransformer())
        renderer.registerHTMLElementTransformer(CMHTMLUnderlineTransformer())
        renderer.imageWillLoadHandler = { url in
            self.pendingImages += [url]
        }
        textView.attributedText = renderer.render()
    }

    func imageDidLoad(notification: NSNotification) {

        if let url = notification.userInfo?["url"] as? NSURL where find(pendingImages, url) != nil {
            println("found that we are intereseted in this url \(url)")
            contentOffset = self.textView.contentOffset
            println("currentOffset \(contentOffset)")

            self.reloadData()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.textView.contentOffset = self.contentOffset
                println("restoreOffset")
            })
        }

    }

}

