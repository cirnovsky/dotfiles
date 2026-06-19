#include "bits/stdc++.h"
#include <functional>

/// {{{ definitions
using ll = long long; using ull = unsigned long long; using db = double; using ldb = long double;

#define all(u) (u).begin(), (u).end()
#define part(u, l, r) (u).begin() + (l), (u).begin() + (r)
#define slice(u, l, r) vi(part(u, l, r))
#define len(u) ((int) (u).size())
std::mt19937 rnd(std::chrono::steady_clock::now().time_since_epoch().count());
#define rng(l, r) std::uniform_int_distribution<ll>(l, r - 1)(rnd)

using vi = std::vector<int>; using vvi = std::vector<vi>; using vll = std::vector<ll>; using vvll = std::vector<vll>; using bsi = std::basic_string<int>; template <typename Tp> using vt = std::vector<Tp>; template <typename Tp> using bst = std::basic_string<Tp>;

template <typename Tp> void rd(Tp& x) { std::cin >> x; }
template <typename Tp, typename... Args> void rd(Tp& x, Args&... args) { rd(x), rd(args...); }
template <typename Tp> void rds(Tp* v, int n) { for (int i = 0; i < n; ++i) rd(v[i]); }
template <typename Tp> void rds(std::vector<Tp> &v) { for (Tp& x : v) rd(x); }
template <typename Tp> Tp& cmax(Tp& x, const Tp& y) { return x = std::max(x, y); }
template <typename Tp> Tp& cmin(Tp& x, const Tp& y) { return x = std::min(x, y); } // }}}

using namespace std;

#ifdef LOCAL
#include "t/dbg"
#else
#define debug(x...)
#endif

bool match_bits(int n,int m,vi v){
  vi v2(m);
  for(int k=0;k<m;++k){
    for(int i=1;i<=n;++i)
      v2[k]+=(i>>k&1);
  }
  sort(v.begin(),v.end());
  sort(v2.begin(),v2.end());
  for(int i=0;i<m;++i){
    if(v[i]!=v2[i])return 0;
  }
  return 1;
}
ll solve(){
  int n;
  cin>>n;
  int m=0;
  while((1<<m)<=n)m++;
  vector<int>cnts(m),nums(n);
  vector<string> strs(m);
  for(int i=0;i<m;++i){
    string s;
    cin>>s;
    strs[i]=s;
    for(int j=0;j<n;++j){
      if(s[j]=='1'){
        cnts[i]++;
        nums[j]^=(1<<i);
      }
    }
  }
  bool match_nums=0;
  {
    vi id(m);
    iota(id.begin(),id.end(),0);
    sort(id.begin(),id.end(),[&](int i,int j){
        return cnts[i]>cnts[j];
        });
    vi perm(n);
    for(int i=0;i<m;++i){
      auto const&s=strs[i];
      for(int j=0;j<n;++j){
        if(s[j]=='1'){
          perm[j]^=(1<<i);
        }
      }
    }
    sort(perm.begin(),perm.end());
    for(int i=0;i<n;++i){
      cout<<" "<<perm[i];
    }
    cout<<"\n";
    match_nums=1;
    for(int i=0;i<n;++i){
      if(perm[i]!=i+1)match_nums=0;
    }
  }
  if(!match_bits(n,m,cnts)||!match_nums)return 0;
  sort(cnts.rbegin(), cnts.rend());
  vi freq(n+1);
  for (auto cnt:cnts)freq[cnt]++;
  ll res=1;
  for(int cnt=0;cnt<=n;++cnt){
    for(int i=1;i<=freq[cnt];++i)res*=i;
  }
  return res;
}

int main() {
  cin.tie(nullptr)->sync_with_stdio(0);
  int t;
  cin>>t;
  while(t--)cout<<solve()<<"\n";
}
