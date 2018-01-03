//
//  CycleRollView.h
//  KTCycleRollView
//
//  Created by Ketao Deng on 2018/1/3.
//  Copyright © 2018年 Ketao Deng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleRollCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

@class CycleRollView;

@protocol CycleRollViewDelegate <NSObject>

@optional

- (void)cycleRollView:(CycleRollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

typedef void(^CycleRollViewClickItemBlock)(NSInteger currentIndex);

typedef NS_ENUM(NSInteger, CycleRollPageControlAlignType) {
    CycleRollPageControlAlignTypeCenter = 0, //居中对齐
    CycleRollPageControlAlignTypeLeft = 1, //居左对齐
    CycleRollPageControlAlignTypeRight = 2 //居右对齐
};

@interface CycleRollView : UIView

+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type delegate:(id<CycleRollViewDelegate>)delegate placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer;
+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer;
+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type placeholder:(UIImage *)image;
+ (instancetype)cycleRollWithFrame:(CGRect)frame placeholder:(UIImage *)image;
- (void)updataUI;

@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, copy) NSArray <NSString *> *imageURLs;//网络图片数组
@property (nonatomic, copy) NSArray <UIImage *> *imageNames;//本地图片数组
@property (nonatomic, assign) NSTimeInterval timeInterval;//自动滚动时间间隔
@property (nonatomic, weak) id<CycleRollViewDelegate>delegate;//点击可实现的代理
@property (nonatomic, copy) CycleRollViewClickItemBlock cycleRollViewClickItemBlock;//点击回调block
@property (nonatomic, assign) CycleRollPageControlAlignType cycleRollPageControlAlign;//圆点默认居中对齐

@end
