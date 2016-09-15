#include <iostream>
#include <cstdio>
#include <queue>
#include <vector>

using namespace std;
const int MAX_N = 100;
const int INF = 1000000007;
const int dy[] = {0, 0, 1, -1};
const int dx[] = {1, -1, 0, 0};
int n, m;
char maze[MAX_N+2][MAX_N+2];
int dist[MAX_N+2][MAX_N+2];

int solve()
{
    for(int i = 0; i < n; ++i)
        for(int j = 0; j < m; ++j)
            dist[i][j] = INF;
    queue<pair<int, int> > q;
    q.push(make_pair(0, 0));
    dist[0][0] = 0;

    while(!q.empty())
    {
        int y = q.front().first;
        int x = q.front().second;
        q.pop();

        for(int i = 0; i < 4; ++i)
        {
            int ny = y + dy[i];
            int nx = x + dx[i];

            if(ny >= 0 && ny < n &&
                nx >= 0 && nx < m &&
                (dist[ny][nx] > dist[y][x] + (maze[ny][nx] == '1')))
            {
                dist[ny][nx] = dist[y][x] + (maze[ny][nx] == '1');
                q.push(make_pair(ny, nx));
            }
        }
    }

    return dist[n - 1][m - 1];
}

void proc()
{
    cin >> m >> n;
    for(int i = 0; i < n; ++i)
        cin >> maze[i];
    cout << solve() << endl;
}

int main()
{
    proc();
    return 0;
}
