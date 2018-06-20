#include <stdio.h>
#include <stdlib.h>

extern void interpret(char*);

int main(int argc, char **argv) {

    if (argc != 2) {
        printf("usage: %s FILE\nInterprets BrainFuck file.\nBuffored inupt, use ^D to send EOT\n", argv[0]);
    } else {
        FILE *file = fopen(argv[1], "rb");
        if (!file) {
            printf("Cound not open file %s\n", argv[1]);
            return 1;
        } else {
            fseek(file, 0, SEEK_END);
            long fsize = ftell(file);
            fseek(file, 0, SEEK_SET);

            char *program = malloc(fsize + 1);

            fread(program, fsize, 1, file);
            fclose(file);
            program[fsize] = 0;

            interpret(program);

            free(program);
        }
    }

    return 0;
}
