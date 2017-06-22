//
//  WMXPickerTF.m
//  textFieldTest
//
//  Created by pipiwu on 15/4/24.
//  Copyright (c) 2015年 pipiwu. All rights reserved.
//

#import "WMXPickerTF.h"

@interface WMXPickerTF ()

@property (nonatomic, strong) NSMutableArray *normalUnSelectArr;  // 小写没选中的情况下
@property (nonatomic, strong) NSMutableArray *normalSelectArr;    // 小写选中的情况下
@property (nonatomic, strong) NSMutableArray *hightUnSelectArr;   // 大写没选中的情况下
@property (nonatomic, strong) NSMutableArray *hightSelectArr;     // 大写选中的情况下
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end


@implementation WMXPickerTF
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.inputView = [self createInputView];
        _isSelected = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        self.inputView = [self createInputView];
        _isSelected = NO;
    }
    return self;
}

#pragma mark - lazyLoad
- (NSMutableArray *)normalUnSelectArr {
    if (!_normalUnSelectArr) {
        NSArray *array = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
        self.normalUnSelectArr = [NSMutableArray arrayWithArray:array];
    }
    return _normalUnSelectArr;
}

- (NSMutableArray *)normalSelectArr {
    if (!_normalSelectArr) {
        NSArray *array = [NSArray arrayWithObjects:@"aaa",@"bbb",@"ccc",@"ddd",@"eee",@"fff",@"ggg",@"hhh",@"iii",@"jjj",@"kkk",@"lll",@"mmm",@"nnn",@"ooo",@"ppp",@"qqq",@"rrr",@"sss",@"ttt",@"uuu",@"vvv",@"www",@"xxx",@"yyy",@"zzz",nil];
        self.normalSelectArr = [NSMutableArray arrayWithArray:array];
    }
    return _normalSelectArr;
}

- (NSMutableArray *)hightUnSelectArr {
    if (!_hightUnSelectArr) {
        NSArray *array = [NSArray arrayWithObjects:@"AA",@"BB",@"CC",@"DD",@"EE",@"FF",@"GG",@"HH",@"II",@"JJ",@"KK",@"LL",@"MM",@"NN",@"OO",@"PP",@"QQ",@"RR",@"SS",@"TT",@"UU",@"VV",@"WW",@"XX",@"YY",@"ZZ",nil];
        self.hightUnSelectArr = [NSMutableArray arrayWithArray:array];
    }
    return _hightUnSelectArr;
}

- (NSMutableArray *)hightSelectArr {
    if (!_hightSelectArr) {
        NSArray *array = [NSArray arrayWithObjects:@"AAAA",@"BBBB",@"CCCC",@"DDDD",@"EEEE",@"FFFF",@"GGGG",@"HHHH",@"IIII",@"JJJJ",@"KKKK",@"LLLL",@"MMMM",@"NNNN",@"OOOO",@"PPPP",@"QQQQ",@"RRRR",@"SSSS",@"TTTT",@"UUUU",@"VVVV",@"WWWW",@"XXXX",@"YYYY",@"ZZZZ",nil];
        self.hightSelectArr = [NSMutableArray arrayWithArray:array];
    }
    return _hightSelectArr;
}

- (NSMutableArray *)buttonArr {
    if (!_buttonArr) {
        NSArray *array = [NSArray arrayWithObjects:_a,_b,_c,_d,_e,_f,_g,_h,_i,_j,_k,_l,_m,_n,_o,_p,_q,_r,_s,_t,_u,_v,_w,_x,_y,_z,nil];
        self.buttonArr = [NSMutableArray arrayWithArray:array];
    }
    return _buttonArr;
}

#pragma mark - 数字键盘
- (IBAction)number0Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"0"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number1Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"1"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number2Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"2"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number3Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"3"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number4Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"4"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number5Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"5"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number6Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"6"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number7Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"7"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number8Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"8"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number601Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"601"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }

}

- (IBAction)number9Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"9"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number600Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"600"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number002Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"002"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number300Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"300"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)number000Action:(id)sender {
    self.text = [self.text stringByAppendingString:@"000"];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

//数字键盘--ABC按钮
- (IBAction)EnglishKeyBoard:(id)sender {
    self.inputView = [self createInputView2];
    [self resignFirstResponder];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
    [_calculateView removeFromSuperview];
    _isSelected = NO;
}

//数字键盘--清空
- (IBAction)numberYCAction:(id)sender {
    self.text = @"";
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

//数字键盘--隐藏和确定
- (IBAction)queding:(id)sender {
    
    [self resignFirstResponder];
    [_calculateView removeFromSuperview];
    self.text  = @"";
    
}
//数字键盘--删除
- (IBAction)delete:(id)sender {
    if (self.text.length <= 0) {
        return;
    } else {
        self.text = [self.text substringToIndex:self.text.length - 1];
        if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
            [_pickerDelegate somethingChanged:self];
        }
    }
}


#pragma mark - 字母键盘

//字母键盘 -- 删除
- (IBAction)delete2:(id)sender {
    if (self.text.length <= 0) {
        return;
    } else {
        self.text = [self.text substringToIndex:self.text.length - 1];
        if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
            [_pickerDelegate somethingChanged:self];
        }
    }
}

//字母键盘 -- 123
- (IBAction)toNumber:(id)sender {
    self.inputView = [self createInputView];
    [self resignFirstResponder];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
    [_PMCustomKeyboard removeFromSuperview];
    self.buttonArr = nil;
    self.hightUnSelectArr = nil;
    self.hightSelectArr = nil;
    self.normalUnSelectArr = nil;
    self.normalSelectArr = nil;
}

//字母键盘 -- space
- (IBAction)space:(id)sender {
    self.text = [self.text stringByAppendingString:@" "];
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

//字母键盘 -- 确定
- (IBAction)complite:(id)sender {
    [self resignFirstResponder];
    [_PMCustomKeyboard removeFromSuperview];
    self.text  = @"";
}

//字母键盘 -- shift
- (IBAction)shift:(id)sender {
    _isSelected = !_isSelected;
    [self changCharacterBackgroundImage];
    [self changBackImageOfShift];
}

- (void)changCharacterBackgroundImage {
    for (int i = 0; i < 26; i++) {
        if (_isSelected) {
            [self.buttonArr[i] setBackgroundImage:[UIImage imageNamed:self.hightUnSelectArr[i]] forState:UIControlStateNormal];
            [self.buttonArr[i] setBackgroundImage:[UIImage imageNamed:self.hightSelectArr[i]] forState:UIControlStateHighlighted];
        } else {
            [self.buttonArr[i] setBackgroundImage:[UIImage imageNamed:self.normalUnSelectArr[i]] forState:UIControlStateNormal];
            [self.buttonArr[i] setBackgroundImage:[UIImage imageNamed:self.normalSelectArr[i]] forState:UIControlStateHighlighted];
        }
    }
}

- (void)changBackImageOfShift {
    if (_isSelected) {
        [self.shift setBackgroundImage:[UIImage imageNamed:@"normal1.png"] forState:UIControlStateNormal];
    } else {
        [self.shift setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    }
}

- (void)changValueOnDisplay:(NSString *)smallValue andBigValue:(NSString *)bigValue {
    if (_isSelected) {
        self.text = [self.text stringByAppendingString:bigValue];
    } else {
        self.text = [self.text stringByAppendingString:smallValue];
    }
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

- (IBAction)q:(id)sender {
    [self changValueOnDisplay:@"q" andBigValue:@"Q"];
}
- (IBAction)w:(id)sender {
    [self changValueOnDisplay:@"w" andBigValue:@"W"];
}
- (IBAction)e:(id)sender {
    [self changValueOnDisplay:@"e" andBigValue:@"E"];
}
- (IBAction)r:(id)sender {
    [self changValueOnDisplay:@"r" andBigValue:@"R"];
}
- (IBAction)t:(id)sender {
    [self changValueOnDisplay:@"t" andBigValue:@"T"];
}
- (IBAction)y:(id)sender {
    [self changValueOnDisplay:@"y" andBigValue:@"Y"];
}
- (IBAction)u:(id)sender {
    [self changValueOnDisplay:@"u" andBigValue:@"U"];
}
- (IBAction)i:(id)sender {
    [self changValueOnDisplay:@"i" andBigValue:@"I"];
}
- (IBAction)o:(id)sender {
    [self changValueOnDisplay:@"o" andBigValue:@"O"];
}
- (IBAction)p:(id)sender {
    [self changValueOnDisplay:@"p" andBigValue:@"P"];
}
- (IBAction)a:(id)sender {
    [self changValueOnDisplay:@"a" andBigValue:@"A"];
}
- (IBAction)s:(id)sender {
    [self changValueOnDisplay:@"s" andBigValue:@"S"];
}
- (IBAction)d:(id)sender {
    [self changValueOnDisplay:@"d" andBigValue:@"D"];
}
- (IBAction)f:(id)sender {
    [self changValueOnDisplay:@"f" andBigValue:@"F"];
}
- (IBAction)g:(id)sender {
    [self changValueOnDisplay:@"g" andBigValue:@"G"];
}
- (IBAction)h:(id)sender {
    [self changValueOnDisplay:@"h" andBigValue:@"H"];
}
- (IBAction)j:(id)sender {
    [self changValueOnDisplay:@"j" andBigValue:@"J"];
}
- (IBAction)k:(id)sender {
    [self changValueOnDisplay:@"k" andBigValue:@"K"];
}
- (IBAction)l:(id)sender {
    [self changValueOnDisplay:@"l" andBigValue:@"L"];
}
- (IBAction)z:(id)sender {
    [self changValueOnDisplay:@"z" andBigValue:@"Z"];
}
- (IBAction)x:(id)sender {
    [self changValueOnDisplay:@"x" andBigValue:@"X"];
}
- (IBAction)c:(id)sender {
    [self changValueOnDisplay:@"c" andBigValue:@"C"];
}
- (IBAction)v:(id)sender {
    [self changValueOnDisplay:@"v" andBigValue:@"V"];
}
- (IBAction)b:(id)sender {
    [self changValueOnDisplay:@"b" andBigValue:@"B"];
}
- (IBAction)n:(id)sender {
    [self changValueOnDisplay:@"n" andBigValue:@"N"];
}
- (IBAction)m:(id)sender {
    [self changValueOnDisplay:@"m" andBigValue:@"M"];
}

#pragma mark - Action
- (UIView *)createInputView {
    if(!_calculateView) {
        [[NSBundle  mainBundle]  loadNibNamed:@"calculate" owner:self options:nil];
    }
    //下面这句代码是判断输入框变化时要调用的方法
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return  _calculateView;
}

- (UIView *)createInputView2 {
    if (!_PMCustomKeyboard) {
        [[NSBundle  mainBundle]  loadNibNamed:@"PMCustom" owner:self options:nil];
    }
    //下面这句代码是判断输入框变化时要调用的方法
    [self addTarget:self action:@selector(textFieldDidChange2:) forControlEvents:UIControlEventEditingChanged];
    return  _PMCustomKeyboard;
}

// 数字监听输入框变化时调用
- (void)textFieldDidChange:(id)sender {
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}

// 字母监听输入框变化时调用
- (void)textFieldDidChange2:(id)sender {
    if ([self.pickerDelegate respondsToSelector:@selector(somethingChanged:)]) {
        [_pickerDelegate somethingChanged:self];
    }
}
@end
