set terminal gif animate delay 15
set output "output.gif"

list = system('cat listOfFiles')
j =0
do for [i in list] {
j=j+1
set title center "Game of Life \n {/*0.9 iteration = ".j." }" font ",20"
unset key
set tic scale 0

set palette negative defined (0 0 0 0,1 1 1 1) #negative so 0=white,1=black
unset colorbox #to erase the color reference

set cbrange[0:1]

#xrange must be -0.5,ixwidth-0.5
set x2range [-0.5:19.5] #x2 to place label above graph

#yrange must be -0.5,iywidth-0.5
set yrange [19.5:-0.5]

set xtics format ""
#x2tics must be 1,prefered Step,ixwidth
set x2tics 1,2,20 
#ytics must be 1,prefered Step,iywidth
set ytics 1,2,20 

set grid

set view map
plot i matrix with image axes x2y1
reread
}
set output
