/**
 * 最简单的基于FFmpeg的Helloworld例子-安卓
 * Simplest FFmpeg Android Helloworld
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 *
 * 本程序是移植FFmpeg到安卓平台的最简单程序。它可以打印出FFmpeg类库的下列信息：
 * Protocol:  FFmpeg类库支持的协议
 * AVFormat:  FFmpeg类库支持的封装格式
 * AVCodec:   FFmpeg类库支持的编解码器
 * AVFilter:  FFmpeg类库支持的滤镜
 * Configure: FFmpeg类库的配置信息
 *
 * This is the simplest program based on FFmpeg in Android. It can show following
 * informations about FFmpeg library:
 * Protocol:  Protocols supported by FFmpeg.
 * AVFormat:  Container format supported by FFmpeg.
 * AVCodec:   Encoder/Decoder supported by FFmpeg.
 * AVFilter:  Filters supported by FFmpeg.
 * Configure: configure information of FFmpeg.
 */

#include <stdio.h>
 
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libavfilter/avfilter.h"

//Log
#ifdef ANDROID
#include <jni.h>
#include <android/log.h>
#define LOGE(format, ...)  __android_log_print(ANDROID_LOG_ERROR, "(>_<)", format, ##__VA_ARGS__)
#else
#define LOGE(format, ...)  printf("(>_<) " format "\n", ##__VA_ARGS__)
#endif


//FIX
struct URLProtocol;
/**
 * com.leixiaohua1020.sffmpegandroidhelloworld.MainActivity.urlprotocolinfo()
 * Protocol Support Information
 */
JNIEXPORT jstring Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_urlprotocolinfo(JNIEnv *env, jobject obj){
	
	char info[40000]={0};
	av_register_all();

	struct URLProtocol *pup = NULL;
	//Input
	struct URLProtocol **p_temp = &pup;
	avio_enum_protocols((void **)p_temp, 0);
	while ((*p_temp) != NULL){
		sprintf(info, "%s[In ][%10s]\n", info, avio_enum_protocols((void **)p_temp, 0));
	}
	pup = NULL;
	//Output
	avio_enum_protocols((void **)p_temp, 1);
	while ((*p_temp) != NULL){
		sprintf(info, "%s[Out][%10s]\n", info, avio_enum_protocols((void **)p_temp, 1));
	}

	//LOGE("%s", info);
	return (*env)->NewStringUTF(env, info);
}

/**
 * com.leixiaohua1020.sffmpegandroidhelloworld.MainActivity.avformatinfo()
 * AVFormat Support Information
 */
JNIEXPORT jstring Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_avformatinfo(JNIEnv *env, jobject obj){

	char info[40000] = { 0 };

	av_register_all();

	AVInputFormat *if_temp = av_iformat_next(NULL);
	AVOutputFormat *of_temp = av_oformat_next(NULL);
	//Input
	while(if_temp!=NULL){
		sprintf(info, "%s[In ][%10s]\n", info, if_temp->name);
		if_temp=if_temp->next;
	}
	//Output
	while (of_temp != NULL){
		sprintf(info, "%s[Out][%10s]\n", info, of_temp->name);
		of_temp = of_temp->next;
	}
	//LOGE("%s", info);
	return (*env)->NewStringUTF(env, info);
}

/**
 * com.leixiaohua1020.sffmpegandroidhelloworld.MainActivity.avcodecinfo()
 * AVCodec Support Information
 */
JNIEXPORT jstring Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_avcodecinfo(JNIEnv *env, jobject obj)
{
	char info[40000] = { 0 };

	av_register_all();

	AVCodec *c_temp = av_codec_next(NULL);

	while(c_temp!=NULL){
		if (c_temp->decode!=NULL){
			sprintf(info, "%s[Dec]", info);
		}
		else{
			sprintf(info, "%s[Enc]", info);
		}
		switch (c_temp->type){
		case AVMEDIA_TYPE_VIDEO:
			sprintf(info, "%s[Video]", info);
			break;
		case AVMEDIA_TYPE_AUDIO:
			sprintf(info, "%s[Audio]", info);
			break;
		default:
			sprintf(info, "%s[Other]", info);
			break;
		}
		sprintf(info, "%s[%10s]\n", info, c_temp->name);

		
		c_temp=c_temp->next;
	}
	//LOGE("%s", info);

	return (*env)->NewStringUTF(env, info);
}

/**
 * com.leixiaohua1020.sffmpegandroidhelloworld.MainActivity.avfilterinfo()
 * AVFilter Support Information
 */
JNIEXPORT jstring Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_avfilterinfo(JNIEnv *env, jobject obj)
{
	char info[40000] = { 0 };
	avfilter_register_all();
	AVFilter *f_temp = (AVFilter *)avfilter_next(NULL);
	while (f_temp != NULL){
		sprintf(info, "%s[%10s]\n", info, f_temp->name);
	}
	//LOGE("%s", info);

	return (*env)->NewStringUTF(env, info);
}

/**
 * com.leixiaohua1020.sffmpegandroidhelloworld.MainActivity.urlprotocolinfo()
 * Protocol Support Information
 */
JNIEXPORT jstring Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_configurationinfo(JNIEnv *env, jobject obj)
{
	char info[10000] = { 0 };
	av_register_all();

	sprintf(info, "%s\n", avcodec_configuration());

	//LOGE("%s", info);
	return (*env)->NewStringUTF(env, info);
}

/*
//Test
int main(int argc, char* argv[])
{
	Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_urlprotocolinfo();
	Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_avformatinfo();
	Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_avcodecinfo();
	Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_avfilterinfo();
	Java_com_leixiaohua1020_sffmpegandroidhelloworld_MainActivity_configurationinfo();
	return 0;
}
*/
