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

- (id)initWithFrame:(NSRect)frame
{
    $$
    
    if (self = [super initWithFrame:frame])
    {
        ;
    }

    return self;
}


- (void)awakeFromNib
{
    $$

    // View Setup
    self.wantsLayer = YES;

    // Diagram Layer
    _diagram = [CALayer layer];
    _diagram.name = @"diagram";
    _diagram.backgroundColor = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 0.6f);
    self.layer = _diagram;

    self.nodes = [NSMutableArray array];

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
        $(@"%@", self.nodes);
        [_diagram addSublayer:node];
    }

    [self setNeedsDisplay:YES];
}


- (void)drawrect:(NSRect)rect
{
    $$

    // Obtain and save the current context.
//    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]
//                                          graphicsPort];
//    CGContextSaveGState(context);
//
//    // Set the color space.
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextSetFillColorSpace(context, colorSpace);
//    CGContextSetStrokeColorSpace(context, colorSpace);
//    CGColorSpaceRelease(colorSpace);

    // Draw the background.
    NSString *imageName = [[NSBundle mainBundle] pathForResource:@"Grid" ofType:@"png"];
    NSImage *bg = [[NSImage alloc] initWithContentsOfFile:imageName];
    NSColor *backgroundColor = [NSColor colorWithPatternImage:bg];
    [backgroundColor set];
    NSRectFill(rect);

//
//    NSString *imageName = [[NSBundle mainBundle] pathForResource:@"Grid" ofType:@"png"];
//    NSColor *tileColor = [NSColor colorWithPatternImage:[[NSImage alloc] initWithContentsOfFile:imageName]];
//
//    CGColorRef tileCGColor = [tileColor IRMCGColor];
//    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelPattern)
//    {
//        CGFloat alpha = 1.0f;
//        CGContextSetFillPattern(context, CGColorGetPattern(tileCGColor), &alpha);
//    }
//    else
//    {
//        CGContextSetFillColor(context, CGColorGetComponents(tileCGColor));
//    }
//
//    CGContextFillRect(context, self.bounds);
//    
//    // Restore the context.
//    CGContextRestoreGState(context);
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

    if (isMoving)
    {
//        [self]
    }
}




@end





