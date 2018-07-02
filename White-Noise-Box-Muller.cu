//
// Created by heidies on 7/2/18.
//

#include <cuda_runtime.h>
#include <iostream>
#include <cmath>
#include <opencv2/opencv.hpp>
#include <cstring>

using namespace std;
using namespace cv;

#define pi 3.1415926
#define CHECK(call){                                                                                                      \
    const cudaError_t error = call;                                                                                         \
    if (error != cudaSuccess){                                                                                             \
        cout << "Error: " << __FILE__ << ":" << __LINE__ << endl;                                                           \
        cout << "code: " << error << "reason: " << cudaGetErrorString(error) << endl;                                          \
        exit(-10 * error);                                                                                                \
    }                                                                                                                    \
}

// Generate a uniform random list
void initialRandomNum(float *ip, int size){
    time_t t;
    srand((unsigned) time(&t));

    for (int i = 0; i < size ; ++ i){
        ip[i] = rand() / RAND_MAX;
    }
}

// Add white noise N(0, sigma) to origin image
// Box-Muller transform
__global__ void addWhiteNoise(float *Img, float *randList, const int imgWidth, const int imgHeight, const float sigma){
    int ix = threadIdx.x + blockIdx.x * blockDim.x;
    int iy = threadIdx.y + blockIdx.y * blockDim.y;

    int z0_idx = iy * 2 * imgWidth + ix;
    int z1_idx = iy * (2 * imgWidth + 1) + ix;
    if(z0_idx < imgHeight) {
        Img[z0_idx] += sigma * cos(2 * pi * randList[z0_idx]) * sqrt(-2 * log * randList[z1_idx]);
        Img[z0_idx] = Img[z0_idx] < 0? 0.0 : Img[z0_idx] > 255.0? 255.0, Img[z0_idx];
    }
    if(z1_idx < imgHeight) {
        Img[z1_idx] += sigma * sin(2 * pi * randList[z0_idx]) * sqrt(-2 * log * randList[z1_idx]);
        Img[z1_idx] = Img[z1_idx] < 0? 0.0 : Img[z0_idx] > 255.0? 255.0, Img[z1_idx];
    }
}

// test
int main(int argc, char **argv){
    string filePath = "00001.jpg";
    Mat Img = (float)imread(filePath, CV_LOAD_IMAGE_GRAYSCALE);
    dim3 block(32, 32);
    dim3 grid((Img.cols + block.x - 1) / block.x, (Img.rows / 2 + block.y - 1) / block.y);
    float
    return 0;
}


