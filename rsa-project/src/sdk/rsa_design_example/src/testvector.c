#include <stdint.h>                                              
                                                                 
// This file's content is created by the testvector generator    
// python script for seed = 2017.1                    
//                                                               
//  The variables are defined for the RSA                        
// encryption and decryption operations. And they are assigned   
// by the script for the generated testvector. Do not create a   
// new variable in this file.                                    
//                                                               
// When you are submitting your results, be careful to verify    
// the test vectors created for seed = 2017.1, to 2017.5         
// To create them, run your script as:                           
//   $ python testvectors.py crtrsa 2017.1                       
                                                                 
// message                                                       
uint32_t M[32] = {0xd5746a65, 0xa7cf6df8, 0x41a403ec, 0xaaaee05a, 0x972ab36b, 0xb4229356, 0xfb5cf6bd, 0x4651692f, 0x2e40dc96, 0xe1ee04a2, 0x95f42939, 0xcb89aa9a, 0xf73faf7c, 0x44adff86, 0xb8fe500d, 0x502b3a4b, 0x335510ac, 0xbfb1cf52, 0x7e54d3a2, 0xc3956e41, 0x0a20ff0c, 0x67ed8721, 0x8d31612c, 0x4b5957d2, 0xb4b21daa, 0xc32fd21e, 0x42b2b1c7, 0x20e6335f, 0xabe7600e, 0x4ae7fc76, 0xcfd073f8, 0x863b88f9};                 
                                                                 
// prime p and q                                                 
uint32_t p[16] = {0x0b79570b, 0x743c2141, 0x0f79375f, 0x737d9292, 0x00559372, 0x980bf4c7, 0x06a8dbf1, 0xbf591d77, 0xbe399a2f, 0x713227b5, 0xa3c19f08, 0x3afe7827, 0x9e8e189a, 0xfd6bd54e, 0xa85f66e1, 0xd00e11e3};                 
uint32_t q[16] = {0x6dba65b9, 0x1e05f519, 0xdfbd06cc, 0x080090a9, 0xbc1963ae, 0xb5db61fb, 0x528dc6c6, 0x80a41bba, 0x144bc3f8, 0x5c17f1d5, 0x974284ec, 0x52d8f028, 0x5b33c341, 0xb2ceae64, 0xf59911d2, 0xe4a24295};                 
                                                                 
// modulus                                                       
uint32_t N[32]       = {0x17053df3, 0xd015b8d4, 0xe1744a5a, 0xe36051b4, 0x6420fe95, 0xeea9d85a, 0x09077e6f, 0x5fd1dd8a, 0x048762d0, 0xdc1d6d4e, 0x1d9ece70, 0x7d17a40b, 0x9e1ba72b, 0x0d577aad, 0x8bc6dac7, 0xc7bcada3, 0xa6d24162, 0x864a50b0, 0xc87e1f79, 0x9f40ec97, 0x662171c7, 0x5cd01a77, 0x44544fc0, 0x939455c7, 0x85a97646, 0x167bc75d, 0x2113e0b2, 0x7386eb8a, 0x5672fcca, 0xb60307fc, 0x946c7ced, 0xb9d066f3};           
uint32_t N_prime[32] = {0x477c5cc5, 0x485a9e04, 0x601e5c2c, 0x31e6a604, 0x8384647a, 0x981e13ec, 0x8720ac35, 0x7fb6c714, 0x046f718f, 0x0c14b999, 0xf06b18c3, 0x7b91746c, 0x71d98044, 0x1ffd7114, 0xafc5dc95, 0xba51941b, 0xbf448d41, 0x7211a4ea, 0xff303428, 0x8b7093cf, 0x705f3b12, 0x735daeac, 0x92b20c9b, 0x3404e195, 0x9b3d9416, 0x0dfe3db0, 0x8731f0b0, 0xf79c1aec, 0x36e986d6, 0xd44bca80, 0x448a2654, 0x47bb1294};     
                                                                 
// encryption exponent                                           
uint32_t e[32] = {0x0000ac63};                  
uint32_t e_len = 16;                                             
                                                                 
// decryption exponent, reduced to p and q                       
uint32_t d_p[16] = {0xc044cc71, 0xac6f56a5, 0x1047f306, 0x86acea21, 0x3be0b38b, 0x4e2a878a, 0x7d004457, 0x179dcb24, 0xbccbf5ca, 0xd27e2367, 0x6749f54d, 0x73da96dc, 0x7e0275b9, 0xb6ca7bea, 0xd862953a, 0x2f650c8f};             
uint32_t d_q[16] = {0xd0cc95c3, 0x61116527, 0xa8ff0480, 0x279eb1b6, 0xa0fa3153, 0xc55ccc27, 0x8d18526b, 0x27484070, 0xbe506295, 0x0070d0ef, 0x20810d00, 0xe4d30ecd, 0x4367130d, 0xf0db7578, 0xd133a7f0, 0x3c7c5f08};             
uint32_t d_p_len =  510;      
uint32_t d_q_len =  510;      
                                                                 
// x_p and x_q                                                   
uint32_t x_p[32] = {0x922aa0d0, 0x1be819dc, 0xe279bca9, 0x60c522ae, 0xa0307f51, 0xe0db9a6e, 0x6f7e2aab, 0x8a0d6dbd, 0xa3197add, 0x44c2f051, 0xd1292bdc, 0xd638d60e, 0x6cb1d574, 0x4d512009, 0xb3cccd1d, 0xb5c50c65, 0x06c14a6b, 0x3b2421d3, 0xd2e2ab63, 0xbc6475e3, 0xa40eb33c, 0xfaf39c03, 0x40f86261, 0xa78ad6d8, 0x82f1c2f2, 0xa327c406, 0x9353851a, 0x22025dc5, 0x8e8cc24c, 0xb39ff12e, 0x481d94ca, 0x64520b3f};             
uint32_t x_q[32] = {0x84da9d24, 0xb42d9ef7, 0xfefa8db1, 0x829b2f05, 0xc3f07f44, 0x0dce3deb, 0x998953c4, 0xd5c46fcc, 0x616de7f2, 0x975a7cfc, 0x4c75a294, 0xa6decdfc, 0x3169d1b6, 0xc0065aa4, 0xd7fa0da9, 0x11f7a13d, 0xa010f6f7, 0x4b262edd, 0xf59b7416, 0xe2dc76b3, 0xc212be8a, 0x61dc7e73, 0x035bed5e, 0xec097eef, 0x02b7b353, 0x73540357, 0x8dc05b97, 0x51848dc4, 0xc7e63a7e, 0x026316cd, 0x4c4ee823, 0x557e5bb4};             
                                                                 
// R mod p, and R mod q, (R = 2^512)                             
uint32_t Rp[16] = {0xf486a8f5, 0x8bc3debe, 0xf086c8a0, 0x8c826d6d, 0xffaa6c8d, 0x67f40b38, 0xf957240e, 0x40a6e288, 0x41c665d0, 0x8ecdd84a, 0x5c3e60f7, 0xc50187d8, 0x6171e765, 0x02942ab1, 0x57a0991e, 0x2ff1ee1c};               
uint32_t Rq[16] = {0x92459a47, 0xe1fa0ae6, 0x2042f933, 0xf7ff6f56, 0x43e69c51, 0x4a249e04, 0xad723939, 0x7f5be445, 0xebb43c07, 0xa3e80e2a, 0x68bd7b13, 0xad270fd7, 0xa4cc3cbe, 0x4d31519b, 0x0a66ee2d, 0x1b5dbd6a};               
                                                                 
// R^2 mod p, and R^2 mod q, (R = 2^512)                         
uint32_t R2p[16] = {0xc203a529, 0xb635e735, 0x7ee89bd1, 0x279c309c, 0x85bcac01, 0xec588aa6, 0xd80dcb30, 0x560fa220, 0x6630a6e8, 0x235a1f2b, 0x5ba18be5, 0xd694d04d, 0x1ca0d6f8, 0x2a936d59, 0xc12f8c54, 0x9a8a838d};             
uint32_t R2q[16] = {0xe54e653c, 0xb836a119, 0x63d48bc9, 0x48850de7, 0x171d0983, 0x773644f5, 0x7738e101, 0x7b34da3a, 0x271d8b48, 0xa8ff2e2b, 0xede1e6ce, 0x873c4cc4, 0x51249475, 0xe5721b87, 0x25d45568, 0xd5bd60b8};             
                                                                 
// R mod N, and R^2 mod N, (R = 2^1024)                          
uint32_t R_1024[32]  = {0xe8fac20d, 0x2fea472b, 0x1e8bb5a5, 0x1c9fae4b, 0x9bdf016a, 0x115627a5, 0xf6f88190, 0xa02e2275, 0xfb789d2f, 0x23e292b1, 0xe261318f, 0x82e85bf4, 0x61e458d4, 0xf2a88552, 0x74392538, 0x3843525c, 0x592dbe9d, 0x79b5af4f, 0x3781e086, 0x60bf1368, 0x99de8e38, 0xa32fe588, 0xbbabb03f, 0x6c6baa38, 0x7a5689b9, 0xe98438a2, 0xdeec1f4d, 0x8c791475, 0xa98d0335, 0x49fcf803, 0x6b938312, 0x462f990c};     
uint32_t R2_1024[32] = {0xa75e380d, 0x1c9f9ee3, 0x6a0836c4, 0x0fd6a6bf, 0xd3482a2d, 0x1311dcc3, 0x2b35b88d, 0x55713482, 0x835f1108, 0x3951e300, 0x280a97ee, 0x481f36b3, 0x6bcfe888, 0x41bdca71, 0x66292f37, 0xf64122c8, 0xc3995197, 0x56cd4ab1, 0x92b0f12c, 0xc26736bc, 0xb985308e, 0x77765484, 0xebd44d17, 0x1b2ede10, 0xd9f23fbc, 0x28e556a5, 0x09a0d946, 0x458c7662, 0x7aaf653e, 0x465b267f, 0xf10fcac7, 0xa8b7618b};     
                                                                 
// One                                                           
uint32_t One[32] = {1,0};                                          