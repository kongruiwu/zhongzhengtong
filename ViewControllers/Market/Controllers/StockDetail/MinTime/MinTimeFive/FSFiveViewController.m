//
//  FSFiveViewController.m
//  YunZhangCaiJing
//
//  @Author: JopYin on 16/3/31.
//  Copyright © 2016年 JopYin. All rights reserved.
//

#import "FSFiveViewController.h"
#import "StockPublic.h"

@interface FSFiveViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sell5A;
@property (weak, nonatomic) IBOutlet UILabel *sell5B;
@property (weak, nonatomic) IBOutlet UILabel *sell4A;
@property (weak, nonatomic) IBOutlet UILabel *sell4B;
@property (weak, nonatomic) IBOutlet UILabel *sell3A;
@property (weak, nonatomic) IBOutlet UILabel *sell3B;
@property (weak, nonatomic) IBOutlet UILabel *sell2A;
@property (weak, nonatomic) IBOutlet UILabel *sell2B;
@property (weak, nonatomic) IBOutlet UILabel *sell1A;
@property (weak, nonatomic) IBOutlet UILabel *sell1B;

@property (weak, nonatomic) IBOutlet UILabel *buy1A;
@property (weak, nonatomic) IBOutlet UILabel *buy1B;
@property (weak, nonatomic) IBOutlet UILabel *buy2A;
@property (weak, nonatomic) IBOutlet UILabel *buy2B;
@property (weak, nonatomic) IBOutlet UILabel *buy3A;
@property (weak, nonatomic) IBOutlet UILabel *buy3B;
@property (weak, nonatomic) IBOutlet UILabel *buy4A;
@property (weak, nonatomic) IBOutlet UILabel *buy4B;
@property (weak, nonatomic) IBOutlet UILabel *buy5A;
@property (weak, nonatomic) IBOutlet UILabel *buy5B;


@end

@implementation FSFiveViewController

- (void)updateUIWithData:(QuoteModel *)model{
    NSArray *sellPriceArr = [[NSArray alloc] initWithObjects:_sell1A, _sell2A,_sell3A,_sell4A,_sell5A, nil];
    NSArray *sellVolArr = [[NSArray alloc] initWithObjects:_sell1B, _sell2B,_sell3B,_sell4B,_sell5B, nil];
    NSArray *buyPriceArr = [[NSArray alloc] initWithObjects:_buy1A, _buy2A,_buy3A,_buy4A,_buy5A, nil];
    NSArray *buyVolArr = [[NSArray alloc] initWithObjects:_buy1B, _buy2B,_buy3B,_buy4B,_buy5B, nil];
    for (int i=0; i < 5; i++) {
        UILabel *sellPrice = sellPriceArr[i];
        UILabel *sellVol = sellVolArr[i];
        UILabel *buyPrice = buyPriceArr[i];
        UILabel *buyVol = buyVolArr[i];
        
        sellPrice.text = model.sellPrice[i];
        sellVol.text = [StockPublic caldata:model.sellVOL[i]];
        buyPrice.text = model.buyPrice[i];
        buyVol.text  = [StockPublic caldata:model.buyVOL[i]];
        
        if ([model.sellPrice[i] floatValue] >= [model.closePrice floatValue]) {
            sellPrice.textColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"#C90011"];
        }else{
            sellPrice.textColor = UIColorFromRGB(0x19BD9C);//[UIColor colorWithHexString:@"#19BD9C"];
        }
        if ([model.buyPrice[i] floatValue] >= [model.closePrice floatValue]) {
            buyPrice.textColor = UIColorFromRGB(0xC90011);//[UIColor colorWithHexString:@"#C90011"];
        }else{
            buyPrice.textColor = UIColorFromRGB(0x19BD9C);//[UIColor colorWithHexString:@"#19BD9C"];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
