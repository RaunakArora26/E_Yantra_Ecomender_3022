/*
* EcoMender Bot (EB): Task 2B Path Planner
*
* This program computes the valid path from the start point to the end point.
* Make sure you don't change anything outside the "Add your code here" section.
*/

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <limits.h>
#define V 32

#ifdef __linux__ // for host pc

    #include <stdio.h>

    void _put_byte(char c) { putchar(c); }

    void _put_str(char *str) {
        while (*str) {
            _put_byte(*str++);
        }
    }

    void print_output(uint8_t num) {
        if (num == 0) {
            putchar('0'); 
            _put_byte('\n');
            return;
        }

        if (num < 0) {
            putchar('-'); 
            num = -num;   
        }

        char buffer[20]; 
        uint8_t index = 0;

        while (num > 0) {
            buffer[index++] = '0' + num % 10; 
            num /= 10;                        
        }
        while (index > 0) { putchar(buffer[--index]); }
        _put_byte('\n');
    }

    void _put_value(uint8_t val) { print_output(val); }

#else  // for the test device

    void _put_value(uint8_t val) { }
    void _put_str(char *str) { }

#endif

// main function
int main(int argc, char const *argv[]) {

    #ifdef __linux__

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t NODE_POINT          = 0;
        uint8_t CPU_DONE            = 0;

    #else
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)

    #endif

    // Path planning and variable declaration setup
    #ifdef __linux__
        uint32_t graph[32];
        uint8_t i = 0;  
        uint8_t j;
        uint8_t k;
        uint8_t prev[32];
        uint8_t dist[32];
        uint8_t path_planned[32];
        uint8_t idx = 0;

    #else
        uint32_t *graph = (uint32_t *) 0x02000010;
        uint8_t i = ((volatile uint8_t ) 0x02000090);
        uint8_t j = ((volatile uint8_t) 0x02000091);
        uint8_t k = ((volatile uint8_t) 0x02000092);
        uint8_t *prev = ( uint8_t *) 0x020000b1;
        uint8_t *dist = ( uint8_t *) 0x020000D0;
        uint8_t *path_planned = ( uint8_t *) 0x020000ef;
        uint8_t idx = (volatile uint8_t) 0x0200010e;
    #endif

    // Graph adjacency matrix
    graph[0]=1090; graph[1]=2053; graph[2]=58; graph[3]=4; graph[4]=4;
    graph[5]=4; graph[6]=897; graph[7]=64; graph[8]=64; graph[9]=64;
    graph[10]=83888129; graph[11]=529410; graph[12]=26624; graph[13]=4096;
    graph[14]=102400; graph[15]=16384; graph[16]=409600; graph[17]=65536;
    graph[18]=2686976; graph[19]=1312768; graph[20]=524288; graph[21]=12845056;
    graph[22]=2097152; graph[23]=1092616192; graph[24]=41944064; graph[25]=16777216;
    graph[26]=402654208; graph[27]=67108864; graph[28]=1677721600; graph[29]=268435456;
    graph[30]=2424307712; graph[31]=1073741824;

    // Initialize distance and previous arrays
    for(i=0; i<V; i++) {
        dist[i] = 40;
        prev[i] = 255;
    }    
    dist[START_POINT] = 0;

    // Bellman-Ford-like edge relaxation
    for(i=0; i<V-1; i++) {   
        for(j=0; j<V; j++) {
            // if (dist[j] != 40) {
                for(k=0; k<V; k++) {
                    if((graph[j] & (1 <<(k)))) { 
                        if(dist[j] != 40 && dist[j] + 1 < dist[k]) {
                            dist[k] = dist[j] + 1;
                            prev[k] = j;
                        }
                    }
                }
            }
    }
    

    // Backtracking to construct path from end to start
    idx = 0;
    j = END_POINT;
    while (j != 255) {
        path_planned[idx++] = j;
        j = prev[j];
    }

    // Reverse path for correct order
    for (i = 0, j = idx - 1; i < j; i++, j--) {
        k = path_planned[i];
        path_planned[i] = path_planned[j];
        path_planned[j] = k;
    }

    // Sequentially write path to NODE_POINT memory
    for (i = 0; i < idx; ++i) {
        NODE_POINT = path_planned[i];
    }
    CPU_DONE = 1;

    #ifdef __linux__    
        _put_str("######### Planned Path #########\n");
        for (int i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");
    #endif

    return 0;
}
