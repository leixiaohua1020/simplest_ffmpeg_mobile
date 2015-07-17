/**
 * 最简单的基于FFmpeg的转码器-安卓
 * Simplest FFmpeg Android Transcoder
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本程序是安卓平台下的转码器。它移植于ffmpeg.c命令行工具。
 *
 * This software is a Transcoder in Android. It is transplanted from ffmpeg.c
 * command line tools.
 */
#include <string.h>
#include <jni.h>
#include <ffmpeg.h>

#ifdef ANDROID
#include <jni.h>
#include <android/log.h>
#define LOGE(format, ...)  __android_log_print(ANDROID_LOG_ERROR, "(>_<)", format, ##__VA_ARGS__)
#define LOGI(format, ...)  __android_log_print(ANDROID_LOG_INFO,  "(=_=)", format, ##__VA_ARGS__)
#else
#define LOGE(format, ...)  LOGE("(>_<) " format "\n", ##__VA_ARGS__)
#define LOGI(format, ...)  LOGE("(^_^) " format "\n", ##__VA_ARGS__)
#endif


int ffmpegmain(int argc, char **argv);

//Output FFmpeg's av_log()
void custom_log(void *ptr, int level, const char* fmt, va_list vl){

	//To TXT file

	FILE *fp=fopen("/storage/emulated/0/av_log.txt","a+");
	if(fp){
		vfprintf(fp,fmt,vl);
		fflush(fp);
		fclose(fp);
	}


	//To Logcat
	//LOGE(fmt, vl);
}

JNIEXPORT jint JNICALL Java_com_leixiaohua1020_sffmpegandroidtranscoder_MainActivity_ffmpegcore( JNIEnv * env, jobject thiz, jint cmdnum, jobjectArray cmdline)
{

  //FFmpeg av_log() callback
  av_log_set_callback(custom_log);

  int argc=cmdnum;
  char** argv=(char**)malloc(sizeof(char*)*argc);
  
  int i=0;
  for(i=0;i<argc;i++)
  {
    jstring string=(*env)->GetObjectArrayElement(env,cmdline,i);
    const char* tmp=(*env)->GetStringUTFChars(env,string,0);
    argv[i]=(char*)malloc(sizeof(char)*1024);
    strcpy(argv[i],tmp);
  }
  
  ffmpegmain(argc,argv);

  for(i=0;i<argc;i++){
    free(argv[i]);
  }
  free(argv);
  return 0;

}
