//
//  IRMTextLayer.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "IRMTextLayer.h"

@implementation IRMTextLayer


- (id)initWithString:(NSString *)string
{
    if (self = [super init])
    {
        self.string = string;
        self.backgroundColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);

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

@end
