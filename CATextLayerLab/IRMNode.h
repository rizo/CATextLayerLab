//
//  IRMNode.h
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "IRMNodeLabel.h"


@interface IRMNode : CALayer
@property IRMNodeLabel *label;

- (id)initWithStateName:(NSString *)stateName
                 center:(CGPoint)center;

- (void)moveBy:(CGSize) delta;
@end
