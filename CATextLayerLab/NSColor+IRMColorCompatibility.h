//
//  NSColor+IRMColorCompatibility.h
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import <AppKit/AppKit.h>

// Extensions to NSColor for compatibility with CGColor.
@interface NSColor (IRMColorCompatibility)

// The CGColor corresponding to the receiver.
@property (nonatomic, readonly) CGColorRef IRMCGColor;

@end