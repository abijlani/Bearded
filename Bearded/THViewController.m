//
//  THViewController.m
//  Bearded
//
//  Created by Amit Bijlani on 12/10/12.
//  Copyright (c) 2012 Treehouse. All rights reserved.
//

#import "THViewController.h"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface THViewController ()

@end

@implementation THViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.beardView.userInteractionEnabled = YES;
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    UIPinchGestureRecognizer *pinchGestureRecognizer =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchZoomBeardView:)];
    pinchGestureRecognizer.delegate = self;
    [self.beardView addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer  *panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBeardView:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    [self.beardView addGestureRecognizer:panGestureRecognizer];
    
    if ( IS_IPHONE_5 )
        self.photoView.image = [UIImage imageNamed:@"photo-tall.png"];

}

#pragma mark -
#pragma mark Gesture Recognizer Action

- (void) pinchZoomBeardView:(UIPinchGestureRecognizer *)sender {
    
    UIView *beard = [sender view];
    
    // The scale factor between the two fingers
    CGFloat factor = [sender scale];
    
    // Apply transformation only for the beginning or changing states
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged )  {
        NSLog(@"Scale: %1.2f",factor);
        // Apply an affine transformation based on the factor
        beard.transform = CGAffineTransformMakeScale(factor, factor);        
    }
}

- (void) panBeardView:(UIPanGestureRecognizer *)sender {
    UIView *beard = [sender view];
        
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {

        // Get the panning move point relative to the parent view
        CGPoint translation = [sender translationInView:[beard superview]];
        //NSLog(@"x: %1.2f, y: %1.2f",translation.x,translation.y);
        
        // Add it to the center point of the beard view so that it stays
        // under the finger of the user
        [beard setCenter:CGPointMake([beard center].x + translation.x, [beard center].y + translation.y)];
        
        // Reset the translation to reduce panning velocity
        // Removing this line will result in the beard view disappearing very quickly
        [sender setTranslation:CGPointZero inView:[beard superview]];
    }
}

#pragma mark -
#pragma mark Toolbar Button Actions

- (void) cameraBtnAction:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a Picture",@"Choose from Library", nil];
    [actionSheet showInView:self.view];
    
}

- (void) shareBtnAction:(UIButton *)sender {
    
    
    // An array of content that needs to posted
    NSArray *activityItems = @[@"You have been Bearded!", UIImageJPEGRepresentation([self blendImages],0.75)];
    

    // Create a new UIActivityViewController with the activityItems array 
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                    initWithActivityItems:activityItems applicationActivities:nil];
    // Exclude activities that are irrelevant
    activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
    
    // Present the activityController
    [self presentViewController:activityController
                       animated:YES completion:nil];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Create a new image picker instance:
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // Set the image picker source:
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    
    picker.delegate = self;
    
    // Show picker only if "Take a picture" or "Choose from Library" is selected
    if ( buttonIndex == 0 || buttonIndex == 1)
        [self presentViewController:picker animated:YES completion:nil];    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    self.photoView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *) blendImages {
    UIImage *photoImage = self.photoView.image ;
    UIImage *beardImage = self.beardView.image;
    
    // Get the size of the photo
    CGSize photoSize = CGSizeMake(photoImage.size.width, photoImage.size.height);
    
    // Create a bitmap graphics context of the photoSize
    UIGraphicsBeginImageContext( photoSize );
    
    // Draw the photo in the specified rectangle area
    [photoImage drawInRect:CGRectMake(0,0,photoSize.width,photoSize.height)];
    
    CGPoint origin = self.beardView.frame.origin;
    CGSize size = self.beardView.frame.size;
    
    CGFloat xScale = photoImage.size.width / self.view.bounds.size.width;
    CGFloat yScale = photoImage.size.height / (self.view.bounds.size.height-44);
    
    // Draw the beard in the specified rectangle area
    [beardImage drawInRect:CGRectMake((origin.x * xScale), (origin.y * yScale),
                                       size.width * xScale, size.height * yScale)
                  blendMode:kCGBlendModeNormal alpha:1.0];
    
    // Save the generated image to an image object
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
