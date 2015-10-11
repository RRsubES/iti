# need to have COL_MAX define before calling the pipeline
function repeat(ch, num,	i, tmp) {
	for(i = 0; i < num; i++)
		tmp = tmp ch
	return tmp
}

BEGIN {
	if (COL_MAX >= WIDTH_MAX) {
		print "oops: ", COL_MAX, "= COL_MAX >= WIDTH_MAX =", WIDTH_MAX > "/dev/stderr"
		exit 1
	}
	line_init = repeat(" ", 23)
	line = line_init
	pr_str = sprintf("%%-%ds\n", WIDTH_MAX)
	# keep header
	getline; print
}

# keep first line of the record
/^ {7}[A-Z0-9]{2,5} +[A-Z0-9]{2,5} +[0-9]{3} {5}[0-9]{3} +$/ {
	if (length(line) > length(line_init)) {
		printf(pr_str, line)
		line = line_init
	}
	printf(pr_str, $0)
	next
}

{
	n = split($0, ary, " ")
	for(i = 1; i <= n; i++) {
		if (length(line) + length(ary[i]) > COL_MAX) {
			printf(pr_str, line)
			line = line_init
		}
		line = line ary[i] " "
	}
}

# never forget the corner cases
END {
	printf(pr_str, line)
}
