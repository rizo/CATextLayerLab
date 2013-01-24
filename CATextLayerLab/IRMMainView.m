//
//  IRMMainView.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "IRMMainView.h"
#import "IRMNode.h"
#import "IRMNodeLabel.h"
#import "NSColor+IRMColorCompatibility.h"

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

    // Diagram Layer
    _diagram = [CATiledLayer layer];
    _diagram.delegate = self;
    _diagram.name = @"diagram";
    self.layer = _diagram;
    _diagram.needsDisplayOnBoundsChange = YES;

    self.nodes = [NSMutableArray array];

}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
    $$
    
    NSImage *bg = [NSImage imageNamed:@"Grid"];
    CGContextDrawTiledImage(context, CGRectMake(0,0,80,80), [self nsImageToCGImageRef:bg]);
}


- (CGImageRef)nsImageToCGImageRef:(NSImage*)image;
{
    NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef;
    if(!imageData)
        return nil;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    return imageRef;
}


- (void)mouseDown:(NSEvent *)event
{
    $$

    CGPoint pointOfClick = NSPointToCGPoint([self convertPoint:[event locationInWindow]
                                                      fromView:nil]);
    CALayer *hitLayer = [self.layer hitTest:pointOfClick];

    // Pass the control to the layer.
    if (hitLayer != nil && hitLayer.name != @"diagram")
    {
        if ([hitLayer isKindOfClass:[IRMNodeLabel class]])
        {
            if ([event clickCount] > 1)
            {
                [(IRMNodeLabel *)hitLayer mouseDown:event];
            }
            else
            {
                [self moveNode:((IRMNode *)hitLayer.superlayer) withEvent:event];
            }
        }

        else if ([hitLayer isKindOfClass:[IRMNode class]])
        {
            [self moveNode:(IRMNode *)hitLayer withEvent:event];
        }

        else
            $(@"Impossible: Wrong layer...");
    }

    // Start the selection or create a node.
    else
    {
        NSString *stateName = [NSString stringWithFormat:@"s%ld", [self.nodes count]];
        CGPoint nodeCenter = [self convertPoint:[event locationInWindow] fromView:nil];
        IRMNode *node = [[IRMNode alloc] initWithStateName:stateName
                                                    center:nodeCenter];
        [self.nodes addObject:node];
        [_diagram addSublayer:node];
    }
}


- (void)moveNode:(IRMNode *)node
       withEvent:(NSEvent *)event
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
                node.opacity = 0.5f;
                node.zPosition = 100;
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue
                                 forKey:kCATransactionDisableActions];
                node.position = currentPoint;
                [CATransaction commit];

                didMove = YES;
            }
            lastPoint = currentPoint;
        }
    }
    node.opacity = 1.0f;
    
    if (isMoving)
    {
//        [self]
    }
}




@end





