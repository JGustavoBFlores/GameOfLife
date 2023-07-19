set terminal gif animate delay 15
set output "output.gif"

list = system('cat listOfFiles')
j =0
do for [i in list] {
j=j+1
set title center "Game of Life \n {/*0.9 iteration = ".j." }" font ",20"
unset key
set tic scale 0

set palette negative defined (0 0 0 0,1 1 1 1) 
unset colorbox

set cbrange[0:1]

#xrange must be -0.5,ixwidth-0.5
set xrange [-0.5:19.5] # Edit this range to fit all the cells
#yrange must be -0.5,iywidth-0.5
set yrange [-0.5:19.5] # Edit this range to fit all the cells

#unset xtics
#unset ytics

set view map
plot i matrix with image
reread
}
set output
