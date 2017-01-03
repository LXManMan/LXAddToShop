//
//  ViewController.m
//  贝塞尔曲线之加入购物车
//
//  Created by chuanglong02 on 17/1/3.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "ViewController.h"
#define DeviceW [[UIScreen mainScreen]bounds].size.width
#define DeviceH [[UIScreen mainScreen]bounds].size.height
static NSString *cellId = @"cell";
#import "MyCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  [self.view addSubview:self.tableview];
  [self.view addSubview:self.shopView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    __weak ViewController *weakSelf = self;
    [cell setShoppingButtonBlock:^(CGPoint centerPoint) {
        
        [weakSelf startAnimate:centerPoint];
    }];
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceW, DeviceH-64)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView =[UIView new];
        [_tableview registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil]forCellReuseIdentifier:cellId];
        
    }
    return _tableview;
}
-(UIImageView *)shopView
{
    if (!_shopView) {
        _shopView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, DeviceH -64, 64, 64)];
        _shopView.image =[UIImage imageNamed:@"购物车"];
        _shopView.userInteractionEnabled = YES;
    }
    return _shopView;
}
-(void)startAnimate:(CGPoint)centerPoint
{
    //起点
    CGPoint startPoint = [self.tableview convertPoint:centerPoint toView:self.view];;
    CGPoint endpoint = self.shopView.center;
    //控点
    CGPoint controlPoint = CGPointMake(endpoint.x, startPoint.y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endpoint controlPoint:controlPoint];
    
    CAShapeLayer *layer =[CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.lineWidth = 3.0f;
    layer.shouldRasterize = YES;//抗锯齿
    [self.view.layer addSublayer:layer];
    
    //创建关键帧
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //动画时间
    animation.duration = 1;
    animation.path = path.CGPath
    ;
    //当动画完成，停留到结束位置
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.shopView.layer addAnimation:animation forKey:nil];
    path = nil;
    
}

@end
