#include <iostream>
#include <cstdint>
using namespace std;

int main() {
    __int8  A[8] = { 1, -2, 3, -4, 5, -6, 7, -8 };
    __int8  B[8] = { 2, 3, -1, 4, -2, 5, -3, 6 };
    __int8  C[8] = { -1, 2, 3, -2, 4, -3, 5, -4 };
    __int16 D[8] = { 10, 20, 30, 40, 50, 60, 70, 80 };
    __int16 F[8];   
    __int16 F_ref[8]; 

    // MMX
    __asm {
        movq mm0, [A]
        movq mm1, [B]
        movq mm2, [C]

        movq mm3, mm0
        punpcklbw mm0, mm0
        psraw mm0, 8
        punpckhbw mm3, mm3
        psraw mm3, 8

        movq mm4, mm1
        punpcklbw mm1, mm1
        psraw mm1, 8
        punpckhbw mm4, mm4
        psraw mm4, 8

        movq mm5, mm2
        punpcklbw mm2, mm2
        psraw mm2, 8
        punpckhbw mm5, mm5
        psraw mm5, 8

        pmullw mm1, mm2
        pmullw mm4, mm5

        paddw mm1, mm0
        paddw mm4, mm3

        paddw mm1, [D]
        paddw mm4, [D + 8]; смещение на 8 байт(4 слова)

        movq[F], mm1
        movq[F + 8], mm4

        emms
    }

    // C++
    for (int i = 0; i < 8; i++) {
        F_ref[i] = static_cast<__int16>(A[i])
            + static_cast<__int16>(B[i]) * static_cast<__int16>(C[i])
            + D[i];
    }

    cout << "MMX version:" << endl;
    for (int i = 0; i < 8; i++) {
        cout << "F[" << i << "] = " << F[i] << endl;
    }

    cout << "\nC++ reference:" << endl;
    for (int i = 0; i < 8; i++) {
        cout << "F_ref[" << i << "] = " << F_ref[i] << endl;
    }

    return 0;
}
