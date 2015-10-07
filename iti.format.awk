# need to have COL_MAX define before calling the pipeline
function repeat(ch, num,	i, tmp) {
	for(i = 0; i < num; i++)
		tmp = tmp ch
	return tmp
}

BEGIN {
	line_init = repeat(" ", 23)
	line = line_init
	pr_minus = sprintf("%%-%ds\n", WIDTH_MAX)
	pr_plus = sprintf("%%%ds\n", WIDTH_MAX)
	header = ""
	# keep header
	getline; print
}

# keep first line of the record
/ {7}[A-Z0-9]{3,5} {3,5}[A-Z0-9]{3,5} {3,5}[0-9]+ {5,}[0-9]+/ {
	if (length(line) > length(line_init)) {
		printf(pr_minus, line)
		line = line_init
	}
	printf(pr_plus,  $0)
	next
}

# process of the beacons once the record has been detected
/( {23})?([A-Z0-9]{3,5}\/?)( [A-Z0-9]{3,5}\/?)* */ {
	n = split($0, ary, " ")
	for(i = 1; i <= n; i++) {
		if (length(line) + length(ary[i]) + 1 >= COL_MAX) {
			printf(pr_minus, line)
			line = line_init
		}
		line = line ary[i] " "
	}
}

# never forget the corner cases
END {
	printf(pr_minus, line)
}
