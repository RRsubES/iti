# need to have COL_MAX define before calling the pipeline
function repeat(ch, num,	i, tmp) {
	for(i = 0; i < num; i++)
		tmp = tmp ch
	return tmp
}

BEGIN {
	line_init = repeat(" ", 23)
	line = line_init
	header = ""
	# keep header
	getline; print
}

# keep first line of the record
/ {7}[A-Z0-9]{3,5} {3,5}[A-Z0-9]{3,5} {3,5}[0-9]+ {5,}[0-9]+/ {
	if (length(line) > length(line_init)) {
		printf("%-80s\n", line)
		line = line_init
	}
	printf("%80s\n",  $0)
	next
}

# process of the beacons once the record has been detected
/( {23})?([A-Z0-9]{3,5}\/?)( [A-Z0-9]{3,5}\/?)* */ {
	n = split($0, ary, " ")
	for(i = 1; i <= n; i++) {
		if (length(line) + length(ary[i]) + 1 >= COL_MAX) {
			printf("%-80s\n", line)
			line = line_init
		}
		line = line ary[i] " "
	}
}

# never forget the corner cases
END {
	printf("%-80s\n", line)
}