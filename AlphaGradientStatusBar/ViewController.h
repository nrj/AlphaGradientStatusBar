//
//  ViewController.h
//  AlphaGradientStatusBar
//
//  Created by Nick Jensen on 12/6/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, readonly) UIImageView *statusBarBackgroundView;
@property (nonatomic, readonly) UICollectionView *collectionView;

@end
