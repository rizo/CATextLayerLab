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

#define EDIT_TOOL 0
#define MOVE_TOOL 1

#define $COLOR(...) CGColorCreateGenericRGB(__VA_ARGS__);
#define $BLACK $COLOR(0.0f, 0.0f, 0.0f, 1.0f);
#define $WHITE $COLOR(1.0f, 1.0f, 1.0f, 1.0f);

#define $FONT(fontName) CGFontCreateWithFontName(CFSTR(fontName))

static int TOOL = 0;


CGRect SKTRectFromPoints(NSPoint point1, CGPoint point2)
{
    return NSRectToCGRect(NSMakeRect(((point1.x <= point2.x) ? point1.x : point2.x),
                                     ((point1.y <= point2.y) ? point1.y : point2.y),
                                     ((point1.x <= point2.x) ? point2.x - point1.x : point1.x - point2.x),
                                     ((point1.y <= point2.y) ? point2.y - point1.y : point1.y - point2.y)));
}


@implementation IRMMainView

static const NSSize unitSize = {1.0, 1.0};

// Returns the scale of the receiver's coordinate system, relative to the window's base coordinate system.
- (NSSize)scale;
{
    return [self convertSize:unitSize toView:nil];
}

// Sets the scale in absolute terms.
- (void)setScale:(NSSize)newScale;
{
    [self resetScaling]; // First, match our scaling to the window's coordinate system
    [self scaleUnitSquareToSize:newScale]; // Then, set the scale.
    [self setNeedsDisplay:YES]; // Finally, mark the view as needing to be redrawn
}

// Makes the scaling of the receiver equal to the window's base coordinate system.
- (void)resetScaling;
{
    [self scaleUnitSquareToSize:[self convertSize:unitSize fromView:nil]];
}

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

- (BOOL)acceptsFirstResponder
{
    return YES;
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
        if (TOOL == EDIT_TOOL)
        {
            NSString *stateName = [NSString stringWithFormat:@"s%ld", [self.nodes count]];
            CGPoint nodeCenter = [self convertPoint:[event locationInWindow] fromView:nil];
            IRMNode *node = [[IRMNode alloc] initWithStateName:stateName
                                                        center:nodeCenter];
            [self.nodes addObject:node];
            [_diagram addSublayer:node];
        }

        // MOVE TOOL
        else
        {
            $(@"Move Tool");
            CGPoint currentPoint;
            CALayer *selection = [CALayer layer];
            selection.backgroundColor = CGColorCreateGenericRGB(.7,.8,.9,.3);
            selection.borderWidth = 1.0f;
            selection.borderColor = CGColorCreateGenericRGB(.1,.2,1,.5);
            selection.zPosition = 101;
            selection.position = pointOfClick;
            selection.hidden = NO;
            selection.frame = CGRectMake(0,0,1,1);
            [_diagram addSublayer:selection];

            while ([event type] != NSLeftMouseUp)
            {
                $(@"Move...");
                event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask |
                                                              NSLeftMouseUpMask)];
                currentPoint = NSPointToCGPoint([self convertPoint:[event locationInWindow] fromView:nil]);
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue
                                 forKey:kCATransactionDisableActions];
                selection.frame = SKTRectFromPoints(pointOfClick, currentPoint);

                for (IRMNode *node in self.nodes) {
                    if (CGRectIntersectsRect(node.frame, selection.frame))
                        node.borderColor = CGColorCreateGenericRGB(.1,1,1,.5);
                    else
                        node.borderColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
                }

                [CATransaction commit];
            }
            selection.hidden = YES;
        }
    }
}


- (void)keyDown:(NSEvent *)event
{
    $$

    TOOL = !TOOL;
}


- (void)moveNode:(IRMNode *)node
       withEvent:(NSEvent *)event
{
    $$

    CGPoint lastPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    CGPoint currentPoint, delta = CGPointMake(lastPoint.x - node.anchorPoint.x,
                                              lastPoint.y - node.anchorPoint.y);

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
                delta = CGPointMake(currentPoint.x - lastPoint.x,
                                    currentPoint.y - lastPoint.y);

//                node.opacity = 0.5f;
                node.zPosition = 100;
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue
                                 forKey:kCATransactionDisableActions];
//                node.position = currentPoint;
                for (IRMNode *node in self.nodes)
                    [node moveBy:(CGSize){delta.x, delta.y}];
                [CATransaction commit];

                didMove = YES;
            }
            lastPoint = currentPoint;
        }
    }
    node.opacity = 1.0f;
    node.zPosition = 1;

    if (isMoving)
    {
//        [self]
    }
}




@end





