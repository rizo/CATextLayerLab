//
//  IRMMainView.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "IRMMainView.h"
#import "IRMTextLayer.h"

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
    _containerLayer.name = @"containerLayer";
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
    _textLayer = [[IRMTextLayer alloc] initWithString:@"A Sun That Never Sets"];
    [_containerLayer addSublayer:_textLayer];
}


- (void)drawRect:(NSRect)dirtyRect
{
    $$

    [[NSColor blueColor] setFill];
    NSRectFill(dirtyRect);
}


- (void)mouseDown:(NSEvent *)event
{
    $$

    CGPoint pointOfClick = NSPointToCGPoint([self convertPoint:[event locationInWindow]
                                                      fromView:nil]);
    CALayer *hitLayer = [self.layer hitTest:pointOfClick];

    // Pass the control to the layer.
    if (hitLayer != nil)
    {
        if ([hitLayer isKindOfClass:[IRMTextLayer class]])
        {
            if ([event clickCount] > 1)
            {
                $(@"DBLClick on Text");
                [(IRMTextLayer *)hitLayer mouseDown:event];
            }
            else
                [self moveContainerLayerWithEvent:event];
        }

        else if (hitLayer.name == @"containerLayer")
        {
            $(@"Hit layer == containerLayer");
            [self moveContainerLayerWithEvent:event];
        }
    }

    // Start the selection.
    else
        $(@"TODO: Start the selection.");
}


- (void)moveContainerLayerWithEvent:(NSEvent *)event
{
    $$

    CGPoint currentPoint;
    CGPoint lastPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    BOOL didMove = NO, isMoving = NO;

    while ([event type] != NSLeftMouseUp)
    {
        event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask |
                                                      NSLeftMouseUpMask)];
        currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];
        if (!isMoving && ((fabs(currentPoint.x - lastPoint.x) >= 5.0f) ||
                          (fabs(currentPoint.y - lastPoint.y) >= 5.0f)))
        {
            isMoving = YES;
        }

        if (isMoving)
        {
            if (!CGPointEqualToPoint(lastPoint, currentPoint))
            {
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue
                                 forKey:kCATransactionDisableActions];
                _containerLayer.position = currentPoint;
                [CATransaction commit];

                didMove = YES;
            }
            lastPoint = currentPoint;
        }
    }

    if (isMoving)
    {
//        [self]
    }
}




@end





