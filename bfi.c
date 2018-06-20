#include <stdio.h>

extern void interpret(char*);

int main() {
    char p[] = "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++...>++++++++++.";
    printf("begin\n");
    interpret(p);
    printf("endn\n");
    return 0;
}
