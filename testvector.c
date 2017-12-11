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
uint32_t M[32] = {0xd1f72277, 0x5bcebff7, 0x0f28d9ed, 0xe43362d8, 0xc5c6c315, 0x855753eb, 0xcb9978eb, 0xb04d99ad, 0x01c7c457, 0x2b5ccae1, 0x2b623a24, 0x4d9ce47f, 0x70f0f243, 0xc770f081, 0x67f34a9b, 0x18229f68, 0xdf327808, 0x00a34197, 0x0525ffdb, 0xf4b5797c, 0xdc1eed8f, 0xa115f7e8, 0x35e7960a, 0x7ec4d255, 0x7ec475ec, 0x6184c174, 0x8f3ef993, 0x0df6bbaa, 0x22928bf8, 0x6f58f75d, 0x00121ef8, 0x8736b775};                 
                                                                 
// prime p and q                                                 
uint32_t p[16] = {0x0275de9f, 0x107fd2ab, 0xb8c33cad, 0x1ed76118, 0x6d56dde6, 0xad34681b, 0x5d0cfd12, 0xe621f0c9, 0x8281698e, 0x92ba82c9, 0x571ead50, 0xe5a38007, 0x4f21109d, 0x336a4898, 0xf963e8b4, 0xf4aab53f};                 
uint32_t q[16] = {0x1f50af23, 0x11140071, 0xe308c560, 0x91206844, 0x01742416, 0x7af7ed21, 0x7d87db23, 0x9d1c5f80, 0x9a06c0b6, 0x8b287d5f, 0x8c98736c, 0xea0fd54b, 0xc9057db6, 0x03d55bb0, 0xbc3dc18f, 0x8f1d94fc};                 
                                                                 
// modulus                                                       
uint32_t N[32]       = {0xbbfc20bd, 0x36ad0309, 0x4fae157f, 0xc4ea08c0, 0x0d37681c, 0x07e72b82, 0xf345dca3, 0x4a723f88, 0xdcf5ac59, 0x06b8a6b2, 0x368a00f3, 0xdb7d2058, 0x2c9dbb28, 0x124e2690, 0xcdd19842, 0x5ae15e97, 0xe2bda701, 0x9d11ea54, 0xe18c6fc9, 0xe0c3160c, 0xa00703b0, 0x1e21f6b5, 0xaf942238, 0xbe210e79, 0xc2ca886b, 0x6c20ecb1, 0xfcafdd9e, 0xba6224ee, 0xf80d650a, 0xd3119ff0, 0x8149d93a, 0x88c7a0f9};           
uint32_t N_prime[32] = {0x7e1f256b, 0x83dbe076, 0x6640a5e5, 0x7b9efc19, 0xcda50596, 0xd7b39c97, 0x4d8cb877, 0x3dfed80f, 0x7bc6ab2b, 0x66833e2c, 0x544cf630, 0xea63f8c9, 0x24dd3f41, 0x0ceb1ef4, 0x7cda2f92, 0xd5521efe, 0x9cf36016, 0x12fbe409, 0x46775528, 0xd346ccda, 0xb184f914, 0x981b516b, 0x75eb8385, 0x39c7425d, 0x8733bd5c, 0xd2a971df, 0x4a718971, 0x093ce057, 0xc3268d0a, 0x89da0333, 0x587151e7, 0x66edd04d};     
                                                                 
// encryption exponent                                           
uint32_t e[32] = {0x0000ef6b};                  
uint32_t e_len = 16;                                             
                                                                 
// decryption exponent, reduced to p and q                       
uint32_t d_p[16] = {0x14524a37, 0x5ea0fa91, 0xb405a257, 0x5568c48d, 0x52907a65, 0x0de175b6, 0xdb7bb813, 0x755be7d7, 0x2429874f, 0x6ab70b5a, 0xf0908ea1, 0xc9176e86, 0x7da0fbc4, 0x251e3aa2, 0x5af4a293, 0x94d35947};             
uint32_t d_q[16] = {0x256189c1, 0x0e5d085f, 0xf6bfae01, 0x7952d98f, 0xe9c55c34, 0xab5991db, 0x662c74fe, 0xa0a65d2b, 0x33593474, 0x5265f008, 0xdefd4166, 0xd15088c9, 0xefbebc8d, 0xef74d990, 0xc3ccbc5b, 0x6b4f762d};             
uint32_t d_p_len =  512;      
uint32_t d_q_len =  511;      
                                                                 
// x_p and x_q                                                   
uint32_t x_p[32] = {0x936f8d1d, 0xda2f1756, 0xb44a50a4, 0x4859ddbf, 0x81dc2297, 0x76e49a7f, 0x13c5ad88, 0x1212f80d, 0x55c3c10e, 0xb4b264aa, 0x02338dbf, 0x23043580, 0x56656be5, 0x46c565ba, 0xc76e2b17, 0xbc4a097b, 0x4e82fab4, 0xffa75f66, 0x2132a65f, 0xdd39384f, 0x3d5a27a6, 0x80a79cf8, 0xb1f8e108, 0x18a6311f, 0xa0d6977d, 0x43097156, 0xb6b986e1, 0xf2527186, 0x929fdd66, 0x140114bf, 0xefd6c6e1, 0x48f5279f};             
uint32_t x_q[32] = {0x288c93a1, 0x5c7debb3, 0x9b63c4da, 0x7c902b00, 0x8b5b4585, 0x91029102, 0xdf802f1a, 0x385f477b, 0x8731eb4b, 0x52064208, 0x34567333, 0xb878ead8, 0xd6384f43, 0xcb88c0d5, 0x06636d2a, 0x9e97551c, 0x943aac4c, 0x9d6a8aee, 0xc059c969, 0x0389ddbd, 0x62acdc0a, 0x9d7a59bd, 0xfd9b412f, 0xa57add59, 0x21f3f0ee, 0x29177b5b, 0x45f656bd, 0xc80fb368, 0x656d87a3, 0xbf108b31, 0x91731259, 0x3fd27959};             
                                                                 
// R mod p, and R mod q, (R = 2^512)                             
uint32_t Rp[16] = {0xfd8a2161, 0xef802d54, 0x473cc352, 0xe1289ee7, 0x92a92219, 0x52cb97e4, 0xa2f302ed, 0x19de0f36, 0x7d7e9671, 0x6d457d36, 0xa8e152af, 0x1a5c7ff8, 0xb0deef62, 0xcc95b767, 0x069c174b, 0x0b554ac0};               
uint32_t Rq[16] = {0xe0af50dd, 0xeeebff8e, 0x1cf73a9f, 0x6edf97bb, 0xfe8bdbe9, 0x850812de, 0x827824dc, 0x62e3a07f, 0x65f93f49, 0x74d782a0, 0x73678c93, 0x15f02ab4, 0x36fa8249, 0xfc2aa44f, 0x43c23e70, 0x70e26b03};               
                                                                 
// R^2 mod p, and R^2 mod q, (R = 2^512)                         
uint32_t R2p[16] = {0x4d015f4b, 0x0a40bb4d, 0xd51c3a24, 0xb3a449ed, 0xbe1e6926, 0x1b1f9998, 0x6626ef6b, 0xe385d63e, 0x995dc71a, 0xc4017db6, 0x8226fbce, 0xd892c992, 0xc78e07bc, 0xde016da5, 0x2b6b96ab, 0x8d635aa6};             
uint32_t R2q[16] = {0xcf55c61c, 0x550ad6f8, 0xcf419bb1, 0x47b83077, 0xbc32f198, 0xad4eb682, 0xa5e87fac, 0xf7a8d0cc, 0x8a623585, 0x65253436, 0x75bd691f, 0xf7a726ff, 0x93b1ddd0, 0x78f7dc23, 0xd2b0506c, 0x01f3099e};             
                                                                 
// R mod N, and R^2 mod N, (R = 2^1024)                          
uint32_t R_1024[32]  = {0x4403df43, 0xc952fcf6, 0xb051ea80, 0x3b15f73f, 0xf2c897e3, 0xf818d47d, 0x0cba235c, 0xb58dc077, 0x230a53a6, 0xf947594d, 0xc975ff0c, 0x2482dfa7, 0xd36244d7, 0xedb1d96f, 0x322e67bd, 0xa51ea168, 0x1d4258fe, 0x62ee15ab, 0x1e739036, 0x1f3ce9f3, 0x5ff8fc4f, 0xe1de094a, 0x506bddc7, 0x41def186, 0x3d357794, 0x93df134e, 0x03502261, 0x459ddb11, 0x07f29af5, 0x2cee600f, 0x7eb626c5, 0x77385f06};     
uint32_t R2_1024[32] = {0x22f47dee, 0xf5713476, 0x1cd271a5, 0xcaef844d, 0xe4dfe69e, 0x21310383, 0xa8d683ed, 0x8e3dafe0, 0x3850d425, 0xddd8c78f, 0x027ebe51, 0x69522c83, 0x5b87bdca, 0xed6b9fdd, 0x0a4a4a0b, 0x40e5cf13, 0xe01dc8cc, 0x2d59d31b, 0x48725aa8, 0x4042e36e, 0x9c136c2a, 0xff5afff6, 0xad2bbbce, 0x4805f182, 0x0f651f17, 0x07ba3e74, 0xb04591cf, 0x196464b7, 0x48754ce6, 0xe0983de5, 0x2e4875f2, 0x1356d001};     
                                                                 
// One                                                           
uint32_t One[32] = {1,0};                                          