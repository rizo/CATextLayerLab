//
//  IRMMainView.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import <Quartz/Quartz.h>
#import "IRMMainView.h"

#define $COLOR(...) CGColorCreateGenericRGB(__VA_ARGS__);
#define $BLACK $COLOR(0.0f, 0.0f, 0.0f, 1.0f);
#define $WHITE $COLOR(1.0f, 1.0f, 1.0f, 1.0f);

#define $FONT(fontName) CGFontCreateWithFontName(CFSTR(fontName))


@implementation IRMMainView

- (void)awakeFromNib
{
    $$

    // View Setup
    self.wantsLayer = YES;

    // Root Layer
    _rootLayer = [CALayer layer];
    _rootLayer.backgroundColor = $COLOR(0.0f, 0.0f, 1.0f, 0.8f);
    self.layer = _rootLayer;

    // Container Layer
    _containerLayer = [CALayer layer];
    _containerLayer.position = (CGPoint) {0,0};
    _containerLayer.backgroundColor = $COLOR(0.0f, 0.9f, 0.0f, 1.0f);
    _containerLayer.frame = CGRectInset(self.frame, 50.0f, 50.0f);
    _containerLayer.borderColor = $WHITE;
    _containerLayer.cornerRadius = 20.0f;
    _containerLayer.masksToBounds = NO;
    _containerLayer.shadowColor = $BLACK;
    _containerLayer.shadowOpacity = 0.65;
    _containerLayer.shadowRadius = 6.0;
    _containerLayer.shadowOffset = (CGSize) { 10, 10 };
    _containerLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    [_rootLayer addSublayer:_containerLayer];

    // Text Layer
    _textLayer = [CATextLayer layer];
    _textLayer.string = @"A Sun That Never Sets";
    _textLayer.backgroundColor = $BLACK;

    CAConstraint *h = [CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                 relativeTo:@"superlayer"
                                                  attribute:kCAConstraintMidX];
    
    CAConstraint *v = [CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                 relativeTo:@"superlayer"
                                                  attribute:kCAConstraintMidY];
    [_textLayer addConstraint:h];
    [_textLayer addConstraint:v];
    [_containerLayer addSublayer:_textLayer];
}

- (void)drawRect:(NSRect)dirtyRect
{
    $$

    [[NSColor blueColor] setFill];
    NSRectFill(dirtyRect);
}





@end








