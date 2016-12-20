//
//  ViewController.m
//  01-网易新闻详情页
//
//  Created by 初七 on 2016/12/20.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // http://c.m.163.com/nc/article/BJ5NRE5T00031H2L/full.html
    
    // 1.设置url
    NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/nc/article/BJ5NRE5T00031H2L/full.html"];
    // 2.设置请求
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    // 3.开启异步请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 判断
        if (error == nil) {
            // 转为json数据
            NSError *error;
            NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            // 处理拿到的数据并显示
            [self dealNewsDetailWithJsonData:jsonData];
        }
    }];
    // 4.开启请求
    [task resume];
}
#pragma mark - 处理拿到的数据并显示
- (void)dealNewsDetailWithJsonData:(NSDictionary *)jsonData{
    // 1. 取出所有的内容
    NSDictionary *allData = jsonData[@"BJ5NRE5T00031H2L"];
    // 2. 取出body中的内容
    NSString *bodyHtml = allData[@"body"];
    // 3.取出标题
    NSString *title = allData[@"title"];
    // 4.取出发布时间
    NSString *ptime = allData[@"ptime"];
    // 5.取出新闻来源
    NSString *source = allData[@"source"];
    // 6.取出所有的图片对象
    NSArray *imgArray = allData[@"img"];
    // 7.遍历图片数组
    for (NSDictionary *imgItem in imgArray) { // 7.1取出单独的图片对象
        // 7.2取出图片占位标签
        NSString *ref = imgItem[@"ref"];
        // 7.3取出图片标题
        NSString *alt = imgItem[@"alt"];
        
        // 7.4取出图片src
        NSString *src = imgItem[@"src"];
        NSString *imgHtml = [NSString stringWithFormat:@"<div><img src=\"%@\"><div class=\"all-img\">%@</div></div>",src,alt];
        // 7.5替换body中的图片占位符
        bodyHtml = [bodyHtml stringByReplacingOccurrencesOfString:ref withString:imgHtml]; // 用后替换前
    }
    
    // 创建标题的html标签
    NSString *titleHtml = [NSString stringWithFormat:@"<div id=\"mainTitle\">%@</div>",title];
    // 创建子标题的html标签
    NSString *subTitleHtml = [NSString stringWithFormat:@"<div id=\"subTitle\"><span class=\"time\">%@</span><span>%@</span></div>",ptime,source];
    
    // 加载css的url路径
    NSURL *cssUrl = [[NSBundle mainBundle] URLForResource:@"newsDetail" withExtension:@"css"];
    // 创建html标签
    NSString *cssHtml = [NSString stringWithFormat:@"<link href=\"%@\" rel=\"stylesheet\">",cssUrl];
    
    // 加载js的url路径
    NSURL *jsUrl = [[NSBundle mainBundle] URLForResource:@"newsDetail" withExtension:@"js"];
    // 创建html标签
    NSString *jsHtml = [NSString stringWithFormat:@"<script src=\"%@\"></script>",jsUrl];
    
    // 拼接html
    NSString *html = [NSString stringWithFormat:@"<html><head>%@</head><body>%@%@%@%@</body></html>",cssHtml,titleHtml,subTitleHtml,bodyHtml,jsHtml];
    // 8. 把对应的内容显示到webView中
    [self.webView loadHTMLString:html baseURL:nil];
    
}
#pragma mark - <UIWebViewDelegate>
#pragma mark * 决定是否能加载网络请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    // 取出请求字符串
    NSString *requestStr = request.URL.absoluteString;
    
    // 判断处理(判断请求头里包不包含header)
    NSString *header= @"wxh:///";
    
    NSRange range = [requestStr rangeOfString:header];
    NSInteger location = range.location;
    
    if (location != NSNotFound) { // 包含了协议头
        // 取出要操作的方法名称
        NSString *method = [requestStr substringFromIndex:range.length];
        // 包装成SEL
        SEL sel = NSSelectorFromString(method);
        // 执行操作
        /*
        [self performSelector:sel];  
         会报可能内存泄漏的警告,参考:http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown或者http://blog.csdn.net/majiakun1/article/details/46424925
         */
        [self performSelector:sel withObject:nil afterDelay:0];
    }
    return YES;
}

#pragma mark - 调取相册
- (void)openCamera{
    // 创建系统相册
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    // 设置相册类型
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 弹出相册
    [self presentViewController:pickerVC animated:YES completion:nil];
}
@end
