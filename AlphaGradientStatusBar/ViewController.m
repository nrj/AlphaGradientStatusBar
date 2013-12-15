//
//  ViewController.m
//  AlphaGradientStatusBar
//
//  Created by Nick Jensen on 12/6/13.
//  Copyright (c) 2013 Nick Jensen. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize collectionView, statusBarBackgroundView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout;
    layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(290.0f, 2000.0f)];
    [layout setSectionInset:UIEdgeInsetsMake(30.0f, 15.0f, 15.0f, 15.0f)];
    
    collectionView = [[UICollectionView alloc] initWithFrame:[[self view] bounds] collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setAlwaysBounceVertical:YES];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [[self view] addSubview:collectionView];
    [collectionView release];
    [layout release];
    
    UIImage *background = [UIImage imageNamed:@"space"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:background];
    [collectionView setBackgroundView:backgroundView];
    [backgroundView release];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!statusBarBackgroundView) {
        
        CGRect barRect = CGRectMake(0.0f, 0.0f, 320.0f, 28.0f);
        
        statusBarBackgroundView = [[collectionView backgroundView] resizableSnapshotViewFromRect:barRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                           (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                           nil];
        [gradientLayer setColors:colors];
        [gradientLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
        [gradientLayer setEndPoint:CGPointMake(0.0f, 0.6f)];
        [gradientLayer setFrame:[statusBarBackgroundView bounds]];
        
        [[statusBarBackgroundView layer] setMask:gradientLayer];
        [[self view] addSubview:statusBarBackgroundView];
        [statusBarBackgroundView release];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self scroll];
}

- (void)scroll {
    
    const float speed = 0.1;
    const float increment = 5;
    const float bottomY = [collectionView contentSize].height - CGRectGetHeight([collectionView bounds]);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(speed * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if ([collectionView contentOffset].y < bottomY && ![collectionView isDragging]) {
            [collectionView scrollRectToVisible:CGRectMake(0, CGRectGetMaxY([collectionView bounds]) + increment, 1, 1) animated:YES];
            [self scroll];
        }
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (id)[UIFont fontWithName:@"HelveticaNeue-Light" size:30.0f], NSFontAttributeName,
                                (id)[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    NSAttributedString *attrText;
    attrText = [[NSAttributedString alloc] initWithString:@"It is a dark time for the Rebellion. Although the Death Star has been destroyed, Imperial troops have driven the Rebel forces from their hidden base and pursued them across the galaxy.\nEvading the dreaded Imperial Starfleet, a group of freedom fighters led by Luke Skywalker has established a new secret base on the remote ice world of Hoth.\nThe evil lord Darth Vader, obsessed with finding young Skywalker, has dispatched thousands of remote probes into the far reaches of space..."
                                               attributes:attributes];
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [label setAttributedText:attrText];
    [cell addSubview:label];
    
    CGRect textRect = CGRectZero;
    textRect.size = [label sizeThatFits:[cell bounds].size];
    [label setFrame:textRect];
    
    [attrText release];
    [label release];
    
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
