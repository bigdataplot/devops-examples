import time

count = 0
while True:
    count = count + 1
    print(str(count) + ". This prints once every 10 secs.")
    time.sleep(10)