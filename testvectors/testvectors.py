import helpers
import HW
import SW

import sys

operation = 0
seed = "random"

print "TEST VECTOR GENERATOR FOR DDP\n"

if len(sys.argv) == 2 or len(sys.argv) == 3:
  if str(sys.argv[1])  == "adder":          operation = 1;
  if str(sys.argv[1]) == "subtractor":      operation = 2;
  if str(sys.argv[1]) == "multiplication":  operation = 3;
  if str(sys.argv[1]) == "exponentiation":  operation = 4;
  if str(sys.argv[1]) == "crtrsa":          operation = 5;

if len(sys.argv) == 3:
  print "Seed is: ", sys.argv[2], "\n"
  seed = sys.argv[2]
  helpers.setSeed(sys.argv[2])

#####################################################

if operation == 0:
  print "You should use this script by passing an argument like:"
  print " $ python testvectors.py adder"
  print " $ python testvectors.py subractor"
  print " $ python testvectors.py multiplication"
  print " $ python testvectors.py exponentiation"
  print " $ python testvectors.py crtrsa"
  print ""
  print "You can also set a seed for randomness to work"
  print "with the same testvectors at each execution:"
  print " $ python testvectors.py crtrsa 2017"
  print ""

#####################################################

if operation == 1:
  print "Test Vector for Multi Precision Adder\n"

  A = helpers.getRandomInt(514)
  B = helpers.getRandomInt(514)
  C = HW.MultiPrecisionAdd(A,B,"add")

  print "A                = ", hex(A)           # 514-bits
  print "B                = ", hex(B)           # 514-bits
  print "A + B            = ", hex(C)           # 515-bits

#####################################################

if operation == 2:
  print "Test Vector for Multi Precision Subtractor\n"

  A = helpers.getRandomInt(514)
  B = helpers.getRandomInt(514)
  C = HW.MultiPrecisionAdd(A,B,"subtract")

  print "A                = ", hex(A)           # 514-bits
  print "B                = ", hex(B)           # 514-bits
  print "A - B            = ", hex(C)           # 515-bits

#####################################################

if operation == 3:
  print "Test Vector for Montgomery Multiplication\n"

  A = helpers.getRandomInt(512)
  B = helpers.getRandomInt(512)
  M = helpers.getModulus(512)

  A = 0xa84ff2f71071936d568335f4e31da1c104c831dc18d7b9199f5d96b9df7315bd0fa8db7a6201cf9ae0842c7f6797a025684296de2089f536c18b7a583c7a9fc5  
  B = 0xb9cf554dbc2f7d876274c0895b10c21a0322d9435a2cd1af43a483a61f7cfb92f984df1a0d9357bc796f8e582427a609d99348f8079de7731fc8a31b3eea6c6e
  M = 0xef449a8c29c1266af559bdb8d0c42c042b9a46f619b28d7094369f2842ebe42175eb00442338301d1a509aef69043c1dee3bc1f3a06da74e54d094bc7e4ec49b  

  C = HW.MontMul_512(A, B, M)
  D = (A*B*helpers.Modinv(2**512,M)) % M
  e = C - D
  
  print "A                = ", hex(A)         # 512-bits
  print "B                = ", hex(B)         # 512-bits
  print "M                = ", hex(M)         # 512-bits
  print "(A*B*R^-1) mod M = ", hex(C)         # 512-bits
  print "(A*B*R^-1) mod M = ", hex(D)         # 512-bits
  print "error            = ", hex(e)         
  
#####################################################

if operation == 4:

  print "Test Vector for Montgomery Exponentiation\n"

  X = helpers.getRandomInt(1024)
  E = helpers.getRandomInt(16)
  N = helpers.getModulus(1024)
  # Hardware values
  # X = 0xb55708a7f2daa5631117b7d03ec4d7992ccad8d7e22d891db1e03e15ad545a33fc9f444b1a16dbae60d527f8f7118db19d65258cb9977527fbfc19786b18ba76
  # E = 0xb1
  # M = 0xd9bf2caaf3992d7e456563271a7c22da97d772cf8fb8a8d34756a335657daf63eff091961c4ea3c56066c5822baa68d108e9b45d95aa98852b71d44daca7419f

  X =  0xd394854091a4bd576e831c047f8dbd3962c6176e4ac73a271b34d4d64a047fad949e7f5db4f2b561ac3054aa79f1ea1667392a6effc533fdb3910f7e0382a78a3e69c71b718dbfcb525d5ad61c6d04e9a99d80775e84c0ac2581853fb7dbbcbbbcdd23af4d92fcecc53baeeb63951386d4801e7eec875fefcdcc53e97e4d114f
  E =  0x8aa7
  N =  0xe463552f57f41ea0eba321a7207bedda838f187b75f5ed7af76f70d25b9a2c0d84e0b5943885d4c7682cf637fe44cce70610f8532fcaa42a56867970060e1237bf1feed8fd0f3441ae8bf2c011b530c1cf173a564f448e34b49ba79804bf4901cf6df0c2bc79bc4d90ff37b204f9addb4c4a72d2d9315b454fd2954279c5095d

  # M_prime = helpers.Modinv(M, 2**1024)
  C = HW.MontExp_1024(X, E, N)
  D = helpers.Modexp(X, E, N)
  e = C - D

  print "X = ", hex(X)           # 1024-bits
  print "E = ", hex(E)           # 16-bits

  r = 2**1024
  N_prime = (r - helpers.Modinv(N, r)) 
  
  print "N = ", hex(N) # 1024-bits
  print "N_prime = ", hex(N_prime) # 1024-bits
  print "(X^E) mod M = ", hex(C) # 1024-bits
  print "(X^E) mod M = ", hex(D) # 1024-bits
  print "error = ", hex(e) 

  helpers.print2array(X, 'x', 32)
  helpers.print2array(E, 'e', 1)
  helpers.print2array(N, 'n', 32)
  helpers.print2array(N_prime, 'n_prime', 32)
  helpers.print2array((r*r) % N, 'r2m', 32)
  helpers.print2array(r % N, 'rm', 32)
  helpers.print2array(C, 'expected', 32)
  import pdb; pdb.set_trace()
#####################################################

if operation == 5:

  print "Test Vector for RSA\n"

  print "\n--- Precomputed Values"

  # Generate two primes (p,q), and modulus
  [p,q,N] = helpers.getModuli(512)

  print "p            = ", hex(p)               # 512-bits
  print "q            = ", hex(q)               # 512-bits
  print "Modulus      = ", hex(N)               # 1024-bits

  # Generate Exponents
  [e,d] = helpers.getRandomExponents(p,q) 

  print "Enc exp      = ", hex(e)               # 16-bits
  print "Dec exp      = ", hex(d)               # 1024-bits

  # Generate Message
  M     = helpers.getRandomMessage(1024,N)

  print "Message      = ", hex(M)               # 512-bits

  # For CRT RSA
  x_p   = q * helpers.Modinv(q, p)              
  x_q   = p * helpers.Modinv(p, q)              

  print "x_p          = ", hex(x_p)             # 1024-bits
  print "x_q          = ", hex(x_q)             # 1024-bits

  # Since decryption exponent is 1024-bits large, 
  # the exponentiation will take a long time to execute. 
  # Therefore, the exponenet can be reduced to 512-bits
  # for optimizing the operation.
  # Following, condition is provided for this reduction:

  d_p = d % (p-1)                               
  d_q = d % (q-1)                               

  print "d_p          = ", hex(d_p)             # 512-bits
  print "d_q          = ", hex(d_q)             # 512-bits

  R       = 2**512
  Rp      = R % p
  Rq      = R % q
  R2p     = (R*R) % p
  R2q     = (R*R) % q
  R       = 2**1024
  R_1024  = R % N
  R2_1024 = (R*R) % N

  print "R_p          = ", hex(Rp)              # 512-bits
  print "R_q          = ", hex(Rq)              # 512-bits
  print "R2_p         = ", hex(R2p)             # 512-bits
  print "R2_q         = ", hex(R2q)             # 512-bits
  print "R_1024       = ", hex(R_1024)          # 1024-bits
  print "R2_1024      = ", hex(R2_1024)         # 1024-bits

  helpers.CreateConstants(M, p, q, N, e, d_p, d_q, x_p, x_q, Rp, Rq, R2p, R2q, R_1024, R2_1024, seed);
    
  #####################################################

  print "\n--- Execute RSA (For verification)"

  # Encrypt
  Ct1 = SW.MontExp_1024(M, e, N)                # 1024-bit exponentiation
  print "Ciphertext   = ", hex(Ct1)             # 512-bits

  # Decrypt
  Pt1 = SW.MontExp_1024(Ct1, d, N)              # 1024-bit exponentiation
  print "Plaintext    = ", hex(Pt1)             # 512-bits

  #####################################################

  print "\n--- Execute CRT RSA"

  #### Encrypt
  
  # Exponentiation, in Software
  Ct2 = SW.MontExp_1024(M, e, N)                # 1024-bit SW montgomery exp. 
  
  print "Ciphertext   = ", hex(Ct2)             # 1024-bits

  #### Decrypt

  # Reduction
  #
  # Here we reduce the ciphertext with p and q:
  #   Cp = Ciphertext mod p
  #   Cq = Ciphertext mod q
  #  
  # For this reduction, we divide the 1024-bit C
  # into two 512-bit blocks Ch and Cl such as:
  #   C = Ch * 2^512 + Cl
  #     = Ch * R     + Cl
  # 
  # Now we will reduce by using the formula:
  #   Cp = C mod p
  #      = (Ch * R + Cl)  mod p
  #      = (Ch * R^2 / R + Cl) mod p
  #      = (MontMul(Ch,R^2,p) + Cl) mod p
        
        # For verification, ignore these lines 
        # C_p = Ct2 % p;                        # 512-bits
        # C_q = Ct2 % q;                        # 512-bits        
        # print "Ciphertext_p = ", hex(C_p)     # 512-bits
        # print "Ciphertext_q = ", hex(C_q)     # 512-bits
  
  Ct2h = Ct2 >> 512;                            # 512-bits
  Ct2l = Ct2 % (2**512);                        # 512-bits

  tp   = HW.MontMul_512(Ct2h, R2p, p)           # 512-bits HW montgomery mult.
  tq   = HW.MontMul_512(Ct2h, R2q, q)           # 512-bits HW montgomery mult.

  Ct_p = (tp + Ct2l) % p                        # 512-bits HW/SW modular add.
  Ct_q = (tq + Ct2l) % q                        # 512-bits HW/SW modular add.

  print "Ciphertext_p = ", hex(Ct_p)            # 512-bits
  print "Ciphertext_q = ", hex(Ct_q)            # 512-bits

  # Exponentiation, in Hardware
  
        # Below two lines implement the exponentiation following
        # the algorithm that students will use in the lab sessions
        # However, as it will run so slow in python, they are commented here
        # If need to debug, by observing the intermediate values,
        # then can be uncommented.

  # P_p = HW.MontExp_512(Ct_p, d_p, p)           # 512-bit HW modular exp.
  # P_q = HW.MontExp_512(Ct_q, d_q, q)           # 512-bit HW modular exp.
  P_p = helpers.Modexp(Ct_p, d_p, p)            # 512-bit HW modular exp.
  P_q = helpers.Modexp(Ct_q, d_q, q)            # 512-bit HW modular exp.
  
  # Inverse CRT, in Software
  #
  # We need to execute the following operation to combine the 
  # two 512-bit partial plaintext results P_p and P_q for calculating
  # the final 1024-bit plaintext:
  # 
  #   Plaintext = (P_p*x_p + P_q*x_q) mod N;
  #               (512-bits * 1024-bits) + (512-bits * 1024-bits)
  #
  # To simplify this calculation we will use the following formula
  # with a 1024-bit montgomery multiplication function, implemented
  # in software
  #
  #   Plaintext =  (P_p*x_p + P_q*x_q) mod N;
  #             = ((P_p*x_p/R + P_q*x_q/R) * R^2 / R) mod N;
  #             = ((MontMul(P_p,x_p,N) + MontMul(P_q,x_q,N)) * R^2 / R) mod N
  #             =  MontMul((MontMul(P_p,x_p,N) + MontMul(P_q,x_q,N)), R^2, N) mod N

        # For verification, ignore these lines 
        # Pt2 = (P_p*x_p + P_q*x_q) mod N;
        # print "Plaintext_p  = ", hex(P_p)     # 512-bits
        # print "Plaintext_q  = ", hex(P_q)     # 512-bits
        # print "Pt2          = ", hex(Pt2)     # (512-bits * 1024-bits) + (512-bits * 1024-bits)

  tp      = SW.MontMul_1024(P_p,x_p,N);         # 1024-bit SW montgomery mult.
  tq      = SW.MontMul_1024(P_q,x_q,N);         # 1024-bit SW montgomery mult.
  s       = (tp + tq) % N                       # 1024-bit SW addition
  Pt3     = SW.MontMul_1024(s , R2_1024, N);    # 1024-bit SW montgomery mult.

  print "Plaintext    = ", hex(Pt3)             # 1024-bits

  print "\n\ntestvector.c file is created in this directory."


  