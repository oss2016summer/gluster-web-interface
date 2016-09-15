#include <iostream>
#include <cstdio>
#include <cstring>
#define min(a,b) ((a)<(b)?(a):(b))

using namespace std;
const int MAX_N = 6;
const int INF = 1e9;
const char interval[12][3]
    = {"A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"};
int n, m;
int str[MAX_N];
int tune[MAX_N];
int music[MAX_N];
int difficulty[MAX_N];

/*
6 3
E A D G B E
E G# B
6 3
E E B G# B E
E G# B
6 3
E E G# B A A
E G# B
6 3
E E G# B B A
E G# B
6 3
A A A A A A
E G# B
*/

int solve(int x)
{
    if(x == n)
    {
        int cnt = 0;
        bool chk[6] = {false};

        for(int i = 0; i < n; ++i)
        {
            bool is_harmony = false;

            for(int j = 0; j < m; ++j)
            {
                if(str[i] == music[j])
                {
                    chk[j] = true;
                    is_harmony = true;
                }
            }

            if(!is_harmony) return INF;
        }

        for(int i = 0; i < m; ++i)
            if(!chk[i]) return INF;

        int high = 0, low = INF;

        for(int i = 0; i < n; ++i)
        {
            if(tune[i] == str[i]) continue;
            ++cnt;

            int diff = min((tune[i] - str[i] + 12) % 12, (str[i] - tune[i] + 12) % 12);

            if(high < diff) high = diff;
            if(low > diff) low = diff;
        }

        if(!cnt) return 0;
        if(cnt == 1) return high + 1;
        return high - low + 1;
    }

    int ret = INF;

    for(int i = 0; i < 12; ++i)
    {
        str[x] = i;
        int tmp = solve(x + 1);
        ret = min(ret, tmp);
    }

    return ret;
}

void get(int *cord)
{
    char in[3]; cin >> in;
    for(int i = 0; i < 12; ++i)
        if(!strcmp(in, interval[i])) *cord = i;
}

void proc()
{
    cin >> n >> m;
    for(int i = 0; i < n; ++i) get(&tune[i]);
    for(int i = 0; i < m; ++i) get(&music[i]);

    if(!n || !m) {cout << 0; return;}
    
    cout << solve(0) << "\n";
}

int main()
{
    proc();
    return 0;
}
