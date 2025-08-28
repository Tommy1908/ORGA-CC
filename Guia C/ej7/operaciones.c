#include <stdio.h>

int main() {

    int a,b,c,d,r;
    a = 5;
    b = 3;
    c = 2;
    d = 1;

    r = a +  b * c / d;
    printf("%d\n",r);

    r = a % b;
    printf("%d\n",r);

    r = a == b;
    printf("%d\n",r);

    r = a != b;
    printf("%d\n",r);

    r = a & b;   //bitwise and
    printf("%x\n",r);

    r = a | b;  //bitwise or 101 | 011 = 111 = 7(d)
    printf("%x\n",r);

    r = ~a;  //bitwise not (habria que interpretarlo luego)
    printf("%x\n",r);

    r = a && b;
    printf("%d\n",r);
    
    r = a || b;
    printf("%d\n",r);

    r = a >> 1;     //bitwise shift
    printf("%x\n",r);

    r = a << 1;     //bitwise shift
    printf("%x\n",r);

    r = a += b;
    printf("%d\n",r);

    r = a -= b;
    printf("%d\n",r);
    
    r = a *= b;
    printf("%d\n",r);

    r = a /= b;
    printf("%d\n",r);

    r = a %= b;
    printf("%d\n",r);

    return 0;
}