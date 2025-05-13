int main() {
    volatile char* byte_ptr   = (char*) 0x0;
    volatile short* half_ptr = (short*) 0x0;
    volatile int* word_ptr   = (int*) 0x0;

    // Write using sb (store byte)
    for (int i = 0; i < 20; i++) {
        byte_ptr[i] = (char)(i + 1);  // sb
    }

    // Read using lb (load byte)
    int sum1 = 0;
    for (int i = 0; i < 20; i++) {
        sum1 += byte_ptr[i];  // lb
    }

    // Write using sh (store halfword)
    for (int i = 0; i < 10; i++) {
        half_ptr[i] = (short)(i + 100);  // sh
    }

    // Read using lh (load halfword)
    int sum2 = 0;
    for (int i = 0; i < 10; i++) {
        sum2 += half_ptr[i];  // lh
    }

    // Write using sw (store word)
    for (int i = 0; i < 5; i++) {
        word_ptr[i] = i + 1000;  // sw
    }

    // Read using lw (load word)
    int sum3 = 0;
    for (int i = 0; i < 5; i++) {
        sum3 += word_ptr[i];  // lw
    }

    // Return final combined result to register a0
    return sum1 + sum2 + sum3;
}
