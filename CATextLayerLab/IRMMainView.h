//
//  IRMMainView.h
//  CATextLayerLab
//
//  Created by Rizo Isrof on 1/24/13.
//
//

#import <Cocoa/Cocoa.h>
#import "IRMTextLayer.h"


@interface IRMMainView : NSView
@property CALayer      *rootLayer;
@property CALayer      *containerLayer;
@property IRMTextLayer *textLayer;
@end
