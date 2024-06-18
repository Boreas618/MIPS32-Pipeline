int _start() {
    int array[] = {10, 7, 8, 9, 1, 5};
    int n = sizeof(array) / sizeof(array[0]);
    int i, j, pivot, temp, top = -1;
    int stack[n];

    stack[++top] = 0;
    stack[++top] = n - 1;

    while (top >= 0) {
        int h = stack[top--];
        int l = stack[top--];

        pivot = array[h];
        i = (l - 1);

        for (j = l; j <= h - 1; j++) {
            if (array[j] <= pivot) {
                i++;
                temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
        }
        temp = array[i + 1];
        array[i + 1] = array[h];
        array[h] = temp;
        int p = i + 1;

        if (p - 1 > l) {
            stack[++top] = l;
            stack[++top] = p - 1;
        }

        if (p + 1 < h) {
            stack[++top] = p + 1;
            stack[++top] = h;
        }
    }

    int idx = 1;
    while (idx < 6) {
        if (array[i] < array[i-1])
            return -1;
        idx += 1;
    }

    return 0;
}