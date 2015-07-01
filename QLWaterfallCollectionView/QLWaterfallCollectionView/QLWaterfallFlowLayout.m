//
//  QLWaterfallFlowLayout.m
//  QLWaterfallCollectionView
//
//  Created by xuqianlong on 15/7/1.
//  Copyright (c) 2015年 xuqianlong. All rights reserved.
//

#import "QLWaterfallFlowLayout.h"

@interface QLWaterfallFlowLayout ()
{
    NSUInteger Colums;
    CGFloat ItemWidth;
}

@property (nonatomic, strong) NSMutableArray *layoutInfo;
@property (nonatomic, strong) NSMutableDictionary *lastYValueInfo;

@end

@implementation QLWaterfallFlowLayout

- (NSMutableArray *)layoutInfo
{
    if (!_layoutInfo) {
        _layoutInfo = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return _layoutInfo;
}

- (NSMutableDictionary *)lastYValueInfo
{
    if (!_lastYValueInfo) {
        _lastYValueInfo = [[NSMutableDictionary alloc]initWithCapacity:5];
    }
    return _lastYValueInfo;
}

- (void)prepareLayout
{
    NSParameterAssert(self.delegate);
    
    [self.layoutInfo removeAllObjects];
    [self.lastYValueInfo removeAllObjects];
    
    CGFloat Width = self.collectionView.frame.size.width;
    Colums = [self.delegate numberOfColumnsForLayout:self];
    for (int i = 0 ; i < Colums; i ++)
    {
        self.lastYValueInfo[@(i)] = @(self.sectionInset.top);
    }
    
    CGFloat itemSpace = [self.delegate interItemSpaceForLayout:self];
    
    CGFloat availableSpaceExcludingPadding = Width - itemSpace * (Colums + 1) - self.sectionInset.left - self.sectionInset.right;
    
    ItemWidth = availableSpaceExcludingPadding / Colums;
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < cellCount; i++) {
        [self prepareLayoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
}

- (NSUInteger)computeMinHeight
{
    NSUInteger cur = 0;
    
    for (int i = 0; i < Colums; i ++) {
        if ([self.lastYValueInfo[@(i)] floatValue] < [self.lastYValueInfo[@(cur)] floatValue]) {
            cur = i;
        }
    }
    return cur;
}

- (NSUInteger)computeMaxHeight
{
    NSUInteger cur = 0;
    
    for (int i = 0; i < Colums; i ++) {
        if ([self.lastYValueInfo[@(i)] floatValue] > [self.lastYValueInfo[@(cur)] floatValue]) {
            cur = i;
        }
    }
    return cur;
}

- (UICollectionViewLayoutAttributes *)prepareLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemSpace = [self.delegate interItemSpaceForLayout:self];
    NSUInteger currentColumn = [self computeMinHeight];
    
    CGFloat x = itemSpace + (itemSpace + ItemWidth) * currentColumn + self.sectionInset.left;
    CGFloat y = [self.lastYValueInfo[@(currentColumn)]floatValue];
    CGFloat height = [self.delegate layout:self heightForItemAtIndexPath:indexPath];
    
    attributes.frame = CGRectMake(x, y, ItemWidth, height);
    y += height;
    y += itemSpace;
    self.lastYValueInfo[@(currentColumn)] = @(y);
    [self.layoutInfo addObject:attributes];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = CGRectMake(0, 0, 300, 50);
    
    return attributes;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:5];
    [self.layoutInfo enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;
}

- (CGSize)collectionViewContentSize
{
    NSUInteger currentColumn = [self computeMaxHeight];
    
    CGFloat height = [self.lastYValueInfo[@(currentColumn)]floatValue] + self.sectionInset.bottom;
    
    return CGSizeMake(self.collectionView.frame.size.width, height);
}

@end
