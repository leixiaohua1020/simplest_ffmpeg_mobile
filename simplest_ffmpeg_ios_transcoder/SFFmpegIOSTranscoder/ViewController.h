/**
 * 最简单的基于FFmpeg的转码器-IOS
 * Simplest FFmpeg IOS Transcoder
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 马小雨 Ma Xiaoyu
 * maxiaoyucuc@163.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本程序是IOS平台下的转码器。它移植于ffmpeg.c命令行工具。
 *
 * This software is a Transcoder in IOS. It is transplanted from ffmpeg.c
 * command line tools.
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UITextField *command;
@property (weak, nonatomic) IBOutlet UITextView *command;
@property (weak, nonatomic) IBOutlet UILabel *infomation;
- (IBAction)clickRunButton:(id)sender;

@end

