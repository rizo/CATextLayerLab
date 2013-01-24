//
//  NSColor+IRMColorCompatibility.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "NSColor+IRMColorCompatibility.h"

static void drawCGImagePattern(void *info, CGContextRef context)
{
	CGImageRef image = info;

	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);

	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
}


static void releasePatternInfo (void *info)
{
	CFRelease(info);
}

@implementation NSColor (IRMCGColorCompatibility)

- (CGColorRef)IRMCGColor
{
	if ([self.colorSpaceName isEqualToString:NSPatternColorSpace]) {
		CGImageRef patternImage = [self.patternImage CGImageForProposedRect:NULL context:nil hints:nil];
		if (patternImage == NULL) {
			return NULL;
		}

		size_t width = CGImageGetWidth(patternImage);
		size_t height = CGImageGetHeight(patternImage);

		CGRect patternBounds = CGRectMake(0, 0, width, height);
		CGPatternRef pattern = CGPatternCreate(
                                               // Released in releasePatternInfo().
                                               (void *)CFRetain(patternImage),
                                               patternBounds,
                                               CGAffineTransformIdentity,
                                               width,
                                               height,
                                               kCGPatternTilingConstantSpacingMinimalDistortion,
                                               YES,
                                               &(CGPatternCallbacks){
                                                   .version = 0,
                                                   .drawPattern = &drawCGImagePattern,
                                                   .releaseInfo = &releasePatternInfo
                                               }
                                               );

		CGColorSpaceRef colorSpaceRef = CGColorSpaceCreatePattern(NULL);

		CGColorRef result = CGColorCreateWithPattern(colorSpaceRef, pattern, (CGFloat[]){ 1.0 });

		CGColorSpaceRelease(colorSpaceRef);
		CGPatternRelease(pattern);

		return result;
	}

	NSColorSpace *colorSpace = NSColorSpace.genericRGBColorSpace;
	NSColor *color = [self colorUsingColorSpace:colorSpace];

	CGFloat components[color.numberOfComponents];
	[color getComponents:components];

	CGColorSpaceRef colorSpaceRef = colorSpace.CGColorSpace;
	CGColorRef result = CGColorCreate(colorSpaceRef, components);
    
	return result;
}

@end
