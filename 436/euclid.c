#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int quotient(int a, int b) {
    int s = b;
    int q = 0;
    
    while (s <= a) {
        s = s + b;
        q++;
    }

    return q;
}

int exteuclid(int a, int b, int *ret) {
    int R[a];
    R[0] = a;
    R[1] = b;
    int i = 2;

    // Ext. Euclid stuff
    int S[a];
    int T[a];
    S[0] = 1;
    S[1] = 0;
    T[0] = 0;
    T[1] = 1;

    while (R[i - 1] != 0) {
        R[i] = R[i - 2] % R[i - 1];
        int q = quotient(R[i - 2], R[i - 1]);
        S[i] = S[i - 2] - q * S[i - 1];
        T[i] = T[i - 2] - q * T[i - 1];
        printf("%d\t%d\t%dR%d\t%d\t%d\n", R[i - 2], R[i - 1], q, R[i - 1], S[i], T[i]);
        i++;
    }

    ret[0] = R[i - 2];
    ret[1] = S[i - 1];
    ret[2] = T[i - 1];

    return 1;
}

int main(int argc, char *argv[]) {
    int ext_res[3];
    int a = strtol(argv[1], NULL, 10);
    int b = strtol(argv[2], NULL, 10);
    exteuclid(a, b, ext_res);
    printf("gcd = %d\n", ext_res[0]);
    printf("s = %d\n", ext_res[1]);
    printf("t = %d\n", ext_res[2]);
}
