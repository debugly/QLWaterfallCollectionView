//
//  ViewController.m
//  QLWaterfallCollectionView
//
//  Created by xuqianlong on 15/7/1.
//  Copyright (c) 2015年 xuqianlong. All rights reserved.
//

#import "ViewController.h"
#import "QLWaterfallFlowLayout.h"
#import "WaterCollectionViewCell.h"

NSString *const QLWaterfallFlowLayoutIdentifier = @"QLWaterfallFlowLayoutIdentifier";

@interface ViewController ()<QLWaterfallFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    http://www.pocketdigi.com/20141221/1406.html
    //    [self.collectionView registerClass:[SEFirstTabbarViewCell class] forCellWithReuseIdentifier:SEFirstTabbarViewControllerIdentifier];
    
    for (int i = 0; i < 12; i ++) {
        CGFloat randomHeight = 100 + arc4random() % 60;
        [self.dataSource addObject:@(randomHeight)];
    }
    
    QLWaterfallFlowLayout *layout = (QLWaterfallFlowLayout *)self.collectionView.collectionViewLayout;
    layout.delegate = self;
    layout.headerReferenceSize = CGSizeMake(300, 50);
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGestureAction:)];
    [self.collectionView addGestureRecognizer:tap];
    
}

- (void)handleTapGestureAction:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [sender locationInView:self.collectionView];
        NSIndexPath *idx = [self.collectionView indexPathForItemAtPoint:tapPoint];
        if (idx) {
            [self.dataSource removeObjectAtIndex:idx.item];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:@[idx]];
            } completion:^(BOOL finished) {
                [self.collectionView reloadData];
            }];
        }else{
            CGFloat randomHeight = 100 + arc4random() % 140;
            [self.dataSource addObject:@(randomHeight)];
            NSUInteger count = self.dataSource.count - 1;
            [self.collectionView performBatchUpdates:^{
                NSIndexPath *newIdx = [NSIndexPath indexPathForItem:count inSection:0];
                [self.collectionView insertItemsAtIndexPaths:@[newIdx]];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (NSUInteger)numberOfColumnsForLayout:(QLWaterfallFlowLayout *)layout
{
    return 3;
}

- (CGFloat)layout:(QLWaterfallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)idx
{
    NSNumber *randomHeight = self.dataSource[idx.item];
    return [randomHeight floatValue];
}

- (CGFloat)interItemSpaceForLayout:(QLWaterfallFlowLayout *)layout
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [UICollectionReusableView new];
    view.backgroundColor = [UIColor blueColor];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QLWaterfallFlowLayoutIdentifier forIndexPath:indexPath];
    
    cell.titleLb.text = [NSString stringWithFormat:@"%zi",indexPath.item];
    
    return cell;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation) != UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        [self.collectionView reloadData];
    }
}


@end
