//
//  Set_ViewController.m
//  SensorManager
//
//  Created by Set on 2012/12/13.
//  Copyright (c) 2012年 Set Minami. All rights reserved.
//

#import "Set_ViewController.h"
#import "SensorManager.h"
#import "LOGGER.h"

#define __DEBUG__


@interface Set_ViewController ()
@end

@implementation Set_ViewController
@synthesize webView = _webView,sManager = _sManager;

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    sManager = [[SensorManager alloc]init];
    NSArray* check = [sManager checkObjects];
    NSString* pictsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PeekaBoo/Pictures/"];
    NSFileManager* fManager = [NSFileManager defaultManager];
    NSError* error;
    NSURL* pictsURL = [NSURL fileURLWithPath:pictsPath];
    NSArray* prop = [NSArray arrayWithObjects:NSURLLocalizedNameKey,NSURLCreationDateKey,NSURLLocalizedTypeDescriptionKey,NSURLFileAllocatedSizeKey,nil];

    NSArray* picts;
    if(pictsURL != nil){
        picts = [fManager contentsOfDirectoryAtURL:pictsURL includingPropertiesForKeys:prop options:0 error:&error];
    }else{
        [fManager createDirectoryAtPath:pictsPath withIntermediateDirectories:NO attributes:nil error:&error];
    }

    NSMutableArray* notInDB = [[NSMutableArray alloc]init];
    int n = [check count];
    for (NSURL* fileName in picts) {
        NSLog(@"****%@¥n",fileName);
        Search hit = [sManager searchObject:fileName];
        if (hit == HIT_ONE_ELEMENT) {
            LOG(@"HIT_ONE%@",fileName);
        }else if(hit == HIT_ZERO_ELEMENT){
            ObjectsData* obj = [[ObjectsData alloc]init];
            
            [obj setFileType: @"png"];
            [obj setObjectId: ++n];
            [obj setObjectPath:[(NSURL*)fileName absoluteString]];
            [obj setUserId:1];
            [obj setDate:[NSDate date]];
            
            [notInDB addObject:obj];
        }
    }
    [sManager insertObjects:notInDB];
 }

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView = [[UIWebView alloc]init];
    [webView setDelegate:self];
    [webView setFrame:CGRectMake(0,0,300,300)];
    [webView setScalesPageToFit:YES];
    
    [self.view addSubview:webView];
    
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PeekaBoo/Pictures/1.png"];
    NSError* error;
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSString* PP = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@,%@,%@",PP,path,url.absoluteURL);

    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];

    

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
/*
 -(BOOL)canBecomeFirstResponder{
 return YES;
 }
 
 -(void)viewDidAppear:(BOOL)animated{
 [super viewDidAppear:animated];
 [self becomeFirstResponder];
 }
 
 - (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
 if (event.type == UIEventSubtypeMotionShake) {
 NSLog(@"Shaking　000");
 }
 }
 */
@end
