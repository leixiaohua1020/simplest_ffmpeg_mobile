/**
 * 移植SDL到安卓平台的HelloWorld程序
 * Simplest SDL Android Helloworld
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 *
 * 本程序是移植SDL到安卓平台的最简单程序。它可以读取并显示一张BMP图片。
 *
 * This software is the simplest program transplant SDL2 to Android platform.
 * It shows a BMP file on the screen.
 */

#ifdef __ANDROID__

#include <jni.h>
#include <android/log.h>
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO , "(^_^)", __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR , "(^_^)", __VA_ARGS__)
#else
#define LOGE(format, ...)  printf("(>_<) " format "\n", ##__VA_ARGS__)
#define LOGI(format, ...)  printf("(^_^) " format "\n", ##__VA_ARGS__)
#endif

#include "SDL.h"
#include "SDL_log.h"
#include "SDL_main.h"

int main(int argc, char *argv[]) {
	struct SDL_Window *window = NULL;
	struct SDL_Renderer *render = NULL;
	struct SDL_Surface *bmp = NULL;
	struct SDL_Texture *texture = NULL;

    char *filepath = "/storage/emulated/0/test.bmp";

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO | SDL_INIT_TIMER) == -1) {
        LOGE("SDL_Init failed %s", SDL_GetError());
    }

    window = SDL_CreateWindow("SDL HelloWorld!", 100, 100, 640, 480,
            SDL_WINDOW_SHOWN);
    if (window == NULL) {
        LOGE("SDL_CreateWindow failed  %s", SDL_GetError());
    }

    render = SDL_CreateRenderer(window, -1,
            SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (render == NULL) {
        LOGE("SDL_CreateRenderer failed  %s", SDL_GetError());
    }

    bmp = SDL_LoadBMP(filepath);
    if (bmp == NULL) {
        LOGE("SDL_LoadBMP failed: %s", SDL_GetError());
    }

    texture = SDL_CreateTextureFromSurface(render, bmp);
    SDL_FreeSurface(bmp);

    SDL_RenderClear(render);
    SDL_RenderCopy(render, texture, NULL, NULL);
    SDL_RenderPresent(render);

    SDL_Delay(10000);

    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(render);
    SDL_DestroyWindow(window);

    //Quit SDL
    SDL_Quit();
    return 0;
}
