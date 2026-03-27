int fibonacci(int n) {
    
    if (n <= 0)
        return;

    int a = 0, b = 1, c, i;

    for (i = 1; i < n; i++) {
        c = a + b;
        a = b;
        b = c;
    }

    return a;
}

int main(void) {

    int fib = fibonacci(5);
    return 0;        
}