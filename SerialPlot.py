# import library
import time
import matplotlib
import matplotlib.pylab as plt
import serial

# inisialisasi port serial
s=serial.Serial('com6', 2400)

def readlineCR(port):   # Fungsi khusus buat baca feed data serial (string) dari vCOM 
    rv = ""             # dengan terminator carriage return (CR) / '\r' atau ''
    while True:
        ch = port.read()
        rv += ch
        if ch=='\r' or ch=='':
            return rv

# Proses buat Figure grafik sama inisialisasi datanya
fig = plt.figure()
ax1 = fig.add_subplot(1, 1, 1)

ax1.cla()
ax1.set_title('Suhu vs Waktu')
ax1.set_xlabel('Waktu (s)')
ax1.set_ylabel('Suhu (C)')

plt.ion()  # Set interactive mode ON, so matplotlib will not be blocking the window
plt.show(False)  # Set to false so that the code doesn't stop here

cur_time = time.time()
ax1.hold(True)

x, y = [], []
times = [time.time() - cur_time]  # Create blank array to hold time values
y.append(0)
plt.grid(True, 'both')
line1, = ax1.plot(times, y, 'ro-', label='Suhu')

fig.show()
fig.canvas.draw()

background = fig.canvas.copy_from_bbox(ax1.bbox) # cache the background

tic = time.time()

i = 0

# Proses feeding data ke plot grafik
while True:
    fields = int(float(readlineCR(s)))
    times.append(time.time() - cur_time)
    y.append(fields)
    # this removes the tail of the data so you can run for long hours. You can cache this
    # and store it in a pickle variable in parallel.
    if len(times) > 50:
        y.pop(0)
        times.pop(0)
        
    # axis plot adaptif terhadap data
    xmin, xmax, ymin, ymax = [min(times), max(times)+0.5, min(y)-5,max(y)+5]
    # feed the new data to the plot and set the axis limits again
    line1.set_xdata(times)
    line1.set_ydata(y)
    plt.axis([xmin, xmax, ymin, ymax])
 
    # blit = true, ambil background, data aja yang di draw terus
    fig.canvas.restore_region(background)    # restore background
    ax1.draw_artist(line1)                   # redraw just the points
    fig.canvas.blit(ax1.bbox)                # fill in the axes rectangle
    fig.canvas.flush_events()

    i += 1

