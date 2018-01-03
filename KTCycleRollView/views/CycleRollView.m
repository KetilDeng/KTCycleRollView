//
//  CycleRollView.m
//  KTCycleRollView
//
//  Created by Ketao Deng on 2018/1/3.
//  Copyright © 2018年 Ketao Deng. All rights reserved.
//

#import "CycleRollView.h"
#import "YYWebImage.h"
#import "Masonry.h"

const CGFloat kDotW = 5.0f;//圆点宽度
const CGFloat kDotSelectedW = 13.0f;//当前选中圆点宽度
const CGFloat kDotH = 5.0f;//圆点高度
const CGFloat kDotSpace = 4.0f;//圆点间间隔
const CGFloat kSelectedAlpha = 1.0f;//当前选中透明度
const CGFloat kNormalAlpha = 0.5f;//未选中透明度
const CGFloat kMargin = 10.0f;//圆点距 左/右 距离(CycleRollPageControlAlignTypeLeft、CycleRollPageControlAlignTypeRight)
const CGFloat kMarginBottom = 5.0f;//圆点距底部

@interface CycleRollPageControl : UIPageControl

@property (nonatomic, assign) CycleRollPageControlAlignType pageControlAlign;

@end

@implementation CycleRollPageControl

- (void)setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++)
    {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        if (subviewIndex == page)
        {
            subview.alpha = kSelectedAlpha;
        }
        else
        {
            subview.alpha = kNormalAlpha;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count-1) * (kDotSpace + kDotW) +  kDotSelectedW;
    //设置pageControll.frame
    UIView *superView = self.superview;
    CGFloat y = CGRectGetHeight(superView.frame) - kDotH - kMarginBottom;
    CGFloat x = 0.0f;
    switch (self.pageControlAlign)
    {
        case CycleRollPageControlAlignTypeCenter:
            x = CGRectGetWidth(superView.frame)/2.0 - newW/2.0;
            break;
            
        case CycleRollPageControlAlignTypeLeft:
            x = kMargin;
            break;
            
        case CycleRollPageControlAlignTypeRight:
            x = CGRectGetWidth(superView.frame) - newW - kMargin;
            break;
            
        default:
            x = CGRectGetWidth(superView.frame)/2.0 - newW/2.0;
            break;
    }
    self.frame = CGRectMake(x, y, newW, kDotH);
    
    //设置圆点frame
    for (int i=0; i<[self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
        {
            [dot setFrame:CGRectMake(i * (kDotW + kDotSpace), dot.frame.origin.y, kDotSelectedW, kDotH)];
            dot.alpha = kSelectedAlpha;
        }
        else if(i >self.currentPage)
        {
            [dot setFrame:CGRectMake(((i-1) * (kDotW + kDotSpace) +(kDotSelectedW + kDotSpace)), dot.frame.origin.y, kDotW, kDotW)];
            dot.alpha = kNormalAlpha;
        }
        else
        {
            [dot setFrame:CGRectMake(i * (kDotW + kDotSpace), dot.frame.origin.y, kDotW, kDotW)];
            dot.alpha = kNormalAlpha;
        }
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = kDotH/2.0;
    }
}

@end

@interface CycleRollView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) CycleRollPageControl *pageControl;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL disableTimer;

@end

@implementation CycleRollView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _cycleRollPageControlAlign = type;
        [self initialization];
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)initialization
{
    _datas = [[NSMutableArray alloc] init];
    _timeInterval = 3;
}

- (void)createUI
{
    [self addSubview:self.mainView];
    [self addSubview:self.pageControl];
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.leading.and.trailing.equalTo(@0);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

+ (instancetype)cycleRollWithFrame:(CGRect)frame placeholder:(UIImage *)image
{
    return [self cycleRollWithFrame:frame alignType:CycleRollPageControlAlignTypeCenter placeholder:image];
}

+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type placeholder:(UIImage *)image
{
    return [self cycleRollWithFrame:frame alignType:type delegate:nil placeholder:image disableTimer:NO];
}

+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer
{
    return [self cycleRollWithFrame:frame alignType:type delegate:nil placeholder:image disableTimer:disableTimer];
}

+ (instancetype)cycleRollWithFrame:(CGRect)frame alignType:(CycleRollPageControlAlignType)type delegate:(id<CycleRollViewDelegate>)delegate placeholder:(UIImage *)image disableTimer:(BOOL)disableTimer
{
    CycleRollView *cycleRollView = [[CycleRollView alloc] initWithFrame:frame alignType:type];
    cycleRollView.disableTimer = disableTimer;
    cycleRollView.placeholderImage = image;
    cycleRollView.delegate = delegate;
    return cycleRollView;
}

#pragma mark - event

- (void)reloadDatas
{
    [self.mainView reloadData];
    if (self.datas.count > 2)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.mainView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        if (!self.disableTimer)
        {
            [self setupTimer];
        }
    }
}

- (void)setupTimer
{
    [self invalidateTimer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)automaticScroll
{
    if (0 == self.datas.count) return;
    
    int currentIndex = self.mainView.contentOffset.x/CGRectGetWidth(self.mainView.bounds);
    int targetIndex = currentIndex + 1;
    
    if (targetIndex > self.datas.count-1) return;
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:targetIndex inSection:0];
    [_mainView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)updataUI
{
    [self.mainView.collectionViewLayout invalidateLayout];
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    [self.mainView reloadData];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleRollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CycleRollCell" forIndexPath:indexPath];
    id imageObject = self.datas[indexPath.row];
    if ([imageObject isKindOfClass:[NSString class]])
    {
        NSString *imageUrl = (NSString *)imageObject;
        [cell.imageView yy_setImageWithURL:[NSURL URLWithString:imageUrl]
                     placeholder:self.placeholderImage
                         options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation
                      completion:nil];
    }
    else
    {
        UIImage *image = (UIImage *)imageObject;
        cell.imageView.image = image;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleRollView:didSelectItemAtIndex:)])
    {
        [self.delegate cycleRollView:self didSelectItemAtIndex:indexPath.row-1];
    }
    
    if (self.cycleRollViewClickItemBlock)
    {
        if (1 == self.datas.count)
        {
            self.cycleRollViewClickItemBlock(0);
        }
        else
        {
            self.cycleRollViewClickItemBlock(indexPath.row - 1);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentIndex = self.mainView.contentOffset.x/CGRectGetWidth(self.mainView.bounds);
    int delivery = (int)self.mainView.contentOffset.x % (int)CGRectGetWidth(self.mainView.bounds);
    
    if (delivery>(int)(CGRectGetWidth(self.mainView.bounds)/2))
    {
        if (currentIndex == self.datas.count-2)
        {
            self.pageControl.currentPage = 0;
        }
        else if (currentIndex == 0)
        {
            self.pageControl.currentPage = 0;
        }
        else
        {
            self.pageControl.currentPage = currentIndex;
        }
    }
    else
    {
        if (currentIndex == 0)
        {
            self.pageControl.currentPage = self.datas.count - 3;
        }
        else
        {
            self.pageControl.currentPage = currentIndex - 1;
        }
    }
    
    if (0 == delivery)
    {
        if (self.datas.count > 1)
        {
            if (currentIndex == self.datas.count-1)
            {
                NSIndexPath *path = [NSIndexPath indexPathForItem:1 inSection:0];
                [_mainView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
            else if (currentIndex == 0)
            {
                NSIndexPath *path = [NSIndexPath indexPathForItem:self.datas.count-2 inSection:0];
                [_mainView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.disableTimer)
    {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.disableTimer)
    {
        [self setupTimer];
    }
}

#pragma mark - setter

- (void)setImageURLs:(NSArray *)imageURLs
{
    _imageURLs = imageURLs;
    if (_imageURLs.count)
    {
        [self.datas removeAllObjects];
        self.pageControl.numberOfPages = _imageURLs.count;
        self.pageControl.currentPage = 0;
        if (_imageURLs.count >= 2)
        {
            [self.datas addObject:_imageURLs.lastObject];
        }
        [self.datas addObjectsFromArray:_imageURLs];
        if (_imageURLs.count >= 2)
        {
            [self.datas addObject:_imageURLs.firstObject];
        }
        [self reloadDatas];
    }
}

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *name in _imageNames)
    {
        UIImage *image = [UIImage imageNamed:name];
        [images addObject:image];
    }
    
    if (images.count)
    {
        [self.datas removeAllObjects];
        self.pageControl.numberOfPages = images.count;
        self.pageControl.currentPage = 0;
        if (images.count >= 2)
        {
            [self.datas addObject:_imageNames.lastObject];
        }
        [self.datas addObjectsFromArray:images];
        if (images.count >= 2)
        {
            [self.datas addObject:images.firstObject];
        }
        [self reloadDatas];
    }
}

#pragma mark - getter

- (UICollectionView *)mainView
{
    if (!_mainView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = flowLayout;
        
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = YES;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        [mainView registerClass:[CycleRollCell class] forCellWithReuseIdentifier:@"CycleRollCell"];
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _mainView = mainView;
    }
    return _mainView;
}

- (CycleRollPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[CycleRollPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageControlAlign = self.cycleRollPageControlAlign;
    }
    return _pageControl;
}

@end

#pragma mark - CycleRollCell

@implementation CycleRollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.bottom.and.trailing.equalTo(@0);
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor grayColor];
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
