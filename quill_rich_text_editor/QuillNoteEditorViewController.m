//
//  QuillNoteEditorViewController.m
//  iOSQuillEditor
//
//  Created by Shubham Aggarwal on 21/05/17.
//  Copyright © 2015 Sort. All rights reserved.
//

#import "QuillNoteEditorViewController.h"
#import <objc/runtime.h>

@interface UIWebView (HackishAccessoryHiding)
@property (nonatomic, assign) BOOL hidesInputAccessoryView;
@end

@implementation UIWebView (HackishAccessoryHiding)

static const char * const hackishFixClassName = "UIWebBrowserViewMinusAccessoryView";
static Class hackishFixClass = Nil;

- (UIView *)hackishlyFoundBrowserView {
    UIScrollView *scrollView = self.scrollView;
    
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}

- (id)methodReturningNil {
    return nil;
}

- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        
        hackishFixClass = newClass;
    }
}

- (BOOL) hidesInputAccessoryView {
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
}

- (void) setHidesInputAccessoryView:(BOOL)value {
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    
    if (value) {
        object_setClass(browserView, hackishFixClass);
    }
    else {
        Class normalClass = objc_getClass("UIWebBrowserView");
        object_setClass(browserView, normalClass);
    }
    [browserView reloadInputViews];
}

@end






@interface QuillNoteEditorViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,assign) BOOL formatHTML;
@property (nonatomic,assign) BOOL hasAppearedForFirstTime;
@end

@implementation QuillNoteEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatHTML = YES;
    _isContentLoaded = NO;
    _hasAppearedForFirstTime = YES;
    // Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.keyboardDisplayRequiresUserAction = NO;
    _webView.scalesPageToFit = YES;
    _webView.hidesInputAccessoryView = YES;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    [_webView.scrollView setContentInset:UIEdgeInsetsMake(12, 0, 0, 0)];
    //_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _webView.scrollView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSString *bundlePath = [NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] bundlePath]];
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:bundlePath]];
    
    self.view.backgroundColor = [UIColor redColor];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_hasAppearedForFirstTime){
        self.webView.frame = self.view.frame;
    }
    _hasAppearedForFirstTime = NO;
   ///NSLog(@"frame: %f,%f",self.view.frame.size.width,self.view.frame.size.height);
}

-(void)onViewWillTransitToSize:(CGSize)size{
    NSLog(@"onViewWillTransitToSize");
    _webView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (NSString *)removeQuotesFromHTML:(NSString *)html {
    NSLog(@"removeQuotesFromHTML");
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    return html;
}


- (NSString *)tidyHTML:(NSString *)html {
    NSLog(@"tidyHTML");
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
    if (self.formatHTML) {
        //html = [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html(\"%@\");", html]];
    }
    return html;
}//end



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTextInWebView:(NSString *)deltaObject{
    NSLog(@"setUpTextInWebView");
    NSLog(@"DELTA OBJECT -> %@", deltaObject);
    NSString *setEditorContentCommand = [NSString stringWithFormat:@"updateWebViewContents(%@);", deltaObject];
    [_webView stringByEvaluatingJavaScriptFromString:setEditorContentCommand];
}

-(void)setLineAlignment:(NSString *)alignment{
    NSLog(@"setLineAlignment");
    NSString *lineAlignment = [NSString stringWithFormat:@"setLineAlignment('%@');",alignment];
    [_webView stringByEvaluatingJavaScriptFromString:lineAlignment];
}

-(void)setTextFormat:(NSString *)format andApply:(BOOL)apply{
    NSLog(@"setTextFormat");
    NSString *textFormat;
    if(apply){
        textFormat = [NSString stringWithFormat:@"setTextFormat('%@',true);",format];
    }else{
        textFormat = [NSString stringWithFormat:@"setTextFormat('%@',false);",format];
    }
    [_webView stringByEvaluatingJavaScriptFromString:textFormat];
}

-(void)setTextAlignment:(NSString *)alignment{
    NSLog(@"setTextAlignment");
    NSString *textAlignment = [NSString stringWithFormat:@"setTextAlignment('%@');",alignment];
    [_webView stringByEvaluatingJavaScriptFromString:textAlignment];
}

-(void)setLineFormat:(NSString *)format{
    NSLog(@"setLineFormat");
    NSString *lineFormat = [NSString stringWithFormat:@"setLineFormat('%@',true);",format];
    [_webView stringByEvaluatingJavaScriptFromString:lineFormat];
}


-(void)focusEditor{
    NSLog(@"focusEditor");
    NSString *focusString = [NSString stringWithFormat:@"editor.focus()"];
    [_webView stringByEvaluatingJavaScriptFromString:focusString];
}

-(void)setHTML:(NSString *)html{
    NSLog(@"setHTML");
    html = [self removeQuotesFromHTML:html];
    NSString *htmlSetter = [NSString stringWithFormat:@"setHTML(\"%@\")",html];
    [_webView stringByEvaluatingJavaScriptFromString:htmlSetter];
}

-(NSString *)getHTML{
    NSLog(@"getHTML");
    NSString *htmlGetter = [NSString stringWithFormat:@"getHTML();"];
    return [_webView stringByEvaluatingJavaScriptFromString:htmlGetter];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError");
    NSLog(@"Error: %@",error);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"webView shouldStartLoadWithRequest");
    NSString *urlString = [request.URL absoluteString];
    if([urlString rangeOfString:@"edit://"].location == NSNotFound)  return YES;
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"edit://selection/" withString:@""];
    NSArray *components = [urlString componentsSeparatedByString:@"/"];
    
    NSInteger start = [[components objectAtIndex:0] integerValue];
    NSInteger end = [[components objectAtIndex:1] integerValue];
    
    NSString *attributesString = [components objectAtIndex:2];
    if([attributesString length] > 0){
        NSArray *attributes = [attributesString componentsSeparatedByString:@","];
        if(self.delegate){
            [self.delegate onSelectedTextinRange:NSMakeRange(start,(end - start + 1)) havingAttributes:attributes];
        }
    }else{
        if(self.delegate){
            [self.delegate onSelectedTextinRange:NSMakeRange(start, (end - start + 1)) havingAttributes:@[]];
        }
    }
    
    return NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidFinishLoad");
    if(self.delegate){
        [self.delegate onWebViewLoaded];
    }
    _isContentLoaded = YES;
    if(_focusEditorWhenLoaded){
        [self focusEditor];
    }
    
    
    //Set max width!
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float sfactor = viewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = sfactor;
    webView.scrollView.maximumZoomScale = sfactor;
    webView.scrollView.zoomScale = sfactor;


}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll");
    [_webView.scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
