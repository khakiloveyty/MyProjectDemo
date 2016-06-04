//
//  JPAddTagViewController.m
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPAddTagViewController.h"
#import "JPTagButton.h"
#import "JPTagTextField.h"

@interface JPAddTagViewController () <UITextFieldDelegate>
/** 内容视图 */
@property(nonatomic,weak)UIView *contentView;
/** 标签编辑框 */
@property(nonatomic,weak)JPTagTextField *textField;
/** 添加按钮 */
@property(nonatomic,weak)UIButton *addBtn;
/** 所有标签按钮 */
@property(nonatomic,strong)NSMutableArray *tagBtns;
/** textField默认宽度 */
@property(nonatomic,assign)CGFloat textFieldDefaultWidth;
@end

@implementation JPAddTagViewController

-(NSMutableArray *)tagBtns{
    if (!_tagBtns) {
        _tagBtns=[NSMutableArray array];
    }
    return _tagBtns;
}

-(UIView *)contentView{
    if (!_contentView) {
        UIView *contentView=[[UIView alloc] init];
        [self.view addSubview:contentView];
        self.contentView=contentView;
    }
    return _contentView;
}

-(JPTagTextField *)textField{
    if (!_textField) {
        JPTagTextField *textField=[[JPTagTextField alloc] init];
        textField.delegate=self;
        
        //设置删除的回调
        __weak typeof(self) weakSelf=self; //避免循环引用
        textField.deleteBlock=^{
            if (weakSelf.tagBtns.count && !weakSelf.textField.hasText) {
                [weakSelf deleteTag:[weakSelf.tagBtns lastObject]];
            }
        };
        
        [self.contentView addSubview:textField];
        self.textField=textField;
        
        //监听文字编辑
        [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        
        //设置默认宽度为占位文字的宽度（sizeWithAttributes：计算只有一行时的高度）
        self.textFieldDefaultWidth=[self.textField.placeholder sizeWithAttributes:@{NSFontAttributeName:self.textField.font}].width;
    }
    return _textField;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.width=self.contentView.width;
        addBtn.height=35;
        
        //设置按钮内容（文本、图片）的布局
        addBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        
        addBtn.contentEdgeInsets=UIEdgeInsetsMake(0, JPAddTagViewMargin, 0, JPAddTagViewMargin);
        
        addBtn.titleLabel.font=self.textField.font;
        addBtn.backgroundColor=JPRGB(74, 139, 209);
        
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //监听按钮：添加标签
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        addBtn.hidden=YES;
        
        [self.contentView addSubview:addBtn];
        _addBtn=addBtn;
    }
    return _addBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

#pragma mark - 基本配置

-(void)setupBasic{
    self.title=@"添加标签";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

-(void)done{
    
//    NSMutableArray *tags=[NSMutableArray array];
//    for (JPTagButton *tagBtn in self.tagBtns) {
//        [tags addObject:tagBtn.currentTitle];
//    }
    
    //使用KVC将self.tagBtns里面所有的currentTitle属性放到一个数组中
    NSArray *tags=[self.tagBtns valueForKeyPath:@"currentTitle"];
    
    //在这个时候再调用block
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听textField的文字编辑

//文字编辑的响应
-(void)textDidChange{
    
    if (self.textField.hasText) {       //有文字
        
        //显示添加标签的按钮
        self.addBtn.hidden=NO;
        
        [self.addBtn setTitle:[NSString stringWithFormat:@"添加标签：%@",self.textField.text] forState:UIControlStateNormal];
        
        //实时刷新textField的位置
        [self updateTextFieldFrame];
        
        //获取最后一个字符
        NSString *lastString=[self.textField.text substringFromIndex:self.textField.text.length-1];
        
        if ([lastString isEqualToString:@"，"] || [lastString isEqualToString:@"。"] || [lastString isEqualToString:@","] || [lastString isEqualToString:@"."]) {
            
            //如果是逗号或句号则去掉
            self.textField.text=[self.textField.text substringToIndex:self.textField.text.length-1];
            
            //直接添加标签
            [self addBtnClick];
            
            //如果去掉符号后没有文字则隐藏添加标签按钮
            self.addBtn.hidden=(!self.textField.hasText);
            
        }
        
    }else{                              //没有文字
        self.addBtn.hidden=YES;
    }
    
}

#pragma mark - 布局子控件 （防止在viewDidLoad方法中获取不了self.view的宽度或获取的是xib文件中的宽度）
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //使用了懒加载模式，直接调用同时创建好
    self.contentView.x=JPAddTagViewMargin;
    self.contentView.y=64+JPAddTagViewMargin;
    self.contentView.width=self.view.width-2*JPAddTagViewMargin;
    self.contentView.height=self.view.height-64-2*JPAddTagViewMargin;
    
    self.textField.width=self.contentView.width;
    
    //初始化标签
    [self setupTags];
}

#pragma mark - 初始化标签

-(void)setupTags{
    if (self.tags.count) {
        for (NSString *tag in self.tags) {
//            self.textField.text=tag;
//            [self addBtnClick]; //我在这个方法里使用了动画布局，在初始化标签没必要使用动画
            [self createTagBtnWithTag:tag];
        }
        [self updateTagBtnFrame];
        [self updateTextFieldFrame];
        
        self.tags=nil; //清空数组，防止重复执行（viewDidLayoutSubviews会多次调用）
    }
}

#pragma mark - 标签按钮的添加、删除

//添加标签
-(void)addBtnClick{
    if (self.tagBtns.count==5) {
        [SVProgressHUD showErrorWithStatus:@"最多只能添加5个标签"];
        return;
    }
    
    [self createTagBtnWithTag:self.textField.text];
    
    //刷新按钮位置
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagBtnFrame];
        [self updateTextFieldFrame];
    }];
    
    //添加完就清空textField文字
    self.textField.text=nil;
    self.addBtn.hidden=YES; //通过代码清空textField文字是不会触发textDidChange方法，需要这里手动隐藏
}

//创建标签按钮
-(void)createTagBtnWithTag:(NSString *)tag{
    JPTagButton *tagBtn=[JPTagButton buttonWithType:UIButtonTypeCustom];
    
    [tagBtn setTitle:tag forState:UIControlStateNormal];
//    [tagBtn sizeToFit]; //重写了setTitle:forState:方法，内部调用sizeToFit，每当设置title时就会自适应size
    tagBtn.height=self.textField.height;
    
    tagBtn.x=self.textField.x;
    tagBtn.y=self.textField.y;
    
    //监听按钮：添加标签
    [tagBtn addTarget:self action:@selector(deleteTag:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:tagBtn];
    [self.tagBtns addObject:tagBtn];
}

//删除标签
-(void)deleteTag:(JPTagButton *)tagBtn{
    [self.tagBtns removeObject:tagBtn];
    [tagBtn removeFromSuperview];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagBtnFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 刷新标签按钮的frame

-(void)updateTagBtnFrame{
    
    for (int i=0;i<self.tagBtns.count;i++) {
        JPTagButton *tagBtn=self.tagBtns[i];
        if (i==0) {
            tagBtn.x=0;
            tagBtn.y=0;
        }else{
            //取出上一个标签按钮
            UIButton *lastTagBtn=self.tagBtns[i-1];
            //根据上个标签按钮获取这个按钮的x值
            CGFloat x=CGRectGetMaxX(lastTagBtn.frame)+JPAddTagViewMargin;
            
            if ((x+tagBtn.width)<=self.contentView.width) {
                //如果加上按钮宽度比contentView的宽度小，则证明不会超出这一行，让按钮紧跟在上一个标签按钮后面
                tagBtn.x=x;
                tagBtn.y=lastTagBtn.y;
            }else{
                //否则就排在下一行
                tagBtn.x=0;
                tagBtn.y=CGRectGetMaxY(lastTagBtn.frame)+JPAddTagViewMargin;
            }
        }
    }
    
}

#pragma mark - 刷新添加标签按钮和textField的frame

-(void)updateTextFieldFrame{
    //根据最后一个按钮调整textField的位置
    JPTagButton *lastTagBtn=[self.tagBtns lastObject];
    
    CGFloat textFieldX=0;
    CGFloat textFieldY=0;
    
    if (lastTagBtn) {   //如果有标签
        
        //根据上一个标签获取textField的x值
        textFieldX=CGRectGetMaxX(lastTagBtn.frame)+JPAddTagViewMargin;
        
        //获取textField的文字宽度（至少为占位文字的宽度）
        CGFloat textFieldWidth=[self textFieldWidth];
        
        if ((textFieldX+textFieldWidth)<=self.contentView.width) {
            
            //如果不超过contentView的宽度，则证明不超过这一行，就让textField留在这一行
            textFieldY=lastTagBtn.y;
            
        }else{
            
            //否则放到下一行
            textFieldX=0;
            textFieldY=CGRectGetMaxY(lastTagBtn.frame)+JPAddTagViewMargin;
            
        }
        
    }
    
    self.textField.x=textFieldX;
    self.textField.y=textFieldY;
    
    self.addBtn.y=CGRectGetMaxY(self.textField.frame)+JPAddTagViewMargin;
}

#pragma mark - 获取textField的文字宽度（至少为占位文字的宽度）

//获取textField的文字宽度：根据文字所得宽度，至少为占位文字的宽度
-(CGFloat)textFieldWidth{
    CGFloat textWidth=[self.textField.text sizeWithAttributes:@{NSFontAttributeName:self.textField.font}].width;
    return MAX(self.textFieldDefaultWidth, textWidth);
}

#pragma mark - UITextFieldDelegate

//监听键盘最右下角的按钮点击
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.textField.hasText) {
        [self addBtnClick];
    }
    
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
