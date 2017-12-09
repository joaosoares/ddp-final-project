FILES="src/testvector.c src/sw.c test/sw_test.c test/sw_test_Runner.c test/unity.c test/mock_xil_printf.c"
gcc $FILES -o sw_test_Runner && ./sw_test_Runner