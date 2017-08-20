A = [1 2; 3 4; 5 6]

size(A)

v = [1 2 3 4]

length(v)

A = [1 2; 3 4; 5 6]

A(3,2)

#fetch everything in a second row
A(2, :)

#fetch everything in a second column
A(:, 2)

# get all columns of A from 1 and 3 rows

A([1 3], :)

#put all elements of A into a single column vector
A(:)


# matrix concatenation
B = [ 1 2; 3 4; 5 6]
C = [11 12; 13 14; 15 16]

D=[B C]