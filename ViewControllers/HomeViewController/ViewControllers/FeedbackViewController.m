//
//  FeedbackViewController.m
//  JinShiDai
//
//  Created by JopYin on 2017/5/27.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "FeedbackViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface FeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *feedbackContent;

@property (weak, nonatomic) UIView *placeHolder;

@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;

@end

@implementation FeedbackViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawBackButton];
    [self setNavTitle:@"我要提问"];
    self.view.backgroundColor = GroundColor;
    
    self.feedbackContent.font = [UIFont systemFontOfSize:font750(28.0f)];
    self.feedbackContent.delegate = self;
    self.feedbackContent.scrollEnabled = NO;
    [self setupTextView];
    
    self.feedbackBtn.layer.borderWidth = 0.8f;
    self.feedbackBtn.layer.borderColor = MainRed.CGColor;
    self.feedbackBtn.titleLabel.font = [UIFont systemFontOfSize:font750(32)];
}

- (void)setupTextView {
    UIView *placeHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 10, UI_WIDTH -200, 20)];
    placeHolder.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(begin)];
    [placeHolder addGestureRecognizer:tap];
    
    [self.feedbackContent addSubview:placeHolder];
    self.placeHolder = placeHolder;
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入您反馈的问题，不超过300个字符";
    placeHolderLabel.font = [UIFont systemFontOfSize:font750(32)];
    placeHolderLabel.textColor = KTColor_lightGray;
    [placeHolderLabel sizeToFit];
    
    [placeHolder addSubview:placeHolderLabel];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"edit"];
    [placeHolder addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeHolder.mas_left);
        make.top.equalTo(placeHolder.mas_top);
        make.width.height.equalTo(@14);
    }];
    
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(8);
        make.centerY.equalTo(imgView.mas_centerY);
        make.height.equalTo(@15);
    }];
    [self.feedbackContent bringSubviewToFront:placeHolder];
}


- (void)begin {
    self.placeHolder.hidden = YES;
    [self.feedbackContent becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.feedbackContent endEditing:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length) {
        self.placeHolder.hidden = YES;
    }else{
        self.placeHolder.hidden = NO;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.placeHolder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        self.placeHolder.hidden = YES;
    }else{
        self.placeHolder.hidden = NO;
    }
}

#pragma mark -意见反馈
- (IBAction)feedback:(id)sender {
    [SVProgressHUD dismiss];
    if (self.feedbackContent.text.length<5) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"问题字数不的少于5个字符" duration:1.0f];
        return;
    }
    NSDictionary * params =@{
                             @"Question":self.feedbackContent.text,
                             @"IsDisplay":@0,
                             @"Versions":@3,
                             @"CreateAuthor":[UserManager instance].userInfo.ID
                             };
    [[NetWorkManager manager] POST:Page_AskQuest tokenParams:params complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        if (![dic[@"qState"] isKindOfClass:[NSNull class]] && dic[@"qState"] != nil) {
            BOOL rec = [dic[@"qState"] boolValue];
            if (rec) {
                [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"问题已提交" duration:2.0f];
                [self doBack];
            }else{
                NSNumber * num = dic[@"AskNum"];
                if (num.intValue == 5) {
                    [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"提问已超过5次" duration:1.0f];
                }else{
                    [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"请求超时" duration:1.0f];
                }
                [self doBack];
            }
        }
    } error:^(JSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
