import sys

#if len(sys.argv) == 1:
#    print(200000)
#else:
Powerout = (float(sys.argv[1]) - 298.15) * 3.14159265 * 0.1 * 0.1 * 0.22 / 0.005

#p = 611.21 * 2.718281828 ** ((18.678 - (float(sys.argv[1])-273.15)/234.5)*((float(sys.argv[1])-273.15)/(float(sys.argv[1])-16.01)))
#Powerin = float(sys.argv[2]) * 2256600 * 18.01528 * p/(1000 * 8.31446261815324 * float(sys.argv[1]))

print(Powerout + float(sys.argv[2]))
