//
//  IRMNodeLabel.h
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import <QuartzCore/QuartzCore.h>

@interface IRMNodeLabel : CATextLayer

- (id)initWithString:(NSString *)string;

- (void)mouseDown:(NSEvent *)event;

@end
