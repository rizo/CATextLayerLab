//
//  IRMTestView.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "IRMTestView.h"

@implementation IRMTestView

- (id)initWithFrame:(NSRect)frame
{
    $$

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    $$

    [super drawRect:dirtyRect];

    NSImage *bg = [NSImage imageNamed:@"Grid"];
    NSColor *backgroundColor = [NSColor colorWithPatternImage:bg];
	[backgroundColor set];

    NSRectFill([self bounds]);
}

@end
