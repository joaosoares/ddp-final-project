#include <stdint.h>


void encryption(uint32_t *msg, uint32_t *e, uint32_t e_len, uint32_t *N, uint32_t *N_prime) {
    uint32_t ctext;
    int size = 32;

    mod_exp(msg, e, e_len, N, N_prime, ctext, size);
}

void decryption(uint32_t *p, uint32_t *q, uint32_t *p_prime, uint32_t *q_prime, 
                uint31_t *N, uint32_t *N_prime, uint32_t *x_p, uint32_t *x_q, 
                uint32_t *ctext, uint32_t *R2_1024, uint32_t *Rp2, uint32_t *Rq2, 
                uint32_t *d_p, uint32_t *d_q, uint32_t d_p_len, uint32_t d_q_len) {

    uint32_t Ct2h, Ct2l, tp, tq, Cp, Cq, Mp, Mq;
    int size = 32;

    Ct2h = ctext[1023:512];
    Ct2l = ctext[511:0];

    tp = montgomery_multiply();   //512 HW   Montmul(Ct2h, Rp2, p)
    tq = montgomery_multiply();   //512 HW   Montmul(Ct2h, Rq2, q)

    Cp = (tp + Ct2l) % p;   
    Cq = (tq + Ct2l) % q;

    mod_exp(Cp, d_p, d_p_len, p, p_prime, Mp, size);   //use 512 HW
    mod_exp(Cq, d_q, d_q_len, q, q_prime, Mq, size);

    tp = montgomery_multiply(Mp * x_p, R2_1024, N, N_prime, , size);    //1024 SW   Tp = MontMul(Mp * xp, m)
    tq = montgomery_multiply(Mq * x_q, R2_1024, N, N_prime, , size);    //1024 SW   Tq = MontMul(Mq * xq, m)
    t = (tp+tq) % N;                                                    //T = (Tp + Tq) mod m
    msg = montgomery_multiply(t, R_1024, N, N_prime, , size);           //1024 SW   msg = MontMul(T, R_1024, m)

}

