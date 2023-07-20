instructions=input()
instruction=instructions.split()
hexcode=[]
for i in range(len(instruction)):
  if (instruction[i]=='ADA'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '000')
  elif(instruction[i]=='ADC'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '010')
  elif(instruction[i]=='ADZ'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '001')
  elif(instruction[i]=='AWC'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '011')
  elif(instruction[i]=='ACA'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '100')
  elif(instruction[i]=='ACC'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '110')
  elif(instruction[i]=='ACZ'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '101')
  elif(instruction[i]=='ACW'):
    hexcode.append('0001'+ instruction[i+1] + instruction[i+2] + instruction[i+3] + '111')
  elif(instruction[i]=='ADI'):
    hexcode.append('0000'+ instruction[i+1] + instruction[i+2] + instruction[i+3])
  elif(instruction[i]=='NDU'):
    hexcode.append('0010'+ instruction[i+1] + instruction[i+2] + instruction[i+3]+'000')
  elif(instruction[i]=='NDC'):
    hexcode.append('0010'+ instruction[i+1] + instruction[i+2] + instruction[i+3]+'010')
  elif(instruction[i]=='NDZ'):
    hexcode.append('0010'+ instruction[i+1] + instruction[i+2] + instruction[i+3]+'001')
  elif(instruction[i]=='NCU'):
    hexcode.append('0010'+ instruction[i+1] + instruction[i+2] + instruction[i+3]+'100')
  elif(instruction[i]=='NCC'):
    hexcode.append('0010'+ instruction[i+1] + instruction[i+2] + instruction[i+3]+'110')
  elif(instruction[i]=='NCZ'):
    hexcode.append('0010'+ instruction[i+1] + instruction[i+2] + instruction[i+3]+'101')
  elif(instruction[i]=='LLI'):
    hexcode.append('0011'+ instruction[i+1] + instruction[i+2]) 
  elif(instruction[i]=='LW'):
    hexcode.append('0100'+ instruction[i+1] + instruction[i+2]+ instruction[i+3])
  elif(instruction[i]=='SW'):
    hexcode.append('0101'+ instruction[i+1] + instruction[i+2]+ instruction[i+3])
  elif(instruction[i]=='LM'):
    hexcode.append('0110'+ instruction[i+1] + instruction[i+2])
  elif(instruction[i]=='SM'):
    hexcode.append('0111'+ instruction[i+1] + instruction[i+2])
  elif(instruction[i]=='BEQ'):
    hexcode.append('1000'+ instruction[i+1] + instruction[i+2]+ instruction[i+3])
  elif(instruction[i]=='BLT'):
    hexcode.append('1001'+ instruction[i+1] + instruction[i+2]+ instruction[i+3])
  elif(instruction[i]=='BLE'):
    hexcode.append('1001'+ instruction[i+1] + instruction[i+2]+ instruction[i+3])
  elif(instruction[i]=='JAL'):
    hexcode.append('1100'+ instruction[i+1] + instruction[i+2])
  elif(instruction[i]=='JLR'):
    hexcode.append('1001'+ instruction[i+1] + instruction[i+2]+ instruction[i+3])
  elif(instruction[i]=='JRI'):
    hexcode.append('1111'+ instruction[i+1] + instruction[i+2]+ instruction[i+3])
for	i in range(2):
    for k in range(len(hexcode)):
       print('memory('+str(len(hexcode)*i+k)+')<="'+str(hexcode[k])+'";')