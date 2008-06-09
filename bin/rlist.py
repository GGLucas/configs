#!/usr/bin/python
import os,time,random,sys

FILES = []
def adddir(dir):
 for file in os.listdir(dir):
  if os.path.isdir(dir+'/'+file):
   adddir(dir+'/'+file)
  else:
   FILES.append(dir+'/'+file)

if __name__ == '__main__':
    adddir(sys.argv[2]) 

    while True:
        time.sleep(float(sys.argv[1]))
        os.system('gqview -r "'+random.choice(FILES).replace('"','\\"')+'"')
