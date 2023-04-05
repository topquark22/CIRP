#!/bin/sh

TIDY=/usr/local/bin/tidy

# tidy adds an extra blank line at the end of a file. Strip it off
striplast() {
  awk 'BEGIN	{ first = 1 }

             	{ if (first == 1) {
		    first = 0;
		    prev = $0
		  } else {
		    print prev;
		    prev = $0
		  }
		}'
}

${TIDY} -i -asxml | striplast
