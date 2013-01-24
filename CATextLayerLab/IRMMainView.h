//
//  IRMMainView.h
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import <Cocoa/Cocoa.h>
#import "IRMNodeLabel.h"


@interface IRMMainView : NSView
@property CATiledLayer      *diagram;
@property CALayer      *containerLayer;
@property NSMutableArray *nodes;
@end
