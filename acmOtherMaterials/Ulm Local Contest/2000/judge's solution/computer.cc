// Problem   Simple Computer
// Algorithm Simulation
// Runtime   O(n)
// Author    Walter Guttmann
// Date      26.04.2000

#include <cassert>
#include <fstream>

ifstream in ("computer.in");

bool read_byte (int &x)
{
  x = 0;
  for (int b=0 ; b<8 ; b++)
  {
    char ch;
    if (! (in >> ws >> ch)) return false;
    assert (ch == '0' || ch == '1');
    x = (x << 1) + (ch - '0');
  }
  return true;
}

main ()
{
  int pc,accu,mem[32];
  while (read_byte (mem[0]))
  {
    for (int i=1 ; i<32 ; i++)
      assert (read_byte (mem[i]));
    pc = accu = 0;
    for (bool halt = false ; ! halt ; )
    {
      int instr = mem[pc];
      pc = (pc + 1) % 32;
      switch (instr >> 5)
      {
        case 0: mem[instr & 0x1f] = accu; break; // STA
        case 1: accu = mem[instr & 0x1f]; break; // LDA
        case 2: if (accu == 0) pc = instr & 0x1f; break; // BEQ
        case 3: break; // NOP
        case 4: accu = (accu + 255) % 256; break; // DEC
        case 5: accu = (accu + 1) % 256; break; // INC
        case 6: pc = instr & 0x1f; break; // JMP
        case 7: halt = true; break; // HLT
        default: assert (0);
      }
    }
    for (int b=7 ; b>=0 ; b--)
      cout << ((accu >> b) & 1);
    cout << endl;
  }
  return 0;
}

