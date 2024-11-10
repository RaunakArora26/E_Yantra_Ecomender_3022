
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
            putchar('0'); // if the number is 0, directly print '0'
            _put_byte('\n');
            return;
        }

        if (num < 0) {
            putchar('-'); // print the negative sign for negative numbers
            num = -num;   // make the number positive for easier processing
        }

        // convert the integer to a string
        char buffer[20]; // assuming a 32-bit integer, the maximum number of digits is 10 (plus sign and null terminator)
        uint8_t index = 0;

        while (num > 0) {
            buffer[index++] = '0' + num % 10; // convert the last digit to its character representation
            num /= 10;                        // move to the next digit
        }
        // print the characters in reverse order (from right to left)
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
        // Address value of variables for RISC-V Implementation
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)

    #endif

    // array to store the planned path
    // uint8_t path_planned[32];
    // // index to keep track of the path_planned array
    // uint8_t idx = 0;
    // uint8_t prev[32];
    // uint8_t dist[32];

    /* Functions Usage

    instead of using printf() function for debugging,
    use the below function calls to print a number, string or a newline

    for newline: _put_byte('\n');
    for string:  _put_str("your string here");
    for number:  _put_value(your_number_here);

    Examples:
            _put_value(START_POINT);
            _put_value(END_POINT);
            _put_str("Hello World!");
            _put_byte('\n');
    */

    // ############# Add your code here #############
    // prefer declaring variable like this
    #ifdef __linux__
        uint32_t graph[30];
        uint8_t i;  
        uint8_t j;
        uint8_t k;
        uint8_t prev[32];
        uint8_t dist[32];
        uint8_t path_planned[32];
        uint8_t idx = 0;

    #else
        uint32_t *graph = (uint32_t *) 0x02000010;
        uint8_t i = ((uint8_t ) 0x02000090);
        uint8_t j = ((uint8_t) 0x02000091);
        uint8_t k = ((uint8_t) 0x02000092);
        uint8_t *prev = (uint8_t *) 0x020000b1;
        uint8_t *dist = (uint8_t *) 0x020000D0;
        uint8_t *path_planned = (uint8_t *) 0x020000ef;
        uint8_t idx = (uint8_t) 0x0200010e;
    #endif


    // ##############################################
    void addEdge(uint32_t* graph, uint8_t u, uint8_t v)
    {
        graph[u] |= (1 << v);
        graph[v] |= (1 << u);
    } 

    void dikshtra(uint32_t * graph,uint8_t start ,uint8_t end ,uint8_t * path_planned,uint8_t *idx,uint8_t * i,uint8_t * j,uint8_t * k,uint8_t *prev,uint8_t * dist)
    {   
        // uint8_t prev[32];
        // uint8_t dist[32];

        for(*i=0;*i<V;(*i)++)//set all distances to be infinity and all unexplored
        {
            dist[*i] = 40;//its infinity for the graph
            //visited[i] = 0;
            prev[*i] = 255;
        }    
        dist[start] = 0;//set distance of start of itself to be 0;

        for(*i=0;*i<V-1;(*i)++)//goes for all the edges
        {   
            for(*j=0;*j<V;(*j)++)
            {
                for(*k=0;*k<V;(*k)++)
                {
                    if((graph[*j] & (1 <<(*k))) ? 1:0)//It checks for every vertex j and its neighbors k using the bitwise adjacency matrix  
                    {
                        if(dist[*j]!=40 && (dist[*j] + 1 < dist[*k]))
                        {
                            dist[*k] = dist[*j] + 1;
                            prev[*k] = *j;
                        }
                    }
                }
            }
        }
        //_put_value(prev[end]);

        // Print the shortest distance
        // Reconstruct and print the path from start to end using the prev array

        for (*j = end; (*j) != 255; (*j) = prev[*j]) // Backtrack from the end vertex to start
        {
            path_planned[(*idx)++] = (*j);
        }
        // Reverse the path_planned array in place
        for (*i = 0, *j = (*idx) - 1; *i < *j; (*i)++, (*j)--)
        {
            // Swap path_planned[i] and path_planned[j]
            *k = path_planned[*i];
            path_planned[*i] = path_planned[*j];
            path_planned[*j] = *k;
        }

    }
    // for(i=0;i<V;(i)++)
    // {
    //     graph[i] = 0;
    // }

    addEdge(graph, 0 , 1 );
    addEdge(graph, 0 , 10);
    addEdge(graph, 0 , 6 );
    addEdge(graph, 1 , 11);
    addEdge(graph, 1 , 2 );
    addEdge(graph, 2 , 3 );
    addEdge(graph, 2 , 4 );
    addEdge(graph, 2 , 5 );
    addEdge(graph, 6 , 9 );
    addEdge(graph, 6 , 7 );
    addEdge(graph, 6 , 8 );
    addEdge(graph, 10, 26);
    addEdge(graph, 10, 11);
    addEdge(graph, 10, 24);
    addEdge(graph, 11, 12);
    addEdge(graph, 11, 19);
    addEdge(graph, 26, 27);
    addEdge(graph, 26, 28);
    addEdge(graph, 28, 29);
    addEdge(graph, 28, 30);
    addEdge(graph, 30, 31);
    addEdge(graph, 30, 23);
    addEdge(graph, 23, 21);
    addEdge(graph, 23, 24);
    addEdge(graph, 24, 25);
    addEdge(graph, 21, 22);
    addEdge(graph, 21, 18);
    addEdge(graph, 18, 19);
    addEdge(graph, 18, 16);
    addEdge(graph, 19, 20);
    addEdge(graph, 16, 17);
    addEdge(graph, 16, 14);
    addEdge(graph, 14, 15);
    addEdge(graph, 14, 12);
    addEdge(graph, 12, 13);

    dikshtra(graph,START_POINT,END_POINT,path_planned,&idx,&i,&j,&k,prev,dist);


    // the node values are written into data memory sequentially.
    for (int i = 0; i < idx; ++i) {
        NODE_POINT = path_planned[i];
    }
    // Path Planning Computation Done Flag
    CPU_DONE = 1;

    #ifdef __linux__    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}

