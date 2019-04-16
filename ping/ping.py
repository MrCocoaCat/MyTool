# -*- coding: UTF-8 -*-
import os
import subprocess
import sys
import threading
import Queue
import time
import bisect

ROOT = os.path.dirname(os.path.realpath(__file__))
network_prefix="192.168.125"
host_num_list=range(1,255)
queue = Queue.Queue()

def run_command(cmd, redirect_output=True, check_exit_code=True):
    """
    Runs a command in an out-of-process shell, returning the
    output of that command.  Working directory is ROOT.
    执行命令，在一个程序外的shell进程,
    执行目录为ROOT
    """
    # subprocess模块用于产生子进程
    # 如果参数为redirect_output ，则创建PIPE
    if redirect_output:
        stdout = subprocess.PIPE
    else:
        stdout = None
    # cwd 参数指定子进程的执行目录为ROOT，执行cwd 函数
    proc = subprocess.Popen(cmd, cwd=ROOT, stdout=stdout)
    # 如果子进程输出了大量数据到stdout或者stderr的管道，并达到了系统pipe的缓存大小的话，
    # 子进程会等待父进程读取管道，而父进程此时正wait着的话，将会产生死锁。
    # Popen.communicate()这个方法会把输出放在内存，而不是管道里，
    # 所以这时候上限就和内存大小有关了，一般不会有问题。
    # 使用communicate() 返回值为 (stdoutdata , stderrdata )
    output = proc.communicate()[0]
    if check_exit_code and proc.returncode != 0:
        # 程序不返回0，则失败
        raise Exception('Command "%s" failed.\n%s' % (' '.join(cmd), output))
    return output

def run_ping(host_num):
  #print("start thread at i%s" % time.ctime())
  ip = network_prefix + "."+ str(host_num)
  re = run_command(["ping","-c","5",ip], redirect_output=True, check_exit_code=False)
  #print(type(re))
  list1 = re.split("\n")
  re = list1[-3].replace('5 packets transmitted, ','')
  queue.put((host_num,ip,re))
  #print(re)
  return re
 

if __name__ == '__main__':

 start_time = time.time()
 ThreadList = []
 res = []
 for host_num in host_num_list:
    t1 = threading.Thread(target=run_ping, args=(host_num,))
    # 守护线程，在主线程结束时自动结束运行
    t1.setDaemon(True)
    t1.start()
    ThreadList.append(t1)
 for t in ThreadList:
    t.join()
 #queue.sort()
 while not queue.empty():
    tem= queue.get()
    bisect.insort(res,tem)
 for i in range(len(res)):
    a = res[i][1] +": "+ res[i][2]
    print a

 #print res
 end_time = time.time()
 print("all end cost %f seconds"% (end_time - start_time) )
