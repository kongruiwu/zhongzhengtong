//
//  WMXPickerTF.h
//  textFieldTest
//
//  Created by pipiwu on 15/4/24.
//  Copyright (c) 2015年 pipiwu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMXPickerTF;

@protocol WMXPickerTFDelegate <NSObject>

@optional
- (void)selectedObjectClearedForPickTF:(WMXPickerTF *)pickerTF;
- (void)selectObject:(NSString *)string changedForPickerTF:(WMXPickerTF *)pickerTF;
- (void)somethingChanged:(WMXPickerTF *)pickerTF;
@end

@interface WMXPickerTF : UITextField <UIKeyInput,UITextFieldDelegate>
@property (nonatomic, weak) id <WMXPickerTFDelegate> pickerDelegate;
@property (nonatomic, weak) IBOutlet UIView *calculateView;   //股票搜索数字键盘 对应的是calculate.xib
@property (nonatomic, assign) BOOL isSelected;

@property (weak, nonatomic) IBOutlet UIView *PMCustomKeyboard;  //English Keyboard 对应的是PMCustom.xib

@property (weak, nonatomic) IBOutlet UIButton *shift;
@property (weak, nonatomic) IBOutlet UIButton *q;
@property (weak, nonatomic) IBOutlet UIButton *w;
@property (weak, nonatomic) IBOutlet UIButton *e;
@property (weak, nonatomic) IBOutlet UIButton *r;
@property (weak, nonatomic) IBOutlet UIButton *t;
@property (weak, nonatomic) IBOutlet UIButton *y;
@property (weak, nonatomic) IBOutlet UIButton *u;
@property (weak, nonatomic) IBOutlet UIButton *i;
@property (weak, nonatomic) IBOutlet UIButton *o;
@property (weak, nonatomic) IBOutlet UIButton *p;
@property (weak, nonatomic) IBOutlet UIButton *a;
@property (weak, nonatomic) IBOutlet UIButton *s;
@property (weak, nonatomic) IBOutlet UIButton *d;
@property (weak, nonatomic) IBOutlet UIButton *f;
@property (weak, nonatomic) IBOutlet UIButton *g;
@property (weak, nonatomic) IBOutlet UIButton *h;
@property (weak, nonatomic) IBOutlet UIButton *j;
@property (weak, nonatomic) IBOutlet UIButton *k;
@property (weak, nonatomic) IBOutlet UIButton *l;

@property (weak, nonatomic) IBOutlet UIButton *z;
@property (weak, nonatomic) IBOutlet UIButton *x;
@property (weak, nonatomic) IBOutlet UIButton *c;
@property (weak, nonatomic) IBOutlet UIButton *v;
@property (weak, nonatomic) IBOutlet UIButton *b;
@property (weak, nonatomic) IBOutlet UIButton *n;
@property (weak, nonatomic) IBOutlet UIButton *m;


@end
