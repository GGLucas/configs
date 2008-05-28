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
    adddir(sys.argv[1]) 

    while True:
        time.sleep(3)
        os.system('gqview -r "'+random.choice(FILES).replace('"','\\"')+'"')
