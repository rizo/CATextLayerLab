


- (CALayer*) hitTestPoint: (NSPoint)locationInWindow offset: (CGPoint*)outOffset
{ // I copied this from other sources, I didn't create them
    CGPoint where = NSPointToCGPoint([self convertPoint: locationInWindow fromView: nil]);
    where = [self.layer convertPoint: where fromLayer: self.layer];
    CALayer *layer = [self.layer hitTest: where];
    if ( layer != self.layer ){
        CGPoint bitPos = [self.layer convertPoint: layer.position
                          acti		fromLayer: layer.superlayer];
        if( outOffset )
            *outOffset = CGPointMake( bitPos.x-where.x, bitPos.y-where.y);

        return layer;
    }
    else
        return nil;
}

CGRect SKTRectFromPoints(NSPoint point1, CGPoint point2) { // I copied this from other sources, I didn't create them
    return NSRectToCGRect(NSMakeRect(((point1.x <= point2.x) ? point1.x : point2.x),
                                     ((point1.y <= point2.y) ? point1.y : point2.y),
                                     ((point1.x <= point2.x) ? point2.x - point1.x : point1.x - point2.x),
                                     ((point1.y <= point2.y) ? point2.y - point1.y : point1.y - point2.y)));
}

- (void) mouseDown: (NSEvent*)ev
{

    dragStartPos = ev.locationInWindow;
    previouslyDraggedLayer = draggingLayer;
    draggingLayer = [self hitTestPoint: dragStartPos offset: &dragOffset]; // this tells me what i'm clicking on, if anything

    if ( draggingLayer ){ // make the layer highlight in some way. I put a border around it
        draggingLayer.zPosition = 100;
        draggingLayer.shadowOffset = CGSizeMake(3, -3);
        draggingLayer.shadowOpacity = 0.7;
        draggingLayer.borderWidth = 2.0;
        draggingLayer.borderColor = CGColorCreateGenericRGB(0,0,1,1);

        dragStartPos = ev.locationInWindow;
        dragStartPos = [self convertPoint: dragStartPos fromView: nil]; // this corrects the offset for any others past the first
        dragStartPos.x += dragOffset.x; // without these three lines, any other ones being dragged jumped just a little when first
        dragStartPos.y += dragOffset.y; // being dragged but not any after that.

    } else { // I have hit nothing, let's make a selection rectangle
        CGPoint curPoint;
        dragStartPos = [self convertPoint:dragStartPos fromView:nil];

        if ( !dragRectangle ){ // I tried to set this up in initWithFrame but half the time it didn't show up. This is more "lazy" anyway, setting it up
                               // when you need it makes the app launch a litle faster anyway
            dragRectangle = [[CALayer alloc] init];
            [dragRectangle retain]; // with garbage collection, I probably don't need this, but better to have it
            [self.layer addSublayer:dragRectangle];
        }
        previouslyDraggedLayer.borderWidth = 0;

        [CATransaction flush]; // standard "don't animate what I'm about to do stuff
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];

        dragRectangle.backgroundColor = CGColorCreateGenericRGB(.7,.8,.9,.5); // as close as I can come to Apple's colors
        dragRectangle.borderWidth = 1;
        dragRectangle.borderColor = CGColorCreateGenericRGB(.1,.2,1,.5);
        dragRectangle.zPosition = 100;
        dragRectangle.position = NSPointToCGPoint(dragStartPos);
        dragRectangle.hidden = NO;
        dragRectangle.frame = CGRectMake(0,0,1,1); // make a tiny thing to start
        [CATransaction commit];

        while ([ev type] != NSLeftMouseUp) { // and then do it until I release the mouse.
                                             //NSLog (@"trying to drag");
            ev = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
            curPoint = NSPointToCGPoint([self convertPoint:[ev locationInWindow] fromView:nil]); // I'm in a scroll view, so get where I really am
            [CATransaction flush];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue
                             forKey:kCATransactionDisableActions];
            dragRectangle.frame = SKTRectFromPoints(dragStartPos, curPoint); // and finally make the rectangle
            [CATransaction commit];

            // here's where you'll put your code to see if you actually hit something
        }
        dragRectangle.hidden = YES; // the mouse has been released, hide the rectangle
    }

}

- (void)mouseDragged:(NSEvent *)event
{

    NSPoint pos = ev.locationInWindow;
    NSPoint where = [self convertPoint: pos fromView: nil];
    where.x += dragOffset.x;
    where.y += dragOffset.y;

    for ( CALayer *obj in selectionRectImages ){ //I've put all the CALayers I picked up from the selection rect into this array
    	CGPoint newPos = [obj.superlayer convertPoint: NSPointToCGPoint(where) fromLayer: self.layer];
    	[CATransaction flush];
    	[CATransaction begin];
    	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

    	if ( [obj isEqual:draggingLayer] ){
    		obj.position = newPos; // it just goes to the new position, no sweat
    	}
    	else {
    		newPos.x = obj.position.x + (newPos.x - dragStartPos.x); // took me so long. Basically the position of this object is where it currently is, plus where the object being
    		newPos.y = obj.position.y + (newPos.y - dragStartPos.y); // dragged is going, minus where the drag started, which is corrected for the offset already
    		obj.position = newPos;
    	}
    	dragStartPos = where; // this is also key, because now when I drag a little more, I have to start the drag from where I ended last time
    }
    
}

@end