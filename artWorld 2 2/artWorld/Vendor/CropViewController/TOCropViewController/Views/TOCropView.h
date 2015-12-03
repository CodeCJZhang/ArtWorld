//
//  TOCropView.h
//
//  Copyright 2015 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@class TOCropView;

@protocol TOCropViewDelegate <NSObject>

- (void)cropViewDidBecomeResettable:(TOCropView *)cropView;
- (void)cropViewDidBecomeNonResettable:(TOCropView *)cropView;

@end

@interface TOCropView : UIView

/**
 The image that the crop view is displaying. This cannot be changed once the crop view is instantiated.
   作物视图显示的图像。这不能改变一旦作物视图实例化
 */
@property (nonatomic, strong, readonly) UIImage *image;

/**
 A delegate object that receives notifications from the crop view委托对象,从作物视图接收通知
 */
@property (nonatomic, weak) id<TOCropViewDelegate> delegate;

/**
 Whether the user has manipulated the crop view to the point where it can be reset
 */
@property (nonatomic, readonly) BOOL canReset;

/** 
 The frame of the cropping box on the crop view
 作物的种植箱的框架视图
 */
@property (nonatomic, readonly) CGRect cropBoxFrame;

/**
 The frame of the entire image in the backing scroll view
 整个图像的帧支持滚动视图
 */
@property (nonatomic, readonly) CGRect imageViewFrame;

/**
 Inset the workable region of the crop view in case in order to make space for accessory views
  插图的可行区域作物视图中为了使空间辅助视图
 */
@property (nonatomic, assign) UIEdgeInsets cropRegionInsets;

/**
 Disable the dynamic translucency in order to smoothly relayout the view禁用动态半透明为了顺利relayout视图
 */
@property (nonatomic, assign) BOOL simpleMode;

/**
 When the cropping box is locked to its current size
 当种植箱锁定其电流的大小
 */
@property (nonatomic, assign) BOOL aspectLockEnabled;

/**
 True when the height of the crop box is bigger than the width当作物盒子的高度大于宽度
 */
@property (nonatomic, readonly) BOOL cropBoxAspectRatioIsPortrait;

/**
 The rotation angle of the crop view (Will always be negative as it rotates in a counter-clockwise direction)作物的旋转角度视图(永远是负面的,因为它在一个逆时针方向旋转)
 */
@property (nonatomic, assign, readonly) NSInteger angle;

/**
 Hide all of the crop elements for transition animations 
 隐藏所有作物元素的过渡动画
 */
@property (nonatomic, assign) BOOL cropElementsHidden;

/**
 In relation to the coordinate space of the image, the frame that the crop view is focussing on相对于图像的坐标空间,作物的观点是关注的框架
 */
@property (nonatomic, readonly) CGRect croppedImageFrame;

/**
 Set the grid overlay graphic to be hidden设置网格叠加图形被隐藏
 */
@property (nonatomic, assign) BOOL gridOverlayHidden;

/**
 Create a new instance of the crop view with the supplied image创建一个新的实例的作物视图与提供的形象
 */
- (instancetype)initWithImage:(UIImage *)image;

/**
 When performing large size transitions (eg, orientation rotation),
 set simple mode to YES to temporarily graphically heavy effects like translucency.　　当执行大尺寸转换(如旋转方向),
 　　设置简单模式暂时对图形重像半透明效果。
 @param simpleMode Whether simple mode is enabled or not
 参数简单模式是否启用了简单模式
 */
- (void)setSimpleMode:(BOOL)simpleMode animated:(BOOL)animated;

/**
 When performing a screen rotation that will change the size of the scroll view, this takes 
 a snapshot of all of the scroll view data before it gets manipulated by iOS.
 Please call this in your view controller, before the rotation animation block is committed.
 当执行一个屏幕旋转,改变滚动视图的大小,这需要
 　　之前所有的滚动视图数据的快照被iOS。
 　　请打电话给这个在你的视图控制器,在旋转动画块承诺。
 */
- (void)prepareforRotation;

/**
 Performs the realignment of the crop view while the screen is rotating.
 Please call this inside your view controller's screen rotation animation block.
 　　执行的调整作物视图在屏幕旋转。
 　　请打电话给这个在你的视图控制器的屏幕旋转动画块。
 */
- (void)performRelayoutForRotation;

/**
 Reset the crop box and zoom scale back to the initial layout
 
 @param animated The reset is animated
 　重置作物盒和缩放尺度回到最初的布局
 　　
 　　@param动画动画重置
 */
- (void)resetLayoutToDefaultAnimated:(BOOL)animated;

/**
 Enables an aspect ratio lock where the crop box will always scale at a specific ratio.
 
 @param aspectRatio The aspect ratio (For example 16:9 is 16.0f/9.0f). Specify 0.0f to lock to the image's original aspect ratio
 @param animated Whether the locking effect is animated
 　　使一个长宽比锁在作物箱总规模在一个特定的比率。
 　　
 　　@param aspectRatio纵横比(例如16:9的16.0 f / 9.0华氏度)。指定0.0 f锁原始图像的纵横比
 　　@param动画是否锁定效果动画
 */
- (void)setAspectLockEnabledWithAspectRatio:(CGSize)aspectRatio animated:(BOOL)animated;

/**
 Rotates the entire canvas to a 90-degree angle
 
 @param angle The angle in which to rotate (May be 0, 90, 180, 270)
 @param animated Whether the transition is animated
 　整个画布旋转90度角
 　　
 　　@param角旋转的角(可能是0,90,180,270)
 　　@param动画是否动画过渡
 */
- (void)rotateImageNinetyDegreesAnimated:(BOOL)animated;

/**
 Animate the grid overlay graphic to be visible
 动画网格叠加图形可见
 */
- (void)setGridOverlayHidden:(BOOL)gridOverlayHidden animated:(BOOL)animated;

@end
