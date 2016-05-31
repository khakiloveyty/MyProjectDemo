#import <UIKit/UIKit.h>

//帖子类型枚举
typedef enum{
    JPAllTopic=1,          //全部
    JPVideoTopic=41,       //视频
    JPVoiceTopic=31,       //声音
    JPPictureTopic=10,     //图片
    JPWordTopic=29         //段子
} JPTopicType;


/** 用户头像的占位图片 */
UIKIT_EXTERN NSString *const JPDefaultUserIcon;

/** 精华-顶部标签栏的高度 */
UIKIT_EXTERN CGFloat const JPTitlesViewHeight;

/** 精华-顶部标签栏的Y值 */
UIKIT_EXTERN CGFloat const JPTitlesViewY;

/** 帖子cell的各控件之间的边距 */
UIKIT_EXTERN CGFloat const JPTopicCellMargin;

/** 精华-帖子cell的文字label的Y值 */
UIKIT_EXTERN CGFloat const JPTopicCellTextY;

/** 精华-帖子cell的底部工具条的高度 */
UIKIT_EXTERN CGFloat const JPTopicCellBottomBarHeight;

/** 精华-帖子cell-图片的最大高度 */
UIKIT_EXTERN CGFloat const JPTopicCellPictureMaxHeight;

/** 精华-帖子cell-图片的指定高度（图片超过最大高度时使用） */
UIKIT_EXTERN CGFloat const JPTopicCellPictureOrdinaryHeight;

/** JPUser-性别-男 */
UIKIT_EXTERN NSString *const JPUserSexMan;

/** JPUser-性别-女 */
UIKIT_EXTERN NSString *const JPUserSexWoman;

/** 精华-帖子cell-热门评论标题的高度 */
UIKIT_EXTERN CGFloat const JPTopicCellHotCommentTitleHeight;

/** 精华-帖子cell-热门评论内容内边距 */
UIKIT_EXTERN CGFloat const JPTopicCellHotCommentContentMargin;




#ifdef DEBUG
#define JPLog(...) NSLog(__VA_ARGS__)   //调试阶段 ---> JPLog代替NSLog输出日志
#else
#define JPLog(...)                      //发布阶段 ---> 不输出日志
#endif

#define JPLogFunc JPLog(@"%s",__func__)

#define KeyWindow [UIApplication sharedApplication].keyWindow

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

#define JPRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define JPRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define JPGlobalColor JPRGB(223, 223, 223)
//随机色 arc4random_uniform(256)：0~255的随机数
#define JPRandomColor JPRGB(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

/*
 
 24位bit颜色 R G B
 #ff0000 --> 红
 #00ff00 --> 绿
 #0000ff --> 蓝
 #000000 --> 黑
 #ffffff --> 白
 
 32位bit颜色 A R G B
 #ffff0000 --> 红
 #ff00ff00 --> 绿
 #ff0000ff --> 蓝
 #ff000000 --> 黑
 #ffffffff --> 白
 
 */


#define iPhone4Width 320.0
#define iPhone4Height 480.0

#define iPhone5Width 320.0
#define iPhone5Height 568.0

#define iPhone6Width 375.0
#define iPhone6Height 667.0

#define iPhone6PlusWidth 414.0
#define iPhone6PlusHeight 736.0


