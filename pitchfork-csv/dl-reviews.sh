#!/bin/bash
for (( N=0 ; N < 831 ; N++ )) ; curl -o "$N-review.html" --retry 2 "http://pitchfork.com/reviews/albums/$N/"; sleep $((N%2+1)) ; done
