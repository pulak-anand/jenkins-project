import psutil
import sched, time
print ("hello pod info")
s=sched.scheduler(time.time,time.sleep)
def display(sc):
   cpu=psutil.cpu_percent(interval=10)
   mem=psutil.virtual_memory()
   print(f'CPU:{cpu}')
   print(f'Memory:{mem}')
   s.enter(2,1,display,(sc,))
s.enter(2,1,display,(s,))
s.run()
