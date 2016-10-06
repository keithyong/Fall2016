#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <openssl/evp.h>

uint8_t* h(char* message) {
    EVP_MD_CTX mdctx;
    const EVP_MD *md;
    unsigned char md_value[EVP_MAX_MD_SIZE];
    unsigned int md_len, i;

    OpenSSL_add_all_digests();
    md = EVP_get_digestbyname("md5");

    EVP_MD_CTX_init(&mdctx);
    EVP_DigestInit_ex(&mdctx, md, NULL);
    EVP_DigestUpdate(&mdctx, message, strlen(message));
    EVP_DigestFinal_ex(&mdctx, md_value, &md_len);

    uint8_t* ret = malloc(4);
    for (i = 0; i < 3; i++) {
        ret[i] = md_value[i];
    }

    return ret;
}

int eq(uint8_t* d1, uint8_t* d2, int len) {
    int ret = 1;

    for (int i = 0; i < len; i++) {
        if (d1[i] != d2[i]) {
            ret = 0;
        }
    }

    return ret;
}

void rand_str(char *s, const int len) {
    static const char charset[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    int seed = time(NULL);
    srand(seed);

    for (int i = 0; i < len; ++i) {
        s[i] = charset[rand() % (sizeof(charset) - 1)];
    }

    s[len] = 0;
}

int main(int argc, char *argv[])
{
    char my_str[5];
    rand_str(my_str, 5);
    printf("%s\n", my_str);
    uint8_t* h1 = h(my_str);
    for (int i = 0; i < 3; i++) {
        printf("%02X", h1[i]);
    }
    
    int trials = 0;
    uint8_t* h2 = h("0");
    while (!eq(h1, h2, 3)) {
        char buf[200];
        sprintf(buf, "%d", trials);
        h2 = h(buf);
        printf("%d %s->%02X%02X%02x %02X%02X%02x\n", trials, my_str, h1[0], h1[1], h1[2], h2[0], h2[1], h2[2]);
        trials++;
    }

    return 0;
}




