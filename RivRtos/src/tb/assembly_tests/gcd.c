int gcd(volatile int a, volatile int b) {
    while (b != 0) {
        volatile int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

int main() {
    volatile int result = gcd(48, 18);  // GCD = 6
    register int r0 asm("a0") = result;
    return 0;
}
