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

#import "ViewController.h"
#include "ffmpeg.h"

int ffmpegmain(int argc, char **argv);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickRunButton:(id)sender {
    char command_str_full[1024]={0};
    

    NSString *command_str= [NSString stringWithFormat:@"%@",self.command.text];
    NSArray *argv_array=[command_str componentsSeparatedByString:(@" ")];
    int argc=argv_array.count;
    char** argv=(char**)malloc(sizeof(char*)*argc);
    for(int i=0;i<argc;i++)
    {
        argv[i]=(char*)malloc(sizeof(char)*1024);
        strcpy(argv[i],[[argv_array objectAtIndex:i] UTF8String]);
    }
    
    ffmpegmain(argc, argv);
    
    for(int i=0;i<argc;i++)
        free(argv[i]);
    free(argv);
  }
@end
