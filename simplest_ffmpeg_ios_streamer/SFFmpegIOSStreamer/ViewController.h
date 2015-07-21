/**
 * 最简单的基于FFmpeg的推流器-IOS
 * Simplest FFmpeg IOS Streamer
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本程序是IOS平台下的推流器。它可以将本地文件以流媒体的形式推送出去。
 *
 * This software is the simplest streamer in IOS.
 * It can stream local media files to streaming media server.
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UITextView *output;
- (IBAction)clickStreamButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *information;

@end

