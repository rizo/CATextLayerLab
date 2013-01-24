//
//  IRMNode.m
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import "IRMNode.h"

@implementation IRMNode

- (id)initWithStateName:(NSString *)stateName
                 center:(CGPoint)center
{
    $$

    if (self = [super init])
    {
        // Geomtery
        CGSize size = (CGSize) { 50.0f, 50.0f };
        self.position = (CGPoint) {
            center.x - size.width / 2.0f,
            center.y - size.height / 2.0f
        };

        self.frame = (CGRect) {
            self.position.x, self.position.y,
            size.width, size.height
        };

        // Style
        self.backgroundColor = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 1.0f);
        self.borderWidth = 2.0f;
        self.borderColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
        self.cornerRadius = 25.0f;

        // Options
        self.masksToBounds = NO;
        self.name = stateName;

        // Shadow
        self.shadowColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
        self.shadowOpacity = 0.65;
        self.shadowRadius = 4.0;
        self.shadowOffset = (CGSize) { 5.0f, -5.0f };

        // Layout
        self.layoutManager = [CAConstraintLayoutManager layoutManager];

        // Label
        _label = [[IRMNodeLabel alloc] initWithString:stateName];
        [self addSublayer:_label];
    }

    return self;
}


- (void)mouseDown:(NSEvent *)event
{
    $$    
}

@end
