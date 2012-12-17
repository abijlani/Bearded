//
//  THAboutViewController.m
//  Bearded
//
//  Created by Amit Bijlani on 12/17/12.
//  Copyright (c) 2012 Treehouse. All rights reserved.
//

#import "THAboutViewController.h"

@interface THAboutViewController ()

@end

@implementation THAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController:)];
}

- (void) dismissViewController:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:@"http://teamtreehouse.com/library"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
