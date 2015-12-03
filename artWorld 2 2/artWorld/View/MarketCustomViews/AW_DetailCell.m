//
//  AW_DetailCell.m
//  artWorld
//
//  Created by 曹学亮 on 15/10/23.
//  Copyright © 2015年 张晓旭. All rights reserved.
//

#import "AW_DetailCell.h"
#import "AW_Constants.h"

@interface AW_DetailCell()<UIWebViewDelegate>
/**
 *  @author cao, 15-12-03 16:12:56
 *
 *  底部分割线
 */
@property(nonatomic,strong)CAShapeLayer * bottomLayer;

@end

@implementation AW_DetailCell

#pragma mark - BottomLayer Menthod
-(void)addBottomLayerWithHeight:(float)height{
        self.bottomLayer = [[CAShapeLayer alloc]init];
        self.bottomLayer = [[CAShapeLayer alloc]init];
        CGFloat lineHeifht = 1.0f/([UIScreen mainScreen].scale);
        self.bottomLayer.frame = Rect(0, height, kSCREEN_WIDTH, lineHeifht);
        self.bottomLayer.backgroundColor = HexRGB(0xe6e6e6).CGColor;
    [self.layer addSublayer:self.bottomLayer];
}

#pragma mark - LifeCycle Menthod
- (void)awakeFromNib {
    [super awakeFromNib];
    self.artDetailDescribe.delegate = self;
    self.artDetailDescribe.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - UIWebViewDelegate Menthod

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSInteger width = kSCREEN_WIDTH - 16;
    if (width == 320 - 16) {
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth,oldheight;"
         "var maxwidth= 304;"// 图片宽度
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "myimg.width = maxwidth;"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    }else if (width == 375 - 16){
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth,oldheight;"
         "var maxwidth= 359;"// 图片宽度
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "myimg.width = maxwidth;"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    }else if (width == 414 - 16){
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth,oldheight;"
         "var maxwidth= 398;"// 图片宽度
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "myimg.width = maxwidth;"
         "}"
         "}"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    }
 
    const CGFloat defaultWebViewHeight = 22.0;
    //reset webview size
    CGRect originalFrame = webView.frame;
    webView.frame = CGRectMake(8, originalFrame.origin.y, kSCREEN_WIDTH - 16, defaultWebViewHeight);
    
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    if (actualSize.height <= defaultWebViewHeight) {
        actualSize.height = defaultWebViewHeight;
    }
//    CGRect webViewFrame = webView.frame;
    originalFrame.size.height = actualSize.height;
    webView.frame = originalFrame;
    NSLog(@"%f",webView.frame.size.height);
    self.webViewHeight =  webView.frame.size.height;
    if (_didLoadWebView) {
        _didLoadWebView(_webViewHeight);
    }
}

@end
