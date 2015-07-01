//
//  QLWaterfallFlowLayout.h
//  QLWaterfallCollectionView
//
//  Created by xuqianlong on 15/7/1.
//  Copyright (c) 2015年 xuqianlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QLWaterfallFlowLayout;
@protocol QLWaterfallFlowLayoutDelegate <NSObject>

- (CGFloat)layout:(QLWaterfallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)idx;

- (NSUInteger)numberOfColumnsForLayout:(QLWaterfallFlowLayout *)layout;

- (CGFloat)interItemSpaceForLayout:(QLWaterfallFlowLayout *)layout;

@end


@interface QLWaterfallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<QLWaterfallFlowLayoutDelegate>delegate;

@end
