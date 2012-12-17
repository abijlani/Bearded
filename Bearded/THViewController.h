//
//  THViewController.h
//  Bearded
//
//  Created by Amit Bijlani on 12/10/12.
//  Copyright (c) 2012 Treehouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *beardView;


- (IBAction)cameraBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;

@end
