#include <stdio.h>
#include <limits.h>
#include <stdlib.h>
#define V 32
// Function to add an edge between two vertices in a graph
void addEdge( /*int graph[n*n]*/ int graph[V], int u, int v)
{
    graph[u] |= 1 << v;
    graph[v] |= 1 << u;
}

// void dikshtra(int n,int graph[n],int start,int end)
// {
//     //int visited[n];
//     int prev[n];
//     int dist[n];
//     int v;
//     for(int i=0;i<n;i++)//set all distances to be infinity and all unexplored
//     {
//         dist[i] = 63;//its infinity for the graph
//         //visited[i] = 0;
//         prev[i] = 255;
//     }    
//     dist[start] = 0;//set distance of start of itself to be 0;

//     for(int i=0;i<n;i++)//goes for all the edges
//     {   
//         for(int j=0;j<n;j++)
//         {
//             for(int k=0;k<n;k++)
//             {
//                 //int edgeExist = (graph[j] & (1 <<k)) ? 1:0;

//                 //if(edgeExist)//It checks for every vertex j and its neighbors k using the bitwise adjacency matrix  OR
//                 if((graph[j] & (1 <<k)) ? 1:0)
//                 {
//                     if(dist[j]!=63 && (dist[j] + 1 < dist[k]))
//                     {
//                         dist[k] = dist[j] + 1;
//                         prev[k] = j;
//                     }
//                 }
//             }
//         }
//     }
//     // Print the shortest distance
//     printf("Shortest distance from %d to %d is %d\n", start, end, dist[end]);
//     // Reconstruct and print the path from start to end using the prev array
//     printf("Path: ");
//     int path[n];
//     int count = 0;
//     for (int at = end; at != 255; at = prev[at]) // Backtrack from the end vertex to start
//     {
//         path[count++] = at;
//     }
//         // Print the path in reverse order
//     for (int i = count - 1; i > 0; i--)
//     {
//         printf("%d->", path[i]);
//     }
//     printf("%d", path[0]);
//     printf("\n");



// }    
void dikshtra(int graph[V],int start,int end,int path_planned[V],int* idx)
{
    //int visited[n];
    int prev[V];
    int dist[V];

    for(int i=0;i<V;i++)//set all distances to be infinity and all unexplored
    {
        dist[i] = (int)40;//its infinity for the graph
        //visited[i] = 0;
        prev[i] = (int)255;
    }    
    dist[start] = 0;//set distance of start of itself to be 0;

    for(int i=0;i<V;i++)//goes for all the edges
    {   
        for(int j=0;j<V;j++)
        {
            for(int k=0;k<V;k++)
            {
                if((graph[j] & (1 <<k)) ? 1:0)//It checks for every vertex j and its neighbors k using the bitwise adjacency matrix  
                {
                    if(dist[j]!=(int)40 && (dist[j] + 1 < dist[k]))
                    {
                        dist[k] = dist[j] + 1;
                        prev[k] = j;
                    }
                }
            }
        }
    }
    // printf("Shortest distance from %d to %d is %d\n", start, end, dist[end]);
    //_put_value(prev[end]);
    (*idx) = 0;

    // Print the shortest distance
    // Reconstruct and print the path from start to end using the prev array

    for (int at = end; at != 255; at = prev[at]) // Backtrack from the end vertex to start
    {
        path_planned[(*idx)++] = at;
    }
    // Reverse the path_planned array in place
    for (int i = 0, j = (*idx) - 1; i < j; i++, j--)
    {
        // Swap path_planned[i] and path_planned[j]
        int temp = path_planned[i];
        path_planned[i] = path_planned[j];
        path_planned[j] = temp;
    }
    // for (int i = *(idx) - 1; i >= 0; i--)
    // {
    //     printf("%d->", path_planned[i]);
    // }

}  

int main()
{
    int vertices = 32;
    int graph[32] = {0};  // Initialize all weights to 0 (no edges)

    // Add edges using the addEdge function
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

    int start = 4;
    int end = 28;
    int path_planned[32];
    // index to keep track of the path_planned array
    int idx = 0;
    //dikshtra(vertices,graph,start,end);
    dikshtra(graph,8,11,path_planned,&idx);

    for (int i = (idx) - 1; i >= 0; i--)
    {
        printf("%d->", path_planned[i]);
    }

    return 0;
}
