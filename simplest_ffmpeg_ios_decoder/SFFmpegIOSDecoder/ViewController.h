/**
 * 最简单的基于FFmpeg的视频解码器-IOS
 * Simplest FFmpeg IOS Decoder
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本程序是IOS平台下最简单的基于FFmpeg的视频解码器。
 * 它可以将输入的视频数据解码成YUV像素数据。
 *
 * This software is the simplest decoder based on FFmpeg in IOS.
 * It can decode video stream to raw YUV data.
 *
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *infomation;
@property (weak, nonatomic) IBOutlet UITextField *inputurl;
@property (weak, nonatomic) IBOutlet UITextField *outputurl;

- (IBAction)clickDecodeButton:(id)sender;


@end

