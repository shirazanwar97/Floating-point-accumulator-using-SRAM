import numpy as np
import sys, getopt
from struct import *

def float_to_hex(f):
  return hex(unpack('<I', pack('<f', f))[0])


def main(argv):
  try:
    opts, args = getopt.getopt(argv,"q:o:i:m:t:",["iDir=","oDir="])
  except getopt.GetoptError as err:
    print(err)  # will print something like "option -a not recognized"
    usage()
    sys.exit(2)

  testFileName=''
  for opt, arg in opts:
    if "-m" in opt:
      M = int(arg)
    elif "-t" in opt:
      testFileName = arg
    
  a = np.single(np.random.uniform(1,-1,size=M))


  a_address = 0x00000000

  aStr="// {} \n".format(M)
  aStr+=" @{:08X} {:08X}\n".format(a_address,M)
  for i,A in enumerate(a) :
    aStr+="// {:.7f} \n".format(A)
    aStr+=" @{:08X} ".format(a_address+i+1) + float_to_hex(A).replace('0x','') + "\n"
  with open(testFileName,"w") as F:
    F.write(aStr)

if __name__ == "__main__":
     main(sys.argv[1:])
