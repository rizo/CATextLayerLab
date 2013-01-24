//
//  IRMNodeLabel.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "IRMNodeLabel.h"


@implementation IRMNodeLabel


- (id)initWithString:(NSString *)string
{
    $$

    if (self = [super init])
    {
        self.string = string;
#ifdef NODE_LABEL_DEBUG
        self.borderWidth = 1.0f;
        self.borderColor = CGColorCreateGenericRGB(1.0f, 0.0f, 0.0f, 1.0f);
#endif
        self.font = CGFontCreateWithFontName(CFSTR("Verdana"));
        self.fontSize = 23.0f;
        self.foregroundColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);

        CAConstraint *h = [CAConstraint constraintWithAttribute:kCAConstraintMidX
                                                     relativeTo:@"superlayer"
                                                      attribute:kCAConstraintMidX];

        CAConstraint *v = [CAConstraint constraintWithAttribute:kCAConstraintMidY
                                                     relativeTo:@"superlayer"
                                                      attribute:kCAConstraintMidY];
        [self addConstraint:h];
        [self addConstraint:v];
    }

    return self;
}


- (void)mouseDown:(NSEvent *)event
{
    $$
}

@end
