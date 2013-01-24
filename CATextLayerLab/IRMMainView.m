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
    CALayer *rootLayer = [CALayer layer];
    rootLayer.backgroundColor = $COLOR(0.0f, 0.0f, 1.0f, 0.8f);
    rootLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
    self.layer = rootLayer;

    // Container Layer
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = (CGRect) { 0, 0, 200, 200 };
    containerLayer.backgroundColor = $BLACK;

    CAConstraint *h = [CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                 relativeTo:@"superlayer"
                                                  attribute:kCAConstraintMidX];
    
    CAConstraint *v = [CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                 relativeTo:@"superlayer"
                                                  attribute:kCAConstraintMidY];
    [containerLayer addConstraint:h];
    [containerLayer addConstraint:v];
    [rootLayer addSublayer:containerLayer];
}

- (void)drawRect:(NSRect)dirtyRect
{
    $$

    [[NSColor blueColor] setFill];
    NSRectFill(dirtyRect);
}

@end
