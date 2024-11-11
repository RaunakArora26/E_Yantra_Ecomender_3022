#include <stdio.h>
#include <limits.h>

// Function to add an edge between two vertices in a graph
void addEdge(int n, int graph[n*n], int u, int v, int weight)
{
    graph[u*n + v] = weight;  // Add edge from u to v
    graph[v*n + u] = weight;  // Add edge from v to u (for undirected graph)
}

int min(int n, int dist[], int visited[])
{
    int min = INT_MAX;
    int min_index = -1;

    for (int i = 0; i < n; i++)
    {
        if (!visited[i] && dist[i] < min) // find unvisited node with the smallest dist
        {
            min = dist[i];
            min_index = i;
        }
    }
    return min_index;
}


void dikshtra(int n,int graph[n*n],int start,int end)
{
    int visited[n];
    int prev[n];
    int dist[n];
    int v;
    for(int i=0;i<n;i++)//set all distances to be infinity and all unexplored
    {
        dist[i] = INT_MAX;
        visited[i] = 0;
        prev[i] = -1;
    }    
    dist[start] = 0;//set distance of start of itself to be 0;
    
    while(!visited[end])
    {
        v = min(n,dist,visited);//find the min distacnce
        visited[v] = 1;//visit the min vertex with min distance from the start

        for(int i=0;i<n;i++)//for each edge(v,w)
        {
            if (graph[v*n + i] != 0 && (dist[v] + graph[v*n + i] < dist[i]))//if the calcultated distance of a vertex is less than the known distance
            {
                dist[i] = dist[v] + graph[v*n + i];//update the shortest distance
                prev[i] = v;
            }
        }
    }
    // Print the shortest distance
    printf("Shortest distance from %d to %d is %d\n", start, end, dist[end]);

    // Reconstruct and print the path from start to end using the prev array
    printf("Path: ");
    int path[n];
    int count = 0;
    for (int at = end; at != -1; at = prev[at]) // Backtrack from the end vertex to start
    {
        path[count++] = at;
    }
        // Print the path in reverse order
    for (int i = count - 1; i > 0; i--)
    {
        printf("%d->", path[i]);
    }
    printf("%d", path[0]);
    printf("\n");
}    


int main()
{
    // int graph[6][6] =  {{0,4,4,0,0,0},
    //                     {4,0,2,0,0,0},
    //                     {4,2,0,3,1,6},
    //                     {0,0,3,0,0,2},
    //                     {0,0,1,0,0,3},
    //                     {0,0,6,2,3,0}
    //                    };
    // int vertices = 6;
    // int start = 0;
    // int end = 5;
    int vertices = 32;
    int graph[32*32] = {0};  // Initialize all weights to 0 (no edges)
    //int graph[32] = {0};  // Initialize all weights to 0 (no edges)

    // Add edges using the addEdge function
    addEdge(vertices, graph, 0 , 1 , 2);
    addEdge(vertices, graph, 0 , 10, 2);
    addEdge(vertices, graph, 0 , 6 , 2);
    addEdge(vertices, graph, 1 , 11, 1);
    addEdge(vertices, graph, 1 , 2 , 3);
    addEdge(vertices, graph, 2 , 3 , 1);
    addEdge(vertices, graph, 2 , 4 , 1);
    addEdge(vertices, graph, 2 , 5 , 1);
    addEdge(vertices, graph, 6 , 9 , 1);
    addEdge(vertices, graph, 6 , 7 , 1);
    addEdge(vertices, graph, 6 , 8 , 1);
    addEdge(vertices, graph, 10, 26, 2);
    addEdge(vertices, graph, 10, 11, 1);
    addEdge(vertices, graph, 10, 24, 2);
    addEdge(vertices, graph, 11, 12, 2);
    addEdge(vertices, graph, 11, 19, 2);
    addEdge(vertices, graph, 26, 27, 1);
    addEdge(vertices, graph, 26, 28, 3);
    addEdge(vertices, graph, 28, 29, 1);
    addEdge(vertices, graph, 28, 30, 2);
    addEdge(vertices, graph, 30, 31, 1);
    addEdge(vertices, graph, 30, 23, 1);
    addEdge(vertices, graph, 23, 21, 2);
    addEdge(vertices, graph, 23, 24, 3);
    addEdge(vertices, graph, 24, 25, 1);
    addEdge(vertices, graph, 21, 22, 1);
    addEdge(vertices, graph, 21, 18, 2);
    addEdge(vertices, graph, 18, 19, 3);
    addEdge(vertices, graph, 18, 16, 1);
    addEdge(vertices, graph, 19, 20, 1);
    addEdge(vertices, graph, 16, 17, 1);
    addEdge(vertices, graph, 16, 14, 2);
    addEdge(vertices, graph, 14, 15, 1);
    addEdge(vertices, graph, 14, 12, 3);
    addEdge(vertices, graph, 12, 13, 1);

    int start = 4;
    int end = 23;
                    //   0 ,1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
    // int graph[32][32] ={{0 ,2 ,0 ,0 ,0 ,0 ,2 ,0 ,0 ,0 ,2 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//0
    //                     {2 ,0 ,3 ,0 ,0 ,0 ,2 ,0 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//1
    //                     {0 ,3 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//2
    //                     {0 ,0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//3
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//4
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//5
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//6
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//7
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//8
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//9
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//10
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//11
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//12
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//13
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//14
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//15
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//16
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//17
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//18
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//19
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//20
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//21
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//22
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//23
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//24
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//25
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//26
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//27
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//28
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//29
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//30
    //                     {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0},//31
    //                    };
   
    
    dikshtra(vertices,graph,start,end);



    return 0;
}
