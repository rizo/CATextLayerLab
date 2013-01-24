//
//  IRMDiagram.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "IRMDiagram.h"

@implementation IRMDiagram

- (id)init
{
    $$

    if (self = [super init])
    {
        self.name = @"diagram";
    }

    return self;
}


- (void)drawInContext:(CGContextRef)theContext
{
    $$
    NSImage *bg = [NSImage imageNamed:@"Grid"];
    NSColor *backgroundColor = [NSColor colorWithPatternImage:bg];
	[backgroundColor set];

    NSRectFill(self.bounds);
}


@end
