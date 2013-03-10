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
@synthesize webView = _webView,sManager = _sManager,isSetWebview = _isSetWebview,addressBar = _addressBar,window = _window;

-(id)init{
    self = [super init];
    main_queue = dispatch_get_main_queue();
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(setup) withObject:nil waitUntilDone:YES];
    }else{
        [self setup];
    }

    return self;
}

-(void)setup{
//    dispatch_async(main_queue, ^{
    
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
    [sManager lock];
    [sManager setIsdbReady:YES];
    [sManager unlock];

    //addressBar = [[UINavigationBar alloc]init];
    //addressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    });
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    /*if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(changeWebView) withObject:nil waitUntilDone:YES];
    }else{
        [self getWebView];
    }
    */
    
//    [self.view addSubview:webView];
//    [self.view addSubview:addressBar];
 }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self getWebView];

    //[self.view bringSubviewToFront:webView];
    
 //   dispatch_async(main_queue,^{
  //  [self.view removeFromSuperview];
  //  [self.view reloadInputViews];
  //  [webView reloadInputViews];
//    });
    
}

-(void) getWebView{
    
//    webView = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"iPhone"];
    //[[self storyboard]instantiateViewControllerWithIdentifier:@"Set_ViewController"];//
    webView = [[UIWebView alloc]init];
    
    webView.delegate = self;
    if (webView.delegate != nil){
        NSLog(@"Set Delegate!");
    }else{
        NSLog(@"Not Set Delegate");
    }
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    //[webView loadHTMLString:@"http://www.google.co.jp" baseURL:nil ];
    //[webView removeFromSuperview];
    //window = [[UIWindow alloc]initWithFrame:rect];

    [webView setFrame:rect];
    [webView setScalesPageToFit:YES];
    
    webView.opaque = YES;
    webView.suppressesIncrementalRendering = YES;
    //[webView loadHTMLString:@"" baseURL:nil];
    NSURL* path = [[[SensorManager alloc]init] changeObj:1];
    
    //[webView stopLoading];

    
    NSString* s = path.absoluteString;
    NSLog(@"$$$%@",s);
    NSURLRequest* req = [NSURLRequest requestWithURL:path];
   
   // [self.view bringSubviewToFront:webView];
    [webView loadRequest:req];
    if([webView canGoForward])[webView goForward];
    [self.view addSubview:webView];
    //NSData* data = [NSData dataWithContentsOfFile:s];
    //[webView loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"file:///"]];
    //[webView drawRect:CGRectMake(0,0,300,300)];
    //[webView reload];
    
    //webView = nil;
//    [self.view performSelectorOnMainThread:@selector(addSubview:) withObject:addressBar waitUntilDone:NO];
     
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"Start Req ");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"Finish Req");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(BOOL)webView:(UIWebView *)__webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* reqString = [[request URL]absoluteString];
    NSLog(@"||||||%@",reqString);
    return YES;
}


-(void)dealloc{
    webView = nil;
}

@end
